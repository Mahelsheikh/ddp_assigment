# Loading Required Libraries and dataset(s)
library(shiny)
library(caret)
library(randomForest)
library(e1071)

data(iris)

# Define server logic
shinyServer(function(input, output) {
    # Creating Partition
    # Defining partition index
    inTrain  <-
        reactive({
            createDataPartition(iris$Species, p = input$bins, list = FALSE)
        })
    
    # Reading predictors based on user input and joining them together 
    # so that it can collectively be used as a formula while training the model
    inPredictors <-
        reactive({
            paste(input$selPredictors, collapse = "+")
        })
    
    # Creating training / test dataset
    training <- reactive({
        iris[inTrain(), ]
    })
    testing  <- reactive({
        iris[-inTrain(), ]
    })
    
    # Setting Seed
    set.seed(1234)
    
    # Defining the constand predictor "Species" for "IRIS" dataset
    Predictor <- "Species"
    
    # Creating "trainControl()" based on user inputs
    ctrl <- reactive({
        if (input$selCrossValidation) {
            trainControl(
                method = input$cvMethod,
                number = input$noOfFolds,
                allowParallel = TRUE
            )
        }
        else{
            trainControl(method = "none", allowParallel = TRUE)
        }
    })
    
    # Creating the model. Passing user-selection predictors as formula and traing control.
    # The method is random forest (rf)
    mf <-
        reactive({
            train(
                as.formula(paste(Predictor, "~", inPredictors())),
                data = training(),
                method = "rf",
                trControl = ctrl()
            )
        })
    
    # Extracting in-sample accuracy
    iAcc <- reactive({
        round(mean(mf()$resample$Accuracy) * 100, 2)
    })
    
    # Applying the model to test dataset for prediction
    pred <- reactive({
        predict(mf(), testing())
    })
    
    # Creating confusion matrix to verify model accuracy
    cm <- reactive({
        confusionMatrix(pred(), testing()$Species)
    })
    
    # Extracting out-of-sample accuracy
    oosA <- reactive({
        cm()$overall['Accuracy']
    })
    oAcc <- reactive({
        round(oosA() * 100, 2)
    })
    
    # Rendering the model
    output$model <- renderPrint(mf())
    
    # Rendering in-smaple accuracy
    output$inSampleAccuracy <-
        renderText(paste("In-Sample Accuracy is", iAcc(), '%'))
    
    # Rendering the confusion matrix on test dataset
    output$CM <- renderPrint(cm())
    
    # Rendering out-of-sample accuracy
    output$outSampleAccuracy <-
        renderText(paste("Out-of-Sample Accuracy is", oAcc(), '%'))
    
    # Rendering variable importance plot
    output$plot1 <- renderPlot({
        plot(varImp(mf(), scale = FALSE, xlab = "Importance", title = "Plotting Variable Importance"))
    })

    output$strIRIS <- renderPrint(str(iris))
})

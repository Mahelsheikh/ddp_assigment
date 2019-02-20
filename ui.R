# Loading Required Libraries
library(shiny)
library(caret)
library(randomForest)
library(e1071)

# Define UI for application that demo "random forest" regression on "IRIS dataset
shinyUI(fluidPage(
    # Application title
    titlePanel("Running 'Random Forest' Classification On 'IRIS' Dataset"),
    
    # Sidebar
    sidebarLayout(
        sidebarPanel(
            h3("Create Training/Test Sets"),
            sliderInput(
                "bins",
                "Select Partition Value",
                min = .1,
                max = .9,
                value = 0.7,
                step = 0.05
            ),
            h3("Select Predictors"),
            checkboxGroupInput(
                "selPredictors",
                "Select predictor variable(s) (atleast 1 required) ",
                c(
                    "Sepal.Length" = "Sepal.Length",
                    "Sepal.Width"  = "Sepal.Width",
                    "Petal.Length" = "Petal.Length",
                    "Petal.Width"  = "Petal.Width"
                ),
                selected = c("Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width")
            ),
            h3("Resampling Method"),
            checkboxInput("selCrossValidation",
                          "Peform Resampling", value = FALSE),
            radioButtons(
                "cvMethod",
                "Select Resampling Method",
                c(
                    "Bootstrap" = "boot",
                    "Cross Validation" = "cv",
                    "Leave One Out Cross Validation" = "LOOCV",
                    "None"      = "none"
                ),
                selected = c("cv")
            ),
            numericInput("noOfFolds", "Number of Folds: ", 5, 2, 10, step = 1),
            submitButton("Submit", icon("refresh"))
        ),
        # Main Panel to display model and associated plots
        mainPanel(
            tabsetPanel(type = "tabs",
                        tabPanel(h3("Model"),
            verbatimTextOutput("model"),
            h3(textOutput("inSampleAccuracy")),
            h3("Confustion Matrix (On Test Set)"),
            verbatimTextOutput("CM"),
            h3(textOutput("outSampleAccuracy")),
            h3("Plotting Variable Importance"),
            plotOutput("plot1")),
            tabPanel (h3("Help"),
                      h3("About the App"),
                      p("This application is a simple demonstration of running 'random forest' classification.
                        It shows the impact of a subset of choices made for training the model and their impact."),
                      p("The application uses the 'IRIS' dataset which has the following structure:"),
                      verbatimTextOutput("strIRIS"),
                      h3("User Selection Option"),
                      p("The user can select from the following options:"),
                      h5("1. Selecting Partition value for training and test datasets"),
                      p("Default: 0.7 (70%: 70% Training, 30% Testing)"),
                      h5("2. Predictor Variables Selection"),
                      p("Default: All 4. Please note that at least 1 predictor should be selected otherwise an error will be thrown."),
                      h5("3. Resampling Method"),
                      p("Default: Not Selected. If selected, there are 4 options includes: "),
                      p("Bootstrapping, Cross Validation, Leave one out Cross Validation, None"),
                      h5("4. Number of Folds for cross validation/bootstrap"),
                      p("Default: 5"),
                      h3("Output (Model Tab)"),
                      p("Based on user selection, the model gets trained and gets applied to testing Dataset. Following information is included:"),
                      h5("1. The Model"),
                      p(" Please note the different parameters as they change based on user inputs."),
                      h5("2. In-Sample Accuracy"),
                      p("When the model gets trained. Note that for method 'none', the accuracy is not displayed. Can you think of why?"),
                      h5("3. Confusion Matrix"),
                      p("When the model is applied to testing set"),
                      h5("4. Out-of-Sample Accuracy"),
                      p("When the model is applied to testing set"),
                      h5("5. Variable Importance Plot"),
                      p("It shows the relative importance of different predictors in the model."),
                      h3("Author"),
                      h5(br("Anuj Parashar")),
                      h5(a("Contact Me", href="promisinganuj@gmail.com"))
                      )
        ))
    )
))

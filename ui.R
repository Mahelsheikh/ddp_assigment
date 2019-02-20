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
            h3("Model"),
            verbatimTextOutput("model"),
            h3(textOutput("inSampleAccuracy")),
            h3("Confustion Matrix (On Test Set)"),
            verbatimTextOutput("CM"),
            h3(textOutput("outSampleAccuracy")),
            h3("Plotting Variable Importance"),
            plotOutput("plot1")
        )
    )
))

#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#


library(shiny)

shinyUI(fluidPage(
     theme ='bootstrap.css',
     titlePanel(
         h1("Prediction of Child health related Risks and Deprivation on Multinomial Regression Models")),
    sidebarLayout(
        sidebarPanel(
            selectInput("packages","Select the model",choices = c("Model Selection"= "ModelSelect","multinom"="multinom","mlogit"="mlogit")),
            checkboxGroupInput("Independentvar","Select the Independent variables-Deprivation Domains",choices =as.list(names(datatrain)[c(6,9,12,15,18,21,24,27,30)]))),
        
        # Show a plot of the generated distribution
        mainPanel( tabsetPanel(
            tabPanel("Summary", helpText("Your Selected variables"),
                     verbatimTextOutput("other_val_show")), 
            tabPanel("Exponential coefficients", helpText(" the exponential of the coefficients are"),
                     verbatimTextOutput("exp")), 
            tabPanel("Fitted", helpText("fitted"),
                     verbatimTextOutput("fit"))
        )
                 
)
)
)
)




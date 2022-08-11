#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(nnet)
library(mlogit)
library(caret)



# Define server logic required to draw a histogram
shinyServer<-function(input, output) { 
  selectedData <- reactive({ datatrain[, c("IndicatorName", input$Independentvar)]
  
   })
  
    output$other_val_show<-renderPrint({
      if(is.null(input$Independentvar)){"You have to select altleast one deprivation Domain"}
      else{
        f<-selectedData()
        
      if (input$packages == "ModelSelect"){"You have to select altleast one deprivation Domain"}
      if(input$packages =="multinom"){
        f$IndicatorName2<- relevel(f$IndicatorName, ref= "Infant mortality rate")
        
        form <- sprintf("%s~%s","IndicatorName2",paste0(input$Independentvar,collapse="+"))
        print(form)
        
        package1<-multinom(as.formula(form),data=f)
        print(summary(package1))
        z <- summary(package1)$coefficients/summary(package1)$standard.errors
        print(paste0("2 tailed z-test"))
        print (z)
        p <- (1 - pnorm(abs(z), 0, 1)) * 2
        
        print(paste0("P values are"))
        print (p)
      }
      if(input$packages =="mlogit"){ 
        mdata<- mlogit.data(selectedData(), varying=NULL, choice="IndicatorName",shape="wide")
        mdata
        form <- sprintf("%s|%s","IndicatorName~1",paste0(input$Independentvar,collapse="+"))
        print(form)
        
        model <-mlogit(as.formula(form),data=mdata, reflevel="Infant mortality rate")
        print(summary(model))
        
      }
      }
      
    })
    
    
    output$exp<-renderPrint({
      if(is.null(input$Independentvar)){"The exponential of the coefficients....."}
      
    else{
      fa<-selectedData()
      if (input$packages == "ModelSelect"){"You have to select altleast one deprivation Domain"}
    
    if(input$packages =="multinom"){
      fa$IndicatorName2<- relevel(fa$IndicatorName, ref= "Infant mortality rate")
      form <- sprintf("%s~%s","IndicatorName2",paste0(input$Independentvar,collapse="+"))
      print(form)
      package1<-multinom(as.formula(form),data=fa)
      print(exp(coef(package1)))
      
    }
    
      if(input$packages =="mlogit"){ 
      library(caret)
      mdata<- mlogit.data(fa, varying=NULL, choice="IndicatorName",shape="wide")
      mdata
      form <- sprintf("%s|%s","IndicatorName~1",paste0(input$Independentvar,collapse="+"))
      print(form)
      
      model <-mlogit(as.formula(form),data=mdata, reflevel="Infant mortality rate")
      exp(coef(model))
      
    }
    }
    
    })
    
    output$fit<-renderPrint({
      if(is.null(input$Independentvar)){"The predicted values"}
      
      else{
        fa<-selectedData()
        if (input$packages == "ModelSelect"){"You have to select altleast one deprivation Domain"}
        
        if(input$packages =="multinom"){
          fa$IndicatorName2<- relevel(fa$IndicatorName, ref= "Infant mortality rate")
          form <- sprintf("%s~%s","IndicatorName2",paste0(input$Independentvar,collapse="+"))
          print(form)
          package1<-multinom(as.formula(form),data=fa)
          print(head(fitted(package1)))
         fa$classpredicted <- predict(package1, newdata = fa, "class") 
         # Building classification table
         tab <- table(fa$IndicatorName, fa$classpredicted)
         
         # Calculating accuracy - sum of diagonal elements divided by total obs
         r<-round((sum(diag(tab))/sum(tab))*100,2)
         print(paste0("Accuracy: ", r))
        }
        
        if(input$packages =="mlogit"){ 
          library(caret)
          mdata<- mlogit.data(fa, varying=NULL, choice="IndicatorName",shape="wide")
          mdata
          form <- sprintf("%s|%s","IndicatorName~1",paste0(input$Independentvar,collapse="+"))
          print(form)
          
          model <-mlogit(as.formula(form),data=mdata, reflevel="Infant mortality rate")
          head(fitted(model))
         
          
         
        }
      }
      
      
    })
    
}




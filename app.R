library(shiny)
library(imager)
library(ggplot2)
library(rpart)
library(e1071)
library(caret)
library(klaR)
library(randomForest)
library(shinythemes)

# Load trained models
load("models.RData")

# Feature extraction
extract_features <- function(img_path) {
  img <- load.image(img_path)
  if (spectrum(img) == 3) img <- grayscale(img)
  v <- as.vector(img)
  return(data.frame(mean = mean(v), sd = sd(v), min = min(v), max = max(v)))
}

ui <- fluidPage(
  theme = shinytheme("flatly"),
  
  tags$head(
    tags$style(HTML("
      .title-img {
        display: block;
        margin-left: auto;
        margin-right: auto;
        width: 200px;
        padding-bottom: 10px;
      }
    "))
  ),
  
  titlePanel(NULL),
  tags$img(src = "brain_banner.png", class = "title-img"),
  h2("🧠 Brain MRI Tumor Detector", align = "center"),
  
  sidebarLayout(
    sidebarPanel(
      h4("Upload MRI Image"),
      fileInput("image", "Choose a PNG/JPG File", accept = c(".png", ".jpg", ".jpeg")),
      
      hr(),
      h4("Select Model"),
      radioButtons("model", "", choices = c("Decision Tree", "Naive Bayes", "Random Forest")),
      
      actionButton("predict", "🔍 Predict", class = "btn btn-primary"),
      
      hr(),
      h4("📊 Prediction Result"),
      verbatimTextOutput("result")
    ),
    
    mainPanel(
      h4("🖼 Uploaded Image"),
      imageOutput("mriImage", height = "300px"),
      
      hr(),
      h4("🔍 Feature Importance (Random Forest)"),
      plotOutput("importancePlot")
    )
  )
)

server <- function(input, output) {
  
  img_path <- reactiveVal(NULL)
  features <- reactiveVal(NULL)
  
  observeEvent(input$image, {
    req(input$image)
    img_path(input$image$datapath)
    features(extract_features(input$image$datapath))
  })
  
  output$mriImage <- renderImage({
    req(img_path())
    list(src = img_path(), contentType = "image/png", width = 300)
  }, deleteFile = FALSE)
  
  observeEvent(input$predict, {
    req(features())
    
    test_feat <- features()
    pred <- switch(input$model,
                   "Decision Tree" = predict(pruned_tree, test_feat, type = "class"),
                   "Naive Bayes" = predict(bn_model, test_feat)$class,
                   "Random Forest" = predict(rf_model, test_feat)
    )
    
    output$result <- renderText({
      paste("Prediction:", toupper(pred))
    })
    
    output$importancePlot <- renderPlot({
      if (input$model == "Random Forest") {
        varImpPlot(rf_model, main = "Random Forest Variable Importance")
      } else {
        plot.new()
        text(0.5, 0.5, "No feature importance for this model", cex = 1.2)
      }
    })
  })
}

shinyApp(ui, server)

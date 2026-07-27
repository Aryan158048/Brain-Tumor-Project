# 🧠 Brain MRI Tumor Detector (Shiny App)

Classifies brain MRI images as tumor / non-tumor using classical ML models trained on pixel statistics.

**Live app**: https://aryan-upadhyay.shinyapps.io/project/

## What this does

This is an interactive R Shiny application that lets a user upload a brain MRI image and get an instant tumor / non-tumor classification. Instead of a deep learning model, it extracts simple pixel-intensity statistics (mean, standard deviation, min, max) from each image and feeds them into a choice of three trained classical ML classifiers, then displays the prediction along with a feature-importance view for the Random Forest model.

## Tech stack

- **Language**: R
- **App framework**: Shiny (`shinythemes::flatly` theme)
- **Image handling**: `imager`
- **Models**: `rpart` (pruned decision tree), `e1071`/`klaR` (Naive Bayes), `randomForest`
- **Evaluation**: `pROC` for ROC curve comparison across models
- **Deployment**: shinyapps.io

## Key features

- Upload brain MRI images (`.jpg`, `.png`) and classify them in-browser
- Extracts pixel-based features (mean, SD, min, max) rather than using raw pixels/CNNs
- Choose between 3 trained classifiers: Decision Tree (pruned), Naive Bayes, Random Forest
- Instant predictions with Random Forest feature-importance visualization
- Includes the labeled training dataset (`brain_tumor_dataset/`) and an ROC curve comparison (`ROC_Comparison.png`) across models

## How to run it locally

Requires R (≥ 4.0):

```r
install.packages(c("shiny", "shinythemes", "imager", "ggplot2", "rpart", "e1071", "caret", "klaR", "randomForest", "pROC"))
```

Then, from the project directory:

```r
shiny::runApp("app.R")
```

To retrain the models from scratch (uses `brain_tumor_dataset/`), run `brainTumor.R`, which produces `models.RData` (loaded by `app.R`) and the ROC curve comparison.

## Screenshots / demo

- `brain_banner.png` — app banner
- `Screenshot 2025-04-23 at 12.27.36 PM.png` — app UI
- `ROC_Comparison.png` — ROC curve comparison across Decision Tree and Naive Bayes models

## Scope note

The classifiers use hand-engineered pixel statistics (mean/SD/min/max), not a CNN or deep-learning image model — worth knowing going in if you're expecting a deep learning pipeline. This is a solo project.

# 🍳 Cook It Up

### AI-Powered Recipe Recommendation & Food Recognition System

An intelligent mobile application that recommends personalized recipes based on user preferences and identifies food dishes from uploaded images using advanced Artificial Intelligence models.

## 🎥 Demo

https://github.com/user-attachments/assets/2c8064e5-4f53-41ac-bb04-57d9680045df

---

## 🎯 Food Recognition Accuracy

# **96.499%**

---

## 🎓 Overview

**Cook It Up** is a graduation project that combines **Computer Vision**, **Machine Learning**, and **Recommendation Systems** to create an intelligent cooking assistant.

The application helps users discover meals tailored to their needs while also allowing them to identify unknown food dishes through image recognition technology.

By leveraging advanced AI models, Cook It Up provides a personalized and user-friendly cooking experience that simplifies meal planning and food discovery.

---

## ✨ Features

### 📸 Food Recognition

Upload a photo of a food dish and let the AI model identify it automatically.

### 🥗 Personalized Recipe Recommendations

Receive customized recipe suggestions based on:

* Available ingredients
* Maximum cooking time
* Calorie preferences

### 🤖 AI-Driven Recommendations

Combines multiple recommendation techniques to improve relevance and recommendation quality.

### 📱 Cross-Platform Mobile Experience

Developed with Flutter to provide a responsive and modern mobile experience.

---

## 🧠 AI Models

| Model                     | Purpose                                                                                         |
| ------------------------- | ----------------------------------------------------------------------------------------------- |
| DenseNet-201              | Food image classification and recipe recognition                                                |
| Content-Based Filtering   | Recipe recommendation based on ingredient and recipe similarity                                 |
| Knowledge-Based Filtering | Recommendations based on user constraints such as ingredients, cooking time, and calorie intake |

---

## 📈 Model Performance

The food recognition model achieved an accuracy of **96.499%** for identifying recipe names from uploaded food images.

This performance demonstrates the effectiveness of the deep learning pipeline and recommendation framework used throughout the project.

---

## 🏗️ System Architecture

```
┌──────────────────────────────┐
│         Flutter App          │
└──────────────┬───────────────┘
               │
               ▼
┌──────────────────────────────┐
│          Flask API           │
└───────┬─────────┬────────────┘
        │         │
        │         │
        ▼         ▼

┌─────────────┐   ┌─────────────────────┐
│ DenseNet-201│   │ Recommendation      │
│ Food Image  │   │ Engine              │
│ Recognition │   └──────────┬──────────┘
└─────────────┘              │
                             │
                  ┌──────────┴──────────┐
                  ▼                     ▼

         ┌────────────────┐   ┌────────────────┐
         │ Content-Based  │   │ Knowledge-Based│
         │   Filtering    │   │   Filtering    │
         └────────────────┘   └────────────────┘

```

---

## 🛠️ Technology Stack

### Mobile Application

* Flutter
* Dart

### Backend

* Flask
* Python

### Machine Learning & Data Science

* TensorFlow
* Keras
* Scikit-learn
* NumPy
* Pandas

### Dataset

* Food.com Recipes & User Interactions Dataset

---

## 📂 Required Dataset Files

The backend (`recipe.py`) requires the following dataset files:

```text
RAW_recipes.csv
RAW_interactions.csv
```

These files are not included in the repository because they exceed GitHub's file size limits.

Download them from the Food.com Recipes and User Interactions dataset:

https://www.kaggle.com/datasets/shuyangli94/food-com-recipes-and-user-interactions

After downloading, place both files in the project's root directory before running the backend server.

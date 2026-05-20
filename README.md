# texops

A new Flutter project.

## Getting Started# 🏭 TexOps: Advanced Textile ERP & Lab Management System

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![iOS](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white)
![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)

**TexOps** is a modern, mobile-first Enterprise Resource Planning (ERP) application built specifically for the textile manufacturing industry. Designed to be the "command center" for factory floors, receiving bays, and quality control labs, TexOps digitizes the entire supply chain workflow — from gate pass entry to rigorous fabric testing and AI-assisted data analysis.

---

## 📋 Table of Contents

- [Core Features](#-core-features)
- [UI/UX & Design System](#-uiux--design-system)
- [Embedded Lab Formulas](#-embedded-lab-formulas)
- [Getting Started](#-getting-started)
- [Project Architecture](#-project-architecture)
- [Contributing](#-contributing)

---

## ✨ Core Features

### 📦 1. Inbound Logistics & Inventory (Track-and-Trace)

- **Gate Pass Management:** Record inbound/outbound material flows with Pass IDs, Supplier matching, and vehicle tracking.
- **Bale Inventory:** Auto-generate sequential Bale IDs. Track material types (e.g., 30/1 Combed Cotton), net weights, and real-time purchase prices.
- **Smart QR Generation:** Automatically generate and print physical QR tags for bales. Scanners read critical identifiers (PassID, BaleID, Supplier, Arrival Time) for immediate factory-floor routing.

---

### 🔬 2. Quality Control & Lab Engineering

A comprehensive module for Lab Engineers to record, calculate, and review material quality attributes.

- **Fibre Testing:** Calculates Fibre Denier and tracks Fibre Length.
- **Yarn Testing:** Calculates Actual Count, Nominal Count, Tenacity, Elongation, CLSP (Count × Strength), and Actual TPM.
- **Fabric Testing:** Manages 11 distinct attributes including GSM, Tensile/Tearing/Bursting Strengths, Pilling Scale, Crease Recovery, Stiffness, and Weave/Knit types.

---

### 📊 3. Admin & Manager Dashboards

- **High-Level Metrics:** Track Total Gate Passes, Live Bale Inventory, Overall Quality Rates, and Active Users.
- **Supplier Leaderboards:** Monitor vendor performance with calculated quality scores and automated badges (Excellent, Good, Fair).
- **Data Visualization:** Interactive graphs showing "Price Trends by Yarn Type" and "Inventory Turn Over".

---

### 🤖 4. TexOps AI Assistant: Bobbin AI

- An integrated, context-aware AI chatbot designed for Lab Engineers.
- Provides immediate assistance on textile formulas, fabric care, GSM calculations, and weave structures directly on the factory floor.

---

## 🎨 UI/UX & Design System

TexOps strictly adheres to a custom, modern industrial design system optimized for readability in harsh factory environments.

- **Typography:** `Poppins` — exclusively used across the entire app for high legibility.

### Color Palette

| Role | Color | Hex Code | Usage |
| :--- | :--- | :--- | :--- |
| **Primary** | Dark Teal | `#1C4A5A` | App bars, main text, primary action buttons, active states |
| **Accent** | Orange | `#FFB057` | Highlighted data, warning badges, active progress steps, icons |
| **Background** | Light Peach | `#FFEEDB` | Global screen backgrounds, soft contrast areas |
| **Surface 1** | Off-White | `#FAFAFA` | Main data containers, form backgrounds, bottom sheets |
| **Surface 2** | Pure White | `#FFFFFF` | Individual list items, interactive cards, accordion menus |

---

## 🧮 Embedded Lab Formulas

The app automatically calculates critical textile metrics upon data entry. These formulas are hardcoded into the business logic.

### Fibre Formulas

```
Fibre Denier = (Weight in grams / Length in meters) × 9000
```

### Yarn Formulas

```
Actual Count (Ne)  = Length in yards / (840 × Weight in lbs)
Tenacity           = Breaking Force (cN) / Tex
Elongation (%)     = ((Final Length - Original Length) / Original Length) × 100
CLSP (CSP)         = Count × Strength
Actual TPM         = Number of Twists / Length in meters
```

### Fabric Formulas

```
GSM              = Weight / Area
Crease Recovery  = Theta1 + Theta2
Stiffness        = Weight per unit area × (Bending Length)³
```

---

## 🚀 Getting Started

This project is built with [Flutter](https://docs.flutter.dev/).

### Prerequisites

- Flutter SDK (v3.19.0 or higher recommended)
- Dart SDK
- Xcode (for iOS development)
- Android Studio (for Android development)

### Installation

1. **Clone the repository:**

   ```bash
   git clone https://github.com/yourusername/texops.git
   ```

2. **Navigate to the project directory:**

   ```bash
   cd texops
   ```

3. **Get Flutter dependencies:**

   ```bash
   flutter pub get
   ```

4. **Run the app:**

   ```bash
   flutter run
   ```

---

## 🏗 Project Architecture

This project follows a highly organized, feature-based directory structure to separate UI, business logic, and data models.

```
lib/
 ┣ controllers/                 # State management and business logic
 ┃ ┣ admin/
 ┃ ┣ chat_bot/
 ┃ ┣ lab_engineer/
 ┃ ┗ quality_testing/
 ┣ data/                        # Data models and repositories
 ┣ resources/                   # App-wide configuration
 ┃ ┣ appUrl/                    # API endpoints
 ┃ ┣ assets/                    # Image paths and static files
 ┃ ┣ colors/                    # TexOps theme and palette definitions
 ┃ ┗ route/                     # Navigation and routing logic
 ┣ screens/                     # UI Views
 ┃ ┣ admin/
 ┃ ┣ chat_bot/
 ┃ ┣ lab_engineer/
 ┃ ┗ QualityMeasures/Screens/   # Lab testing accordion flows
 ┃   ┣ chooseCategory/
 ┃   ┣ Common/
 ┃   ┣ fabric/
 ┃   ┣ fibre/
 ┃   ┣ score_screen/
 ┃   ┗ yarn/
 ┣ services/                    # External APIs and backend integrations
 ┣ user_prefernce/              # Local storage and session management
 ┣ Utiles/                      # Helper functions and constants
 ┣ firebase_options.dart        # Firebase configuration file
 ┗ main.dart                    # App entry point
```

---

## 🤝 Contributing

This is a proprietary application. For access or contribution requests, please contact the repository administrator.


This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

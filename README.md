# 📘 Bukubiruku Apps

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)
![Gemini AI](https://img.shields.io/badge/Google%20Gemini-8E75B2?style=for-the-badge&logo=googlebard&logoColor=white)

**Bukubiruku** is a smart expense tracker application built with **Flutter**, designed to solve the friction of manual data entry by leveraging **Generative AI (Google Gemini)** for receipt scanning.

## 📱 Demo & Screenshots

<div align="center">
  <img src="assets/screenshots/home.png" width="250" alt="Home Screen" />
  <img src="assets/screenshots/scan_demo.gif" width="250" alt="AI Scan Demo" />
</div>

## 🧐 The Problem & Solution

**The Problem:** Consistently tracking expenses is hard. Manual entry into spreadsheets or traditional apps creates friction, leading to the "I'll do it later" mindset—which eventually means "never".

**The Solution:** **Bukubiruku**. An app that removes manual typing. Just snap a picture of your receipt, and the AI extracts the total amount, date, and description automatically.

## 🚀 Key Features

* **📸 AI Receipt Scanner:** Integrates **Google Gemini 1.5 Flash** to analyze receipt images and auto-fill transaction forms.
* **🔐 Secure Authentication:** Full user registration and login flow using **Supabase Auth**.
* **☁️ Real-time Database:** Stores transactions securely using **Supabase Database (PostgreSQL)**.
* **👤 User Metadata Sync:** Automatically updates user attributes (e.g., wallet balance) directly in Supabase Auth metadata.
* **🏗️ Clean Architecture:** Built with scalability and testability in mind.

## 🛠️ Tech Stack & Architecture

This project strictly follows **Clean Architecture** principles to ensure separation of concerns:

* **Presentation Layer:** Flutter Widgets, Providers (State Management).
* **Domain Layer:** Entities, Use Cases, Repository Interfaces (Pure Dart, no dependencies).
* **Data Layer:** Data Sources (API & DB calls), Repository Implementations, Models.

**Libraries:**
* `flutter_bloc` / `provider` (State Management)
* `google_generative_ai` (AI SDK)
* `supabase_flutter` (Backend as a Service)
* `flutter_dotenv` (Environment Variables Security)

## ⚙️ Installation & Setup

To run **Bukubiruku Apps** locally, follow these steps:

### 1. Clone the repository
```bash
git clone [https://github.com/your-username/bukubiruku-apps.git](https://github.com/your-username/bukubiruku-apps.git)
cd bukubiruku-apps
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Setup Environment Variables
This project uses flutter_dotenv to protect sensitive API keys. Create a .env file in the root directory of the project and add your own keys:
```bash
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
GEMINI_API_KEY=your_google_ai_api_key
```

### 4. Run the App
```bash
4. Run the App
```
 
## 📂 Folder Structure
A glimpse of the Clean Architecture implementation in Bukubiruku Apps:
```bash
lib/
├── auth/                  # Feature: Authentication
│   ├── data/
│   ├── domain/
│   └── presentation/
├── transaction/           # Feature: Transactions
│   ├── data/
│   │   ├── datasource/    # Remote Data Source (Supabase & Gemini Service)
│   │   ├── models/        # JSON parsing models
│   │   └── repositories/  # Repository Implementation
│   ├── domain/
│   │   ├── entities/      # Core Business Objects
│   │   ├── repositories/  # Abstract Interfaces
│   │   └── usecases/      # Business Logic (ScanReceipt, AddTransaction)
│   └── presentation/
│       ├── pages/         # UI Screens
│       ├── providers/     # State Management
│       └── widgets/
├── main.dart              # Dependency Injection & Entry Point
└── ...
```
## 🤝 Contributing?
Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions to Bukubiruku Apps are greatly appreciated.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## ✍️ Author
Ihtishamul Hasan
- [LinkedIn](https://www.linkedin.com/in/ihtishamul-hasan/)
- [Github](https://github.com/shamhasan)

##
If you find Bukubiruku useful or interesting, please give it a ⭐!

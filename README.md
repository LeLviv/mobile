# LeLviv Mobile

Welcome to the **LeLviv Mobile** app! This guide is written to help anyone - whether you are a beginner or an experienced developer - set up, run, and understand this project easily.

---

## What is this project?

LeLviv Mobile is a mobile application built with **Flutter**. It allows users to interact with the LeLviv platform directly from their phones.
The application starts at [`lib/main.dart`](lib/main.dart).

---

## What do you need before starting?

Before you can run the app, make sure you have the following ready on your computer:

1. **Flutter SDK** (version 3.13.5 or newer)
   - [Download Flutter here](https://docs.flutter.dev/get-started/install) if you don't have it yet.
   - To check if everything is ready, open your terminal and run:
     ```bash
     flutter doctor
     ```
   - Make sure Flutter and your Android toolchain have green checkmarks.

2. **A Code Editor**
   - **VS Code** (with the *Flutter* and *Dart* extensions installed) or **Android Studio**.

3. **A Device or Emulator to test on**
   - An **Android Emulator** (configured in Android Studio), OR
   - An **iOS Simulator** (on macOS with Xcode), OR
   - A **Physical smartphone** connected via USB with Developer Mode turned on.

4. **Docker Desktop (For Backend Services)**
   - If your backend runs in Docker, ensure **Docker Desktop** is running and the backend container is started.

---

## How Docker Fits In

A mobile application needs a screen (an Android Emulator, iOS Simulator, or a real phone) to display the UI and respond to touch gestures. Because of this:
- **Docker Desktop** is used to run the **Backend server and database**.
- **Flutter** runs the **Mobile app** directly on your emulator or phone.

### Typical Workflow:
1. Open **Docker Desktop** and click **Start (▶)** on the backend container.
2. Start the mobile app on your emulator or phone using `flutter run` (or your editor's Play button).

---

## How to Start the App (Step-by-Step)

### Step 1: Open the project folder
Open your terminal, command prompt, or PowerShell, and navigate to the mobile folder:
```bash
cd D:/LeLviv/mobile
```

### Step 2: Download the required packages
Run this command to download all dependencies:
```bash
flutter pub get
```

### Step 3: Run the application
Start your emulator or connect your phone, and run:
```bash
flutter run
```

That's it! The app will build and open on your device screen.

---

### Optional: Connecting to the Backend Server

When you click **Login** in the app, it communicates with the backend server. 

If you want to explicitly pass the backend API URL when starting the app:
```bash
flutter run --dart-define=API_BASE_URL=<YOUR_BACKEND_URL>
```
**Where to get the backend URL:**
*See `.env.example` in the project root for the full list of variables.*

---

## Running from your Code Editor (1 Click)

You don't need to use the terminal every time - you can run the app directly from your editor:

### In VS Code:
1. Open the project in VS Code.
2. Open [`lib/main.dart`](lib/main.dart).
3. Press **F5** (or click **Run > Start Debugging**).

### In Android Studio:
1. Select your emulator or device from the device dropdown at the top.
2. Select `main.dart` in the configuration dropdown.
3. Click the green **Run (Play)** button.

---

## High-Level Project Architecture

To keep the project clean as new features are added each week, the codebase follows a **Feature-First** structure. Instead of memorizing every file, you only need to know two main areas:

```text
lib/
├── main.dart             # App entry point
│
├── core/                 # Shared foundations used across the whole app:
│   ├── config/           # Environment setup (backend URL configuration)
│   ├── constants/        # Centralized text strings (AppStrings)
│   ├── network/          # API route definitions (ApiEndpoints)
│   └── theme/            # App design system (AppColors, AppDimens)
│
└── features/             # Where new features live
    └── <feature_name>/   # Screens and logic specific to each feature
```

> **Adding a new feature?**
> Simply create a new folder under `lib/features/<feature_name>/` (for example, `lib/features/profile/`). Keep all screens and logic related to that feature inside its folder.

---

## Quick Guide for New Developers

Here are a few simple rules our team follows to keep the code clean and easy to maintain:

### 1. Where do I change colors or sizing?
- Never write hardcoded colors like `Colors.orange` directly in screens.
- Open [`lib/core/theme/app_colors.dart`](lib/core/theme/app_colors.dart) to find or add colors (e.g., `AppColors.background`).
- Open [`lib/core/theme/app_dimens.dart`](lib/core/theme/app_dimens.dart) to find or add spacing and padding (e.g., `AppDimens.spaceM`).

### 2. Where do I change button text or labels?
- Avoid typing raw text strings directly in widgets.
- Open [`lib/core/constants/app_strings.dart`](lib/core/constants/app_strings.dart) and add your string there (e.g., `AppStrings.loginButton`). This makes it easy to translate the app into other languages later.

### 3. How do I add or change backend API links?
- Open [`lib/core/network/api_endpoints.dart`](lib/core/network/api_endpoints.dart).
- Add new endpoints here instead of hardcoding URLs inside screens.

### 4. Where does the app start?
- In [`lib/main.dart`](lib/main.dart), you'll see the `main()` function.
  It initializes Flutter and opens the first screen.

---

## Frequently Asked Questions (FAQ)



### Q: How do I check if my code has errors or warnings?
**A:** Run this command in your terminal:
```bash
flutter analyze
```
It will analyze your Dart code and let you know if there are any issues or style improvements needed.

### Q: Why do I see an error when pressing the Login button?
**A:** Make sure:
1. Your backend container is started and running in Docker Desktop.
2. You provide the API URL when running the app if required:
   ```bash
   flutter run --dart-define=API_BASE_URL=<YOUR_BACKEND_URL>
   ```

---

**You are all set! Happy coding!**

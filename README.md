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

2. **A Code Editor / IDE**
   - **VS Code** (with the *Flutter* and *Dart* extensions installed), **Android Studio**, or **IntelliJ IDEA** (note: both Android Studio and IntelliJ IDEA require the *Flutter* and *Dart* plugins installed).

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

You can start the app directly:
```bash
flutter run
```

> **Note on Environment Variables:**
> Running `flutter run` without environment configuration is fine if you only want to inspect and test the UI layout. However, tapping buttons that trigger API requests (such as **Login**) will fail with an error because `API_BASE_URL` is required by `AppConfig`. To connect to your backend, choose one of the options below.

---

### Connecting to the Backend Server

You can pass configuration variables using an `.env` file (recommended) or via command-line arguments:

#### Option A: Using an `.env` file (Recommended)

1. Create a `.env.dev` file by copying the example template:
   ```bash
   cp .env.example .env.dev
   ```
   *(On Windows PowerShell: `Copy-Item .env.example .env.dev`)*

2. Open `.env.dev` and configure your `API_BASE_URL` depending on your test device:
   ```properties
   ENV=dev

   # -----------------------------------------------------------------------------
   # API BASE URL
   # -----------------------------------------------------------------------------
   # 1. Android Emulator (default for local development with Docker):
   API_BASE_URL=http://10.0.2.2:8080/api/v1

   # 2. iOS Simulator (macOS only):
   # API_BASE_URL=http://localhost:8080/api/v1

   # 3. Physical smartphone (must be connected to the same Wi-Fi network as your PC):
   # API_BASE_URL=http://192.168.x.x:8080/api/v1

   # 4. Shared Dev / Staging server (cloud-hosted):
   # API_BASE_URL=https://dev-api.lelviv.com/api/v1
   ```

3. Launch Flutter with the `--dart-define-from-file` flag:
   ```bash
   flutter run --dart-define-from-file=.env.dev
   ```

#### Option B: Passing directly via `--dart-define`

You can also pass the backend URL inline without a file:
```bash
flutter run --dart-define=API_BASE_URL=<YOUR_BACKEND_URL>
```

---

## Running from your Code Editor (1 Click)

You don't need to use the terminal every time - you can configure the environment flag in your IDE to run with one click:

### In VS Code:
1. Open the project in VS Code.
2. Create or edit `.vscode/launch.json` and add `"toolArgs"`:
   ```json
   {
     "version": "0.2.0",
     "configurations": [
       {
         "name": "LeLviv Mobile (dev)",
         "request": "launch",
         "type": "dart",
         "toolArgs": ["--dart-define-from-file=.env.dev"]
       }
     ]
   }
   ```
3. Open [`lib/main.dart`](lib/main.dart) and press **F5** (or click **Run > Start Debugging**).

### In Android Studio or IntelliJ IDEA:
1. Select your emulator or device from the device dropdown at the top.
2. In the run configurations dropdown, click **Edit Configurations...**.
3. Select your Flutter configuration (e.g., `main.dart`).
4. In the **Additional run args** field, enter:
   ```text
   --dart-define-from-file=.env.dev
   ```
5. Click **Apply** and **OK**.
6. Click the green **Run (Play)** button.

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

Here are a few simple rules our team follows to keep the code clean and easy to maintain (helpful for both developers and AI assistants):

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
2. You provided the environment variables when running the app. If you ran `flutter run` without an env configuration, the UI will display, but clicking buttons that perform network calls will fail with an error because `API_BASE_URL` is empty. Run with:
   ```bash
   flutter run --dart-define-from-file=.env.dev
   # or
   flutter run --dart-define=API_BASE_URL=<YOUR_BACKEND_URL>
   ```
3. If running on an **Android Emulator**, make sure your URL is set to `http://10.0.2.2:8080/api/v1` (not `localhost`), or forward the port using:
   ```bash
   adb reverse tcp:8080 tcp:8080
   ```

---

**You are all set! Happy coding!**

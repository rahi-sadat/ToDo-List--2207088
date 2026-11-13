# ToDo-List (Student ID: 2207088)

A modern, responsive To-Do List iOS application built with **SwiftUI** and powered by **Google Firebase** (Firebase Authentication & Cloud Firestore).

---

## 📱 Features

- **User Authentication (Firebase Auth)**
  - Email and password registration with client-side validation (min 6 characters, password confirmation matching).
  - Secure login with real-time session detection.
  - One-tap sign out.
  - Automatic navigation state switching between login and task dashboard.

- **Real-Time Task Management (Cloud Firestore)**
  - **Create:** Add new tasks with title and multi-line descriptions.
  - **Read:** Real-time data synchronization using Firestore snapshot listeners (`order(by: "createdAt", descending: true)`).
  - **Update:** Edit task title and description via modal sheet presentation.
  - **Delete:** Remove tasks with immediate Firestore document deletion.
  - **Data Isolation:** Each user's tasks are securely stored under their own sub-collection (`users/{uid}/tasks`).

- **User Experience & UI**
  - Modern SwiftUI declarative design using `NavigationStack`, `Form`, and `.sheet`.
  - Empty state checklist placeholder when no tasks exist.
  - Interactive alerts and error notifications for network or validation failures.
  - Activity indicators (`ProgressView`) during asynchronous operations.

---

## 🛠️ Tech Stack & Dependencies

- **Language:** Swift 5.x
- **Framework:** SwiftUI
- **Backend Services:**
  - [Firebase Core](https://firebase.google.com/docs/ios/setup)
  - [Firebase Authentication](https://firebase.google.com/docs/auth/ios/start)
  - [Firebase Firestore](https://firebase.google.com/docs/firestore/quickstart)
- **Dependency Manager:** Swift Package Manager (SPM) with `firebase-ios-sdk` (v13.1.1)
- **Minimum Target:** iOS 16.0+

---

## 📂 Project Architecture

```
TodoList-088/
├── TodoList-088.xcodeproj/         # Xcode project configuration & SPM packages
│   └── project.xcworkspace/
└── TodoList-088/
    ├── MyApp.swift                 # App entry point, FirebaseApp configuration
    ├── ContentView.swift           # Root view toggling Auth vs. Home based on session
    ├── GoogleService-Info.plist    # Firebase configuration file
    ├── Assets.xcassets             # App colors and icons
    │
    ├── Models/
    │   └── TaskModel.swift         # Task data model & Firestore document parser
    │
    ├── Services/
    │   ├── AuthService.swift       # Firebase Auth service (login, register, logout)
    │   └── TaskService.swift       # Cloud Firestore CRUD operations & real-time listener
    │
    └── Views/
        ├── LoginView.swift         # User login screen
        ├── RegisterView.swift      # Account creation screen
        ├── HomeView.swift          # Main task list dashboard & actions
        ├── AddTaskView.swift       # Sheet modal for creating tasks
        └── EditTaskView.swift      # Sheet modal for updating tasks
```

---

## 🚀 Getting Started

### Prerequisites

- macOS with **Xcode 15+** installed.
- iOS Simulator or physical iOS device running iOS 16+.
- Active Firebase project with **Email/Password Authentication** and **Cloud Firestore** enabled.

### Setup Steps

1. **Clone the repository:**
   ```bash
   git clone https://github.com/rahi-sadat/ToDo-List--2207088.git
   cd ToDo-List--2207088
   ```

2. **Open in Xcode:**
   ```bash
   open TodoList-088.xcodeproj
   ```

3. **Verify Dependencies:**
   - Xcode will automatically resolve the `firebase-ios-sdk` via Swift Package Manager defined in `Package.resolved`.

4. **Firebase Configuration:**
   - Ensure `GoogleService-Info.plist` is properly linked in the `TodoList-088` target.
   - In the Firebase Console, verify that **Firestore Database** rules allow authenticated reads/writes:
     ```javascript
     rules_version = '2';
     service cloud.firestore {
       match /databases/{database}/documents {
         match /users/{userId}/tasks/{taskId} {
           allow read, write: if request.auth != null && request.auth.uid == userId;
         }
       }
     }
     ```

5. **Build and Run:**
   - Select your target simulator (e.g., iPhone 15 Pro).
   - Press `Cmd + R` to build and run the application.

---

## 👤 Author

- **Name:** Rahi Sadat Ruhan
- **Student ID:** 2207088
- **GitHub:** [@rahi-sadat](https://github.com/rahi-sadat)

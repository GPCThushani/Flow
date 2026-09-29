# Flow — Personal Expense Tracker

## Overview

**Flow** is a personal expense tracking mobile application built with **Flutter and Firebase**.

The application allows users to securely manage their everyday expenses by creating an account, recording expenses, organizing them by category, reviewing their spending history, and understanding their monthly spending through summaries and visualizations.

The project was developed as part of the **Flutter Developer Internship Practical Task at CyphLab**, with a focus on Flutter/Dart fundamentals, Firebase integration, clean code structure, responsive UI, form validation, error handling, and overall application usability.


---

## Features

### Authentication

* User registration
* Email/password login
* Logout
* Authentication state handling
* User-specific expense data

### Expense Management

* Add new expenses
* Edit existing expenses
* Delete expenses
* View expense details
* Confirmation before deletion

### Expense Information

Each expense contains:

* Title
* Amount
* Category
* Date
* Optional note/description

### Dashboard

The home dashboard provides:

* Current month's total expenses
* Monthly comparison
* Category-wise spending overview
* Recent expenses
* Quick access to add an expense

### Expense History

Users can:

* View all recorded expenses
* Search expenses
* Filter by category
* Filter by date
* Open individual expense details

### Monthly Summary

The summary section provides:

* Monthly total spending
* Category-wise spending
* Simple expense visualization
* Highest spending category
* Monthly comparison

### Application States

Flow handles:

* Loading states
* Empty states
* Error states
* Retry actions
* Form validation
* Delete confirmation

---

## Screens

The application includes the following main screens:

1. Splash Screen
2. Login
3. Create Account
4. Home / Dashboard
5. Add Expense
6. Edit Expense
7. Expense History
8. Expense Details
9. Filter Expenses
10. Monthly Summary
11. Category Summary
12. Search Results
13. Empty State
14. Loading State
15. Error State
16. Profile / Settings

---

## UI & Design

Flow follows a clean, minimal and professional design approach.

### Color Palette

| Purpose      | Color          |
| ------------ | -------------- |
| Primary      | Deep Green     |
| Secondary    | Muted Green    |
| Background   | Warm Off-White |
| Surface      | White          |
| Primary Text | Charcoal       |
| Accent       | Soft Orange    |

The interface intentionally avoids excessive visual effects and unnecessary decorative elements.

The design focuses on:

* Clear hierarchy
* Consistent spacing
* Readable typography
* Responsive layouts
* Simple navigation
* Meaningful icons
* Clear feedback
* Accessible interaction patterns

---

## Technology Stack

### Frontend

* **Flutter**
* **Dart**

### Backend / Cloud

* **Firebase Authentication**
* **Cloud Firestore**

### Development Tools

* Visual Studio Code / Android Studio
* Firebase Console
* Git
* GitHub
* Android Emulator / Physical Android Device

### Additional Packages

The project may use packages such as:

* `firebase_core`
* `firebase_auth`
* `cloud_firestore`
* `intl`
* `fl_chart`
* `provider` / selected state-management solution

> Package versions may change during development. Refer to `pubspec.yaml` for the exact versions used in the submitted project.

---

## Application Architecture

The application follows a feature-oriented structure to keep the code organized and maintainable.

```text
lib/
│
├── core/
│   ├── constants/
│   ├── theme/
│   └── utils/
│
├── models/
│   └── expense.dart
│
├── services/
│   └── firebase_service.dart
│
├── repositories/
│   └── expense_repository.dart
│
├── features/
│   ├── auth/
│   │   ├── login/
│   │   └── register/
│   │
│   ├── dashboard/
│   │
│   ├── expenses/
│   │   ├── history/
│   │   ├── details/
│   │   └── add_edit/
│   │
│   └── summary/
│
├── widgets/
│   ├── expense_card.dart
│   ├── category_chip.dart
│   ├── empty_state.dart
│   └── loading_indicator.dart
│
└── main.dart
```

The exact structure may be adjusted during implementation based on the final application requirements.

---

## Firebase Architecture

Flow uses Firebase to provide authentication and cloud-based expense storage.

```text
                 Flutter Application
                         │
                         ▼
              Firebase Authentication
                         │
                     User ID
                         │
                         ▼
                  Cloud Firestore
                         │
                         ▼
              User-specific Expenses
```

### Firestore Structure

```text
users
└── {userId}
    └── expenses
        └── {expenseId}
            ├── title
            ├── amount
            ├── category
            ├── date
            ├── note
            ├── createdAt
            └── updatedAt
```

Associating expenses with the authenticated user's ID ensures that users only access their own expense records.

---

## Expense Categories

The application uses predefined categories to make expense organization consistent.

Example categories include:

* Food
* Transport
* Shopping
* Bills
* Health
* Entertainment
* Other

The category system can be extended in the future if required.

---

## Validation

The expense form validates user input before submitting data.

Examples include:

* Title cannot be empty
* Amount cannot be empty
* Amount must be a valid positive number
* Category must be selected
* Date must be valid

Optional notes can be left empty.

---

## Error Handling

Flow provides user-friendly feedback for common application states.

### Loading

When expense data is being retrieved:

> Loading your expenses...

### Empty

When the user has no expenses:

> No expenses yet
> Start tracking your spending by adding your first expense.

### Error

When data cannot be loaded:

> Couldn't load your expenses
> Please check your connection and try again.

A retry action is provided where appropriate.

---

## Navigation Flow

```text
                    Splash
                      │
                      ▼
              Authentication Check
                 /            \
                /              \
        Not Authenticated     Authenticated
              │                    │
              ▼                    ▼
            Login                Home
              │                    │
              ├── Create Account   ├── Expenses
              │                    │     ├── Add
              │                    │     ├── Details
              │                    │     └── Edit
              │                    │
              │                    ├── Summary
              │                    │
              │                    └── Profile
              │
              └──────────────► Home
```

---

## Project Setup

### Prerequisites

Before running the project, make sure the following are installed:

* Flutter SDK
* Dart SDK
* Android Studio or Visual Studio Code
* Android Emulator or Android device
* Git
* A Firebase project

Check your Flutter installation with:

```bash
flutter doctor
```

---

### 1. Clone the Repository

```bash
git clone https://github.com/GPCThushani/Flow.git
```

Navigate to the project:

```bash
cd Flow
```

---

### 2. Install Dependencies

```bash
flutter pub get
```

---

### 3. Configure Firebase

Create a Firebase project through the Firebase Console.

Enable:

* Firebase Authentication
* Email/Password Authentication
* Cloud Firestore

Connect the Flutter application to Firebase using the appropriate Firebase configuration.

For FlutterFire CLI:

```bash
dart pub global activate flutterfire_cli
```

Then configure the project:

```bash
flutterfire configure
```

This generates the Firebase configuration required by the application.

> Firebase configuration files and sensitive credentials should not be committed if they contain information that should remain private.

---

### 4. Run the Application

Connect an Android device or start an emulator.

Then run:

```bash
flutter run
```

For a release build:

```bash
flutter build apk --release
```

---

## Testing

The application should be tested for:

### Authentication

* Create account
* Login
* Logout
* Invalid credentials
* Empty fields

### Expense Management

* Add expense
* Edit expense
* Delete expense
* Cancel deletion
* Invalid amount
* Missing required fields

### Filtering

* Category filter
* Date filter
* Combined filters
* Reset filters

### Search

* Search by expense title
* Search with no matching results
* Clear search

### Firebase

* Loading data
* Saving data
* Updating data
* Deleting data
* Handling connection errors

### UI States

* Loading
* Empty
* Error
* Successful operations

---

## AI Tools Used

AI tools were used as development assistants throughout the project.

### ChatGPT

Used for:

* Understanding and breaking down requirements
* Flutter/Dart development assistance
* Debugging and troubleshooting
* Firebase implementation guidance
* UI/UX planning
* Code structure suggestions
* Validation logic
* README and documentation assistance
* Reviewing implementation decisions

### GitHub Copilot

Used for:

* Code completion
* Boilerplate generation
* Development productivity
* Small implementation suggestions

### Responsible AI Usage

AI-generated suggestions were not treated as final solutions automatically.

The generated code and recommendations were:

1. Reviewed
2. Adapted to the project's requirements
3. Tested locally
4. Debugged when necessary
5. Modified to fit the application's architecture and UI

The developer maintains an understanding of the submitted implementation and can explain the major design and technical decisions.

---

## Requirements Coverage

The following table maps the project to the practical task requirements.

| CyphLab Requirement           | Flow Implementation      |
| ----------------------------- | ------------------------ |
| Add new expenses              | Add Expense              |
| Edit existing expenses        | Edit Expense             |
| Delete expenses               | Delete with confirmation |
| Select expense category       | Category selector        |
| Store expenses using Firebase | Cloud Firestore          |
| Current month total           | Dashboard                |
| Expense history/list          | Expense History          |
| Filter by category            | Category filter          |
| Filter by date                | Date filter              |
| Form validation               | Validated expense form   |
| Loading state                 | Loading UI               |
| Empty state                   | Empty UI                 |
| Error state                   | Error + Retry            |
| Title                         | Expense field            |
| Amount                        | Expense field            |
| Category                      | Expense field            |
| Date                          | Expense field            |
| Optional note                 | Expense field            |
| Expense chart                 | Monthly Summary          |
| Monthly/category summary      | Summary screens          |
| Search                        | Expense Search           |
| Firebase Authentication       | Login / Create Account   |

---

## Additional Features

Beyond the core requirements, Flow includes:

* Firebase Authentication
* Monthly spending comparison
* Category-wise spending breakdown
* Expense search
* Combined filtering
* Expense details
* Delete confirmation
* Simple expense visualization
* User-specific Firestore data
* Responsive mobile UI
* Clear loading, empty and error states

---

## Future Improvements

Possible future improvements include:

* Budget limits
* Recurring expenses
* Export expenses to CSV/PDF
* Multiple currencies
* Custom categories
* Notifications
* Advanced financial reports
* Offline-first synchronization
* Dark mode

These features are intentionally outside the initial scope to keep the application focused on the requirements of the practical task.

---

## Demo

### Screen Recording

**Google Drive / YouTube:**
`[Add screen recording link here]`

### APK

**Release APK:**
`[Add APK link here]`

---

## Repository

**GitHub:**
`[Add repository URL here]`

---

## Project Information

**Project:** Flow - Personal Expense Tracker
**Platform:** Android
**Framework:** Flutter
**Backend:** Firebase
**Database:** Cloud Firestore
**Authentication:** Firebase Authentication

---

## License

This project was developed as part of a technical assessment and internship selection process.

© 2026 Flow

# Flow - Personal Expense Tracker

## Overview

**Flow** is a clean, minimal, and professional personal expense tracking mobile application built with **Flutter and Firebase**.

The application helps users manage their everyday expenses by creating an account, recording expenses, organizing spending by category, reviewing expense history, and viewing monthly spending summaries through clear visualizations.

Flow was developed as part of the **Flutter Developer Internship Practical Task at CyphLab**, with a focus on Flutter/Dart fundamentals, Firebase integration, clean code structure, responsive UI, form validation, error handling, usability, and attention to detail.

The project intentionally focuses on delivering a well-structured and usable core experience rather than adding unnecessary complexity.

---

## Core Features

### Authentication & User Management

* User registration with email and password
* Email/password login
* Persistent authentication state handling
* User-specific expense data
* Secure logout functionality
* Password validation and confirmation during registration

### Expense Management

Flow provides complete CRUD functionality for expenses.

* **Create** - Add new expenses
* **Read** - View recorded expenses
* **Update** - Edit existing expenses
* **Delete** - Delete expenses with confirmation

Each expense contains:

* Title
* Amount
* Category
* Date
* Optional note/description

### Dashboard

The home dashboard provides a quick overview of spending.

* Monthly expense total
* Month selection
* Category-wise spending breakdown
* Top spending category
* Recent expenses
* Visual spending chart

### Expense History

Users can review and manage their complete expense history.

* Expenses grouped by date
* Search by expense title or category
* Filter by category
* Filter by date
* View individual expense details
* Edit and delete existing expenses

### Monthly Summary

The summary section provides a visual overview of spending.

* Monthly total
* Category-wise breakdown
* Spending chart
* Top spending category
* Month selection

### Application States

Flow provides dedicated handling for different application states.

* **Loading** - Feedback while retrieving data
* **Empty** - Guidance when no expenses exist
* **Error** - User-friendly error messages and retry actions
* **Validation** - Input validation before submitting forms

### User Preferences

* Light theme
* Dark theme
* System default theme
* Sri Lankan Rupee (LKR / Rs.) currency display

---

## UI & Design

Flow follows a clean, minimal, and professional visual design.

The interface focuses on:

* Clear visual hierarchy
* Consistent spacing
* Readable typography
* Responsive layouts
* Simple navigation
* Meaningful icons
* Clear feedback
* Consistent components
* Minimal visual distractions

The design intentionally avoids excessive animations, unnecessary decorative elements, and AI-themed visual elements.

### Color Palette

| Purpose    | Color              | Hex       |
| ---------- | ------------------ | --------- |
| Primary    | Deep Green         | `#1F3D32` |
| Secondary  | Muted Green        | `#5F806F` |
| Accent     | Soft Orange/Yellow | `#F4B400` |
| Error      | Red                | `#FF5252` |
| Background | Warm Off-White     | `#F8F9FA` |
| Surface    | White              | `#FFFFFF` |

---

## Technology Stack

### Frontend

* **Flutter**
* **Dart**

### Backend & Cloud

* **Firebase Authentication**
* **Cloud Firestore**

### State Management

* **Provider**

### Key Packages

* `firebase_core` - Firebase initialization
* `firebase_auth` - User authentication
* `cloud_firestore` - Firestore database integration
* `intl` - Date and formatting utilities
* `fl_chart` - Expense data visualization
* `provider` - Application state management

### Development Tools

* Visual Studio Code
* Firebase Console
* Git
* GitHub
* FlutterFire CLI

### Platform

* Android

---

## Application Architecture

Flow follows a feature-oriented structure to keep the code organized, maintainable, and easy to understand.

```text
lib/
├── core/
│   ├── theme/
│   │   └── app_theme.dart
│   └── widgets/
│       ├── state_widgets.dart
│
├── models/
│   └── expense.dart
│
├── providers/
│   ├── auth_provider.dart
│   ├── expense_provider.dart
│   └── theme_provider.dart
│
├── features/
│   ├── auth/
│   │   ├── login/
│   │   └── register/
│   │
│   ├── home/
│   │   └── home_screen/
│   │   └── main_screen/
│   │
│   ├── expense/
│   │   ├── add_expense/
│   │   └── expense_list/
│   │
│   ├── summary/
│   │   ├── category_summary/
│   │   └── summary_screen/
│   │
│   └── more/
│
└── main.dart
```

The architecture separates application state, data models, reusable UI components, and feature-specific screens.

---

## Firebase Architecture

Flow uses **Firebase Authentication** for user accounts and **Cloud Firestore** for expense storage.

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
            └── note
```

Expenses are stored under the authenticated user's ID so that the application can retrieve the appropriate user's records.

---

## Expense Categories

Flow uses predefined categories to keep expense organization simple and consistent.

* Food
* Transport
* Shopping
* Bills
* Health
* Entertainment
* Other

---

## Form Validation

The application validates user input before saving an expense.

Examples include:

* Title cannot be empty
* Amount cannot be empty
* Amount must be a valid positive number
* Category must be selected
* Date must be valid
* Password fields must satisfy the required validation rules
* Password confirmation must match during registration

Optional notes can be left empty.

---

## Loading, Empty & Error Handling

Flow provides dedicated UI states instead of leaving users with blank screens when an operation is in progress or fails.

### Loading State

Displayed while expense data is being retrieved.

```text
Loading your expenses...
```

### Empty State

Displayed when a user has not recorded any expenses.

```text
No expenses yet

Start tracking your spending
by adding your first expense.

[ Add Expense ]
```

### Error State

Displayed when an operation fails.

```text
Couldn't load your expenses

Please check your connection
and try again.

[ Retry ]
```

---

## Navigation Flow

```text
                         Splash
                           │
                           ▼
                  Authentication Check
                     /             \
                    /               \
                   ▼                 ▼
                 Login              Home
                   │                  │
             ┌─────┴─────┐           ├── Dashboard
             │           │           │
             ▼           ▼           ├── Expenses
       Create Account  Forgot        │     ├── Add
                       Password      │     ├── Details
                                     │     └── Edit
                                     │
                                     ├── Summary
                                     │
                                     └── Settings
                                           │
                                           └── Logout
```

---

## Project Setup

### Prerequisites

Make sure the following are installed:

* Flutter SDK
* Dart SDK
* Git
* Android Studio or Visual Studio Code
* Android Emulator or physical Android device
* A Firebase project

Verify the Flutter installation:

```bash
flutter doctor
```

---

### 1. Clone the Repository

```bash
git clone https://github.com/GPCThushani/Flow.git
cd Flow
```

---

### 2. Install Dependencies

```bash
flutter pub get
```

---

### 3. Configure Firebase

Create a Firebase project and enable:

* Firebase Authentication
* Email/Password Authentication
* Cloud Firestore

Configure Firebase for the Flutter application using FlutterFire CLI:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

Follow the generated configuration for the target platform.

---

### 4. Run the Application

Connect an Android device or start an emulator:

```bash
flutter run
```

---

## Requirements Coverage

The following table maps Flow directly to the requirements provided in the CyphLab practical task.

| CyphLab Requirement                               | Flow Implementation         |
| ------------------------------------------------- | --------------------------- |
| Add new expenses                                  | Add Expense Form            |
| Edit existing expenses                            | Edit Expense Form           |
| Delete expenses                                   | Delete with confirmation    |
| Select expense category                           | Category selector           |
| Store expenses using Firebase                     | Cloud Firestore             |
| Display total expenses for current/selected month | Dashboard & Monthly Summary |
| Expense history/list                              | Expense History             |
| Filter by category                                | Category Filter             |
| Filter by date                                    | Date Range Filter           |
| Form validation                                   | Form validation             |
| Loading state                                     | Loading State               |
| Empty state                                       | Empty State                 |
| Error state                                       | Error State + Retry         |
| Title                                             | Expense field               |
| Amount                                            | Expense field               |
| Category                                          | Expense field               |
| Date                                              | Expense field               |
| Optional note/description                         | Expense field               |
| Simple expense chart                              | `fl_chart` visualization    |
| Monthly/category-wise summary                     | Monthly Summary             |
| Search functionality                              | Expense Search              |
| Firebase Authentication                           | Login & Create Account      |

---

## Additional Features

In addition to the required functionality, Flow includes:

* Firebase Authentication
* Monthly month selector
* Monthly spending comparison
* Category-wise spending analysis
* Top spending category
* Search functionality
* Combined filtering
* Expense details
* Delete confirmation
* Expense visualization
* Theme switching
* User-specific Firestore data
* Responsive mobile interface

---

## AI Tools Used

AI tools were used as development assistants during the implementation of Flow.

### ChatGPT

Used for:

* Breaking down the practical task requirements
* Planning the application architecture
* Flutter/Dart development assistance
* Firebase implementation guidance
* UI/UX planning
* Debugging and troubleshooting
* Validation and state-handling guidance
* Documentation and README preparation

### GitHub Copilot

Used for:

* Code completion
* Boilerplate generation
* Small implementation suggestions
* Development productivity

### Responsible AI Usage

AI-generated suggestions were reviewed and adapted before being incorporated into the project.

The development process involved:

1. Understanding the generated suggestions
2. Adapting code to the project's architecture
3. Reviewing implementation details
4. Testing functionality locally
5. Debugging and modifying code where necessary

AI tools were used as development assistants rather than as a replacement for understanding the submitted implementation.

---

## Testing Checklist

The following areas were tested during development.

### Authentication

* [ ] Account creation
* [ ] Login
* [ ] Logout
* [ ] Invalid credentials
* [ ] Empty field validation
* [ ] Password validation

### Expense Management

* [ ] Add expense
* [ ] View expense
* [ ] Edit expense
* [ ] Delete expense
* [ ] Delete confirmation
* [ ] Firestore persistence

### Search & Filtering

* [ ] Search by title
* [ ] Search by category
* [ ] Category filtering
* [ ] Date filtering
* [ ] Filter reset

### Dashboard & Summary

* [ ] Monthly total
* [ ] Month selection
* [ ] Category breakdown
* [ ] Chart
* [ ] Recent expenses

### Application States

* [ ] Loading state
* [ ] Empty state
* [ ] Error state
* [ ] Retry functionality

### UI

* [ ] Responsive layout
* [ ] Keyboard handling
* [ ] Form scrolling
* [ ] No text overflow
* [ ] Consistent spacing
* [ ] Light theme
* [ ] Dark theme
* [ ] System theme

---

## Submission Materials

### GitHub Repository

**Repository:**
https://github.com/GPCThushani/Flow

### Screen Recording

`https://drive.google.com/file/d/1Stls_kMhvKB6dDTYxp3gy4jXV17SApux/view?usp=sharing `

---

## Project Information

|                      |                                             |
| -------------------- | ------------------------------------------- |
| **Project**          | Flow - Personal Expense Tracker             |
| **Purpose**          | Flutter Developer Internship Practical Task |
| **Organization**     | CyphLab                                     |
| **Framework**        | Flutter                                     |
| **Language**         | Dart                                        |
| **Authentication**   | Firebase Authentication                     |
| **Database**         | Cloud Firestore                             |
| **State Management** | Provider                                    |
| **Platform**         | Android                                     |

---

## Future Improvements

The following features could be considered for future versions:

* Budget limits
* Recurring expenses
* Export expenses to CSV/PDF
* Custom categories
* Multiple currencies
* Offline-first synchronization
* Notifications
* Advanced financial reports

These features are outside the scope of the current practical task and were intentionally not prioritized over the required functionality.

---

## License

This project was developed as part of the **CyphLab Flutter Developer Internship Practical Task**.

© 2026 Flow

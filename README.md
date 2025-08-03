# Flutter TODO App – EBpearls Pre-Screening Assignment

## Objective

This project is a simple **TODO mobile application** built with **Flutter** as a pre-screening assignment for EBpearls. The app allows users to manage tasks with essential features like add, edit, delete, mark complete/incomplete, filter, and more, following Clean Architecture principles and using flutter_bloc for state management.

---

## Core Features

- **View a list of tasks**
- **Add new tasks**
- **Edit existing tasks**
- **Delete tasks**
- **Mark tasks as completed or incomplete**
- **Filter tasks by status:** _All, Active, Completed_
- **Assign task priority:** _High, Medium, Low_ (color-coded)
- **Set a due date** for each task and support **sorting by date**
- **Sort tasks by priority**
- **(Bonus)** Responsive UI, dark mode, smooth animations, and custom theming
- **(Bonus)** Unit tests for Bloc and/or data layer

---

## Technical Requirements

### State Management
- Uses [`flutter_bloc`](https://pub.dev/packages/flutter_bloc) for handling tasks and filter logic

### Architecture
- Follows **Clean Architecture** principles:
  - **Presentation layer** (UI, Cubit)
  - **Domain layer** (Models, Repository interfaces)
  - **Data layer** (Isar models, Repository implementations)

### Storage
- Uses **Isar** (a fast, local NoSQL database) for persistent storage (can be swapped for Hive or similar)

---

## Getting Started

### Prerequisites
- [Flutter](https://flutter.dev/docs/get-started/install)
- Dart SDK

### Setup
1. Clone the repository:
   ```sh
   git clone git@github.com:manishbajra2000/todo_app_flutter.git
   cd todo_app
   ```
2. Install dependencies:
   ```sh
   flutter pub get
   ```
3. Generate Isar database code:
   ```sh
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
4. Run the app:
   ```sh
   flutter run
   ```

---

## Project Structure

- `lib/`
  - `main.dart` – App entry point, theme setup (light/dark)
  - `domain/` – Models and repository interfaces
  - `data/` – Isar models and repository implementations
  - `presentation/` – UI, Cubit, and widgets
- `test/` – Widget and unit tests

---

## Packages Used
- [flutter_bloc](https://pub.dev/packages/flutter_bloc)
- [isar](https://pub.dev/packages/isar)
- [path_provider](https://pub.dev/packages/path_provider)

---

## Notes
- The app is designed to be clean, modular, and easily extensible.
- All requirements from the assignment are implemented, including bonus features (dark mode, animations, due date sorting, custom theming).
- The code is well-commented and follows best practices for readability and maintainability.

---

_Developed as part of the EBpearls pre-screening assignment._

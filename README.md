This is a Flutter-based exercise tracker app using BLoC for state management and Clean Architecture
principles. The app allows users to browse a list of exercises, view details, and complete exercises
with a built-in countdown timer.

## **🧱 Architecture**

The app is structured following Clean Architecture, which separates code into layers:

lib/
├── data/
│ └── api_data_source.dart # Handles remote API calls
│ └── exercise_repository_impl.dart # Implementation of repository
├── domain/
│ └── exercise_list_model.dart # Core entity/model
│ └── get_exercise_use_case.dart # Business logic/use case
├── presentation/
│ └── bloc/
│ └── exercise_bloc.dart # BLoC for handling UI state/events
│ └── screens/
│ └── home_screen.dart
│ └── detail_screen.dart
├── core/
│ └── utils.dart # Helper functions
│ └── constants.dart # Constants used in the app
│ └── app_theme_manager.dart # Centralized theming

## **🚀 How to Run the App**

1. Clone the project
   cd exercise_app
2. Install dependencies
   flutter pub get
3. Connect a device or open an emulator
4. Run the app
   flutter run

## Known Issues / Shortcomings

* Exercise timer resets if the detail screen is popped before completion.
* Bloc state is not persisted across app restarts (no local persistence used).
* Currently supports only a basic remote data fetch; no offline capability.
* Error handling could be enhanced with more descriptive user messages.
* UI does not support landscape mode fully.

AI Usage:
Used ChatGPT (OpenAI GPT-4) only for assistance with bug fixes, and generating
documentation (e.g., README file).
All final code was written and verified by me.

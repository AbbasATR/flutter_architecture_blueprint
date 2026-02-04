# Flutter Architecture Blueprint

A production-grade Flutter application demonstrating Clean Architecture principles, BLoC state management, and scalable project organization. This project serves as an architectural reference for building maintainable, testable, and enterprise-ready Flutter applications.

## 🎯 Project Purpose

This is **not a full production app**—it's an architecture showcase designed to demonstrate best practices for:
- Clean Architecture implementation in Flutter
- Feature-driven folder structure
- Separation of concerns across domain, data, and presentation layers
- State management with BLoC pattern
- Dependency injection with GetIt
- Localization and theming
- Testing strategies

The app simulates a food delivery platform with multiple features, but uses mock data instead of real backend services.

## 🏗️ Architecture

### Clean Architecture Layers

```
lib/
├── core/                   # Cross-cutting concerns
│   ├── constants/         # App-wide constants
│   ├── error/            # Error handling (failures, exceptions)
│   ├── network/          # Network clients (Dio)
│   ├── routers/          # Navigation configuration
│   ├── services/         # Core services
│   └── usecases/         # Base UseCase abstraction
│
├── features/             # Feature modules (Clean Architecture)
│   ├── auth/
│   ├── home/
│   ├── cart/
│   ├── orders/
│   ├── supplier/
│   ├── item/
│   ├── search/
│   ├── notifications/
│   ├── address/
│   └── profile/
│
├── shared/               # Shared UI components and utilities
│   ├── layout/          # Shell/scaffold structure
│   ├── theme/           # Theme configuration
│   ├── localization/    # Internationalization
│   ├── widgets/         # Reusable widgets
│   ├── responsive/      # Responsive utilities
│   └── services/        # Shared services
│
├── injection/            # Dependency injection setup
└── main.dart            # App entry point
```

### Feature Structure

Each feature follows Clean Architecture with three layers:

```
features/<feature>/
├── domain/               # Business logic layer
│   ├── entities/        # Business models
│   ├── repositories/    # Repository interfaces
│   └── usecases/        # Business use cases
│
├── data/                # Data layer
│   ├── models/          # Data models with JSON serialization
│   ├── datasources/     # Mock/remote data sources
│   └── repositories/    # Repository implementations
│
├── presentation/        # UI layer
│   ├── bloc/           # BLoC state management
│   ├── screens/        # Screen widgets
│   └── widgets/        # Feature-specific widgets
│
└── di/                 # Feature dependency injection
```

## 🛠️ Tech Stack

### Core Dependencies
- **flutter_bloc** (^8.1.6) - State management
- **get_it** (^8.0.3) - Dependency injection
- **equatable** (^2.0.7) - Value equality
- **dartz** (^0.10.1) - Functional programming (Either, Option)

### Networking & Storage
- **dio** (^5.7.0) - HTTP client
- **shared_preferences** (^2.3.5) - Local storage
- **flutter_secure_storage** (^9.2.2) - Secure storage
- **cached_network_image** (^3.4.1) - Image caching

### UI & Utilities
- **iconsax_plus** (^1.0.0) - Icon library
- **loading_animation_widget** (^1.3.0) - Loading indicators
- **pinput** (^5.0.2) - PIN code input
- **flutter_osm_plugin** (^1.4.3) - Map integration

### Testing
- **mockito** (^5.4.4) - Mock generation
- **mocktail** (^1.0.4) - Alternative mocking library
- **bloc_test** (^9.1.0) - BLoC testing utilities
- **flutter_test** - Widget and unit testing

## 🔄 Mock Backend

The application uses **local mock data sources** instead of real API calls. This approach:
- Simulates realistic data structures and relationships
- Enables development without backend dependencies
- Demonstrates proper repository pattern implementation
- Includes artificial delays to simulate network latency

### Mock Data Locations
- **Auth**: `lib/features/auth/data/datasources/auth_remote_data_source.dart`
- **Suppliers**: `lib/features/supplier/data/datasources/supplier_remote_data_source.dart`
- **Items**: `lib/features/item/data/datasources/item_remote_data_source.dart`
- **Orders**: `lib/features/orders/data/datasources/order_local_data_source.dart`
- **Notifications**: `lib/features/notifications/data/datasources/notification_local_data_source.dart`

To connect to a real backend, replace the mock implementations in data sources while keeping repository interfaces unchanged.

## 🚀 Getting Started

### Prerequisites
- Flutter SDK ^3.8.1
- Dart SDK ^3.8.1

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd flutter_architecture_blueprint
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Running Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/features/auth/domain/usecases/login_test.dart
```

### Code Generation

If you modify models or add new mocks for testing:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## 🌍 Localization

The app supports multiple languages using Flutter's built-in localization:
- English (en)
- Arabic (ar)

ARB files are located in `lib/l10n/`. To add a new language:
1. Create `app_<locale>.arb` in `lib/l10n/`
2. Run `flutter gen-l10n` (happens automatically with `flutter run`)

## 🎨 Theming

The app includes light and dark themes with:
- Custom color schemes
- Responsive sizing utilities
- Theme extensions for colors, text, and spacing

Theme files: `lib/shared/theme/`

## 📱 Key Features

- **Authentication**: Login, OTP verification, token management
- **Home**: Supplier categories, featured items
- **Search**: Multi-tab search (suppliers and items)
- **Supplier Details**: Menu browsing, category tabs
- **Cart**: Add/remove items, quantity management
- **Orders**: Order history with status tracking
- **Notifications**: In-app notifications with read/unread states
- **Address Management**: Multiple delivery addresses
- **Profile**: Account settings, language/theme switching

## 🧪 Testing Strategy

The project includes:
- **Unit tests**: Use cases, repositories, BLoCs
- **Widget tests**: UI components
- **Integration tests**: Complete feature flows

Test helpers are located in `test/helpers/`:
- `test_helper.dart` - Mock generation
- `pump_app.dart` - Widget test utilities

## 📂 Project Conventions

- Feature names are **plural** when they manage collections (e.g., `orders`, `items`)
- Repository pattern separates data sources from domain logic
- BLoC handles all business logic and state management
- Dependency injection is scoped per feature with a central container
- All strings are localized (no hardcoded text)

## 🔧 Development Notes

- **No real API calls**: All data is mocked locally
- **Navigation**: Uses MaterialPageRoute with manual routing
- **State persistence**: Theme and locale preferences saved locally
- **Responsive design**: Custom responsive utilities in `lib/shared/responsive/`

## 📄 License

This project is for educational and portfolio purposes.

## 👤 Author

Built as a demonstration of Flutter architecture best practices for enterprise applications.

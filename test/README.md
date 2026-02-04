# Testing Guide

## Structure

Tests mirror the `lib/` structure:

```
test/
├── core/              # Core utilities and services
├── features/          # Feature tests (domain, data, presentation)
├── shared/            # Shared components
├── fixtures/          # Mock JSON data
└── helpers/           # Test utilities
    ├── test_helper.dart    # Mock generation
    ├── json_reader.dart    # Fixture loader
    └── pump_app.dart       # Widget test wrapper
```

## Quick Start

### Generate Mocks

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Run Tests

```bash
# All tests
flutter test

# With coverage
flutter test --coverage

# Specific file
flutter test test/features/auth/domain/usecases/login_test.dart

# Watch mode
flutter test --watch
```

## Test Types

### Unit Tests
Test business logic in isolation (use cases, repositories, BLoCs).

**Example**: `test/features/orders/domain/usecases/get_orders_test.dart`

### Widget Tests
Test UI components and interactions.

**Example**: `test/features/cart/presentation/widgets/cart_item_test.dart`

### BLoC Tests
Use `bloc_test` package for state management testing.

```dart
blocTest<OrderBloc, OrderState>(
  'emits [OrdersLoading, OrdersLoaded] when LoadOrdersEvent is added',
  build: () => OrderBloc(getOrders: mockGetOrders),
  act: (bloc) => bloc.add(LoadOrdersEvent()),
  expect: () => [OrdersLoading(), OrdersLoaded(orders)],
);
```

## Adding New Mocks

Edit `test/helpers/test_helper.dart`:

```dart
@GenerateMocks([
  DioClient,
  AuthRepository,
  // Add your class here
])
void main() {}
```

Then regenerate: `flutter pub run build_runner build --delete-conflicting-outputs`

## Test Helpers

### `pumpApp`
Wraps widgets with MaterialApp, theme, and localization:

```dart
await tester.pumpApp(MyWidget());
```

### `jsonReader`
Loads fixture files:

```dart
final json = jsonReader('auth/login_response.json');
```

## Coverage

Generate and view coverage report:

```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
# Open coverage/html/index.html
```

## Best Practices

- Mock external dependencies (repositories, data sources)
- Use `setUp` and `tearDown` for test initialization/cleanup
- Group related tests with `group()`
- Test both success and failure scenarios
- Verify error handling and edge cases

### Data Source Test Pattern

```dart
void main() {
  late DataSourceImpl dataSource;
  late MockDependency mockDependency;

  setUp(() {
    mockDependency = MockDependency();
    dataSource = DataSourceImpl(mockDependency);
  });

  group('methodName', () {
    test('should return data when successful', () async {
      // arrange
      when(mockDependency.call()).thenAnswer((_) async => mockData);

      // act
      final result = await dataSource.methodName();

      // assert
      expect(result.isRight(), true);
      verify(mockDependency.call());
    });

    test('should return failure when error occurs', () async {
      // arrange
      when(mockDependency.call()).thenThrow(Exception());

      // act
      final result = await dataSource.methodName();

      // assert
      expect(result.isLeft(), true);
    });
  });
}
```

### Cubit Test Pattern

```dart
void main() {
  late MyCubit cubit;
  late MockUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockUseCase();
    cubit = MyCubit(mockUseCase);
  });

  blocTest<MyCubit, MyState>(
    'emits [Loading, Loaded] when successful',
    build: () {
      when(mockUseCase()).thenAnswer((_) async => Right(data));
      return cubit;
    },
    act: (cubit) => cubit.loadData(),
    expect: () => [
      MyLoading(),
      MyLoaded(data),
    ],
  );
}
```

## Using Fixtures

Add JSON mock data to `test/fixtures/` and use the helper:

```dart
import '../../helpers/json_reader.dart';

final jsonData = json.decode(fixture('home/home_bootstrap.json'));
```

## Coverage Goals

- **Data Sources**: 100%
- **Models**: 100%
- **Repositories**: 90%+
- **Use Cases**: 90%+
- **Cubits**: 80%+
- **Overall**: 80%+

## Best Practices

1. ✅ **Arrange-Act-Assert**: Structure tests clearly
2. ✅ **Mock External Dependencies**: Never make real API calls
3. ✅ **Test Both Paths**: Success and failure cases
4. ✅ **Descriptive Names**: Test names should describe what they test
5. ✅ **One Assertion**: Each test should verify one thing
6. ✅ **Use Fixtures**: Reuse JSON data across tests
7. ✅ **Clean Up**: Use `setUp()` and `tearDown()` properly

## Troubleshooting

### Mock classes not found
Run: `flutter pub run build_runner build --delete-conflicting-outputs`

### Tests failing with "Target of URI doesn't exist"
1. Ensure dependencies are installed: `flutter pub get`
2. Generate mocks: `flutter pub run build_runner build --delete-conflicting-outputs`

### Coverage not generating
Install lcov (Windows: via Chocolatey):
```bash
choco install lcov
```

Then view coverage:
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
start coverage/html/index.html
```

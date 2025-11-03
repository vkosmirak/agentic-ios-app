# iOS Architecture Plan

## Overview

Modern, testable, modular iOS architecture using SwiftUI, Combine, and structured concurrency with MVVM-C pattern, dependency injection, and feature-based organization.

## Architecture Principles

- **MVVM-C** (Model-View-ViewModel-Coordinator) architecture
- **SwiftUI** for views with reactive data binding
- **Combine** for reactive programming and data flow
- **Structured Concurrency** (async/await) for modern asynchronous operations
- **Dependency Injection** via protocol-based container for testability
- **Feature-based modular structure** for reusability
- **Simplified architecture** with ViewModels handling business logic directly

## Architecture Pattern

### Simplified MVVM-C Structure
- **Views**: SwiftUI views (View)
- **ViewModels**: State management + business logic with Combine (ViewModel)
- **Coordinators**: Navigation and flow management (Coordinator)
- **Models**: Feature-specific models and entities
- **Services**: Reusable data sources (Network, Storage, etc.) injected into ViewModels

## Folder Structure (Feature-Based)

```
AgenticApp/
├── App/
│   ├── AgenticAppApp.swift (updated with DI setup)
│   └── AppCoordinator.swift (root coordinator)
│
├── Core/
│   ├── Architecture/
│   │   ├── Coordinator.swift (protocol)
│   │   └── ViewModel.swift (base protocol)
│   ├── DI/
│   │   ├── DependencyContainer.swift
│   │   └── DependencyKey.swift
│   ├── Extensions/
│   │   ├── View+Extensions.swift
│   │   └── Combine+Extensions.swift
│   └── Services/
│       ├── Network/
│       │   ├── NetworkService.swift
│       │   ├── NetworkError.swift
│       │   └── NetworkServiceProtocol.swift
│       ├── Storage/
│       │   ├── StorageService.swift
│       │   └── StorageServiceProtocol.swift
│       └── Utils/
│           └── [Shared utilities]
│
├── Features/
│   ├── Home/
│   │   ├── HomeView.swift
│   │   ├── HomeViewModel.swift
│   │   ├── HomeCoordinator.swift
│   │   └── Models/
│   │       └── HomeModel.swift
│   │
│   ├── [FeatureName]/
│   │   ├── [Feature]View.swift
│   │   ├── [Feature]ViewModel.swift
│   │   ├── [Feature]Coordinator.swift
│   │   └── Models/
│   │       └── [Feature]Model.swift
│   │
│   └── Shared/
│       └── Components/
│           └── [Reusable UI Components]
│
└── Resources/
    ├── Assets.xcassets/
    └── Localizable.strings (if needed)
```

## Key Components

### 1. Core Architecture Protocols

**Coordinator.swift**: Protocol for navigation coordination
- `start()` method
- Child coordinators management
- Navigation handling

**ViewModel.swift**: Base ViewModel protocol
- ObservableObject conformance
- Combine publishers setup
- Error handling
- Lifecycle methods (onAppear, onDisappear)

### 2. Dependency Injection Container

**DependencyContainer.swift**: Protocol-based DI container
- Protocol registration and resolution
- Singleton and factory patterns
- Test-friendly with mock support

**DependencyKey.swift**: Type-safe dependency keys
- Key-based dependency lookup
- Protocol conformance requirements

### 3. Services Layer

**NetworkService.swift**: Async/await networking wrapper
- URLSession-based implementation
- Error handling and retry logic
- Request/response logging
- Combine publishers for reactive updates

**StorageService.swift**: Local storage abstraction
- UserDefaults wrapper
- Keychain access
- Protocol-based for testability

### 4. Example Feature Module (Home)

**HomeView.swift**: SwiftUI view
- Reactive data binding via `@StateObject` or `@ObservedObject`
- View state management
- User interaction handlers

**HomeViewModel.swift**: ViewModel implementation
- Uses Combine for reactive state (`@Published` properties)
- Calls services directly (no use cases layer)
- Handles user actions
- Business logic implementation
- Error handling

**HomeCoordinator.swift**: Navigation coordinator
- Handles navigation flows
- Manages child coordinators
- Navigation route definitions

**Models/HomeModel.swift**: Feature-specific models
- Data structures for the feature
- Codable for API responses if needed

### 5. Testing Infrastructure

**MockDependencyContainer.swift**: Test DI container
- Mock implementations
- Easy test setup

**ViewModelsTests**: Unit tests for ViewModels
- Mock services
- State verification
- User action testing

**CoordinatorsTests**: Unit tests for coordinators
- Navigation flow verification
- Child coordinator management

## Implementation Details

### Combine Integration
- ViewModels use `@Published` properties for state
- Combine pipelines for data transformation
- Publishers for async operations
- Error handling with `catch` and `sink`
- Cancellation handling with `AnyCancellable`

### Structured Concurrency
- Services use `async/await` for async operations
- Task management in ViewModels
- Proper cancellation handling with `Task`
- Concurrent operations with `async let` and `TaskGroup`

### Dependency Injection Pattern
```swift
protocol DependencyContainer {
    func register<T>(_ type: T.Type, factory: @escaping () -> T)
    func resolve<T>(_ type: T.Type) -> T
}

// Usage in ViewModels
class HomeViewModel: ObservableObject {
    private let networkService: NetworkServiceProtocol
    private let storageService: StorageServiceProtocol
    
    init(
        networkService: NetworkServiceProtocol,
        storageService: StorageServiceProtocol
    ) {
        self.networkService = networkService
        self.storageService = storageService
    }
}
```

### Coordinator Pattern
```swift
protocol Coordinator: AnyObject {
    func start()
    var childCoordinators: [Coordinator] { get set }
}

// Navigation handled by coordinators
class HomeCoordinator: Coordinator {
    func navigateToDetail(id: String) {
        // Create and start DetailCoordinator
    }
}
```

### ViewModel Pattern
```swift
protocol ViewModel: ObservableObject {
    associatedtype State
    associatedtype Action
    
    var state: State { get }
    func handle(_ action: Action)
}

// Base implementation
class BaseViewModel: ViewModel {
    // Common functionality
    // Error handling
    // Loading states
}
```

## Testing Strategy

### Unit Tests
- **ViewModels**: Test state changes, user actions, business logic
- **Services**: Test network calls, storage operations
- **Coordinators**: Test navigation flows

### UI Tests
- SwiftUI view testing
- User interaction flows
- Navigation verification

## Migration Strategy

1. Create core architecture files (protocols, DI container)
2. Set up folder structure
3. Create Core Services (Network, Storage)
4. Create example feature (Home) with full stack
5. Migrate existing ContentView to new architecture
6. Update App entry point with DI setup
7. Write tests for example feature
8. Update documentation

## Files to Create/Modify

### New Files (Core Architecture)
- `Core/Architecture/Coordinator.swift`
- `Core/Architecture/ViewModel.swift`
- `Core/DI/DependencyContainer.swift`
- `Core/DI/DependencyKey.swift`
- `Core/Extensions/View+Extensions.swift`
- `Core/Extensions/Combine+Extensions.swift`

### New Files (Core Services)
- `Core/Services/Network/NetworkService.swift`
- `Core/Services/Network/NetworkError.swift`
- `Core/Services/Network/NetworkServiceProtocol.swift`
- `Core/Services/Storage/StorageService.swift`
- `Core/Services/Storage/StorageServiceProtocol.swift`

### New Files (Example Feature)
- `Features/Home/HomeView.swift`
- `Features/Home/HomeViewModel.swift`
- `Features/Home/HomeCoordinator.swift`
- `Features/Home/Models/HomeModel.swift`

### New Files (Testing)
- `AgenticAppTests/Core/MockDependencyContainer.swift`
- `AgenticAppTests/Features/Home/HomeViewModelTests.swift`
- `AgenticAppTests/Core/Services/NetworkServiceTests.swift`

### Modified Files
- `AgenticApp/AgenticAppApp.swift` - Add DI container initialization
- `AgenticApp/ContentView.swift` - Migrate to new architecture or remove
- `AGENTS.md` - Add architecture section

## Benefits

- **Testability**: Protocol-based DI enables easy mocking
- **Modularity**: Feature-based organization, easy to locate code
- **Reusability**: Shared components and services
- **Maintainability**: Consistent patterns across codebase
- **Scalability**: Easy to add new features following patterns
- **Modern**: Uses latest Swift concurrency and Combine
- **Type Safety**: Protocol-based abstractions prevent runtime errors
- **Simplified**: No unnecessary abstraction layers, ViewModels handle business logic directly

## Example: Adding a New Feature

1. Create feature folder: `Features/NewFeature/`
2. Create View: `NewFeatureView.swift`
3. Create ViewModel: `NewFeatureViewModel.swift` (inject services)
4. Create Coordinator: `NewFeatureCoordinator.swift`
5. Create Models: `Models/NewFeatureModel.swift`
6. Register dependencies in `DependencyContainer`
7. Add navigation route in parent coordinator
8. Write tests

## Best Practices

- Keep ViewModels focused on single feature responsibility
- Use protocols for all service dependencies
- Inject dependencies through initializers
- Use Combine for reactive state management
- Use async/await in services, Combine in ViewModels
- Keep Views simple - delegate logic to ViewModels
- Handle errors at ViewModel level
- Use coordinators for all navigation
- Keep feature models separate from service DTOs
- Write tests for ViewModels, Services, and Coordinators


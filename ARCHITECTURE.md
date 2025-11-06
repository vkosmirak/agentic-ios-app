# iOS Architecture Plan

## Overview

Modern, testable, modular iOS architecture using SwiftUI, Combine, and structured concurrency with MVVM-C pattern, dependency injection, and feature-based organization.

## Architecture Pattern

**MVVM-C** (Model-View-ViewModel-Coordinator) with:

- **Views**: SwiftUI views with reactive data binding
- **ViewModels**: State management + business logic using Combine (`@Published`)
- **Coordinators**: Navigation and flow management
- **Models**: Feature-specific models and entities
- **Services**: Reusable data sources (Network, Storage, etc.) injected into ViewModels

**Core Technologies**:

- SwiftUI for views
- Combine for reactive programming
- Structured Concurrency (async/await) for async operations
- Protocol-based Dependency Injection for testability
- Feature-based modular structure

## Folder Structure

```text
AgenticApp/
├── App/
│   ├── AgenticAppApp.swift
│   └── AppCoordinator.swift
│
├── Core/
│   ├── Architecture/
│   │   ├── Coordinator.swift
│   │   └── ViewModel.swift
│   ├── DI/
│   │   └── DependencyContainer.swift
│   ├── Extensions/
│   └── Services/
│       └── [ServiceName]/
│
├── Features/
│   └── [FeatureName]/
│       ├── [Feature]View.swift          # Main feature view
│       ├── [Feature]ViewModel.swift
│       ├── [Feature]Coordinator.swift
│       ├── Models/                       # Feature-specific models
│       └── Views/                        # Sub-views, reusable components
│           └── [SubView]View.swift
│
└── Resources/
    └── Assets.xcassets/
```

## Key Components

### Core Architecture

- **Coordinator.swift**: Protocol for navigation coordination (`start()`, child coordinators) with extension methods for managing child coordinators (`addChild()`, `removeChild()`, `removeAllChildren()`)
- **ViewModel.swift**: Base protocol with ObservableObject conformance, Combine setup (`cancellables`), lifecycle hooks (`onAppear()`, `onDisappear()`), and error handling

### Dependency Injection

- **DependencyContainer.swift**: Protocol-based DI container with registration/resolution, test-friendly mocks

### Services Layer

- Protocol-based services using async/await
- Error handling and logging
- Testable via protocol abstractions

### Feature Modules

Each feature follows the pattern:

- `[Feature]View.swift`: SwiftUI view with `@StateObject` or `@ObservedObject`
- `[Feature]ViewModel.swift`: State management with `@Published`, business logic, error handling
- `[Feature]Coordinator.swift`: Navigation flows and child coordinator management
- `Models/`: Feature-specific models (Codable for API responses)
- `Views/`: Sub-views, reusable components, and modal views for the feature

## Technical Patterns

- **Combine**: ViewModels use `@Published` for state, pipelines for transformation, proper cancellation with `AnyCancellable`
- **Async/Await**: Services use async/await, ViewModels manage `Task` with proper cancellation
- **Dependency Injection**: Protocol-based DI container enables testability

**Example DI Usage**:

```swift
class HomeViewModel: ViewModel {
    var cancellables: Set<AnyCancellable> = []
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func onAppear() {
        // Load data when view appears
    }
}
```

**Example Coordinator**:

```swift
protocol Coordinator: AnyObject {
    func start()
    var childCoordinators: [Coordinator] { get set }
}

// Typical implementation:
final class FeatureCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    private let dependencyContainer: DependencyContainer
    
    func start() {
        // Initialize child coordinators
    }
    
    @ViewBuilder
    func rootView() -> some View {
        // Create and return the feature's root view
        let service = dependencyContainer.resolve(ServiceProtocol.self)
        let viewModel = FeatureViewModel(service: service)
        return FeatureView(viewModel: viewModel)
    }
}
```

## Testing

**For detailed unit testing guidelines**: See `@UNIT_TESTING.md` for file organization, mock guidelines, and testing best practices.

- **Unit Tests**: ViewModels (state changes, user actions, business logic), Services (network, storage), Coordinators (navigation flows)
- **UI Tests**: SwiftUI view testing, user interaction flows, navigation verification
- **Test Infrastructure**: MockDependencyContainer for easy test setup

## Best Practices

- Keep ViewModels focused on single feature responsibility
- Use protocols for all service dependencies, inject via initializers
- Use Combine for reactive state, async/await in services
- Keep Views simple - delegate logic to ViewModels
- Handle errors at ViewModel level
- Use coordinators for all navigation
- Keep feature models separate from service DTOs
- Write tests for ViewModels, Services, and Coordinators

**Adding a New Feature**:

1. Create `Features/NewFeature/` folder
2. Add View, ViewModel, Coordinator, and Models
3. Register dependencies in `DependencyContainer`
4. Add navigation route in parent coordinator
5. Write tests

## Benefits

- **Testability & Maintainability**: Protocol-based DI enables easy mocking, consistent patterns
- **Modularity & Scalability**: Feature-based organization makes code easy to locate and extend
- **Modern & Type-Safe**: Latest Swift concurrency patterns with compile-time safety

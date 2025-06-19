# Claude Development Instructions

## Technical Constraints
- **iOS Version**: iOS 26+
- **Swift Version**: Swift 6.2+

## Architecture Requirements
- **Architecture Pattern**: MVVM (Model-View-ViewModel)
- **State Management**: ViewModels must handle state through actions/methods
- **UI Framework**: SwiftUI exclusively

## Code Standards
- **Async/Await**: Always use async/await for asynchronous operations
- **Testing Framework**: Swift Testing (not XCTest)
- **Design Principles**: Follow SOLID principles strictly
- **Class vs Struct**: Prefer struct over class when possible
- **Final Classes**: Use `final` keyword on classes when inheritance is not needed

## Swift Concurrency
- Use `async/await` syntax for all asynchronous operations
- Prefer `Task` for concurrent operations
- Follow Swift 6.2 concurrency rules and data isolation requirements
- UI updates are automatically handled by SwiftUI's data flow

## MVVM Implementation
- ViewModels should expose state through `@Published` properties
- Actions should be implemented as methods on ViewModels
- Views should only observe state and call ViewModel actions
- Models should be plain data structures

## Testing Guidelines
- Use Swift Testing framework
- Write unit tests for ViewModels
- Test state changes and actions
- Mock dependencies appropriately
- **Always test changes with**: `tuist build`

## SOLID Principles
- **Single Responsibility**: Each class/struct has one reason to change
- **Open/Closed**: Open for extension, closed for modification
- **Liskov Substitution**: Subtypes must be substitutable for base types
- **Interface Segregation**: Many specific interfaces over one general interface
- **Dependency Inversion**: Depend on abstractions, not concretions
# Changelog

All notable changes to this project will be documented in this file.

## [1.0.0] - 2025-12-12

### Added
- Initial release of Base BloC library
- `BaseBloC` abstract class with generic Event and State types
- State management using RxDart's BehaviorSubject
- Event processing with Stream-based architecture
- Resource cleanup with `dispose()` method
- Error handling with customizable `onError()` method
- `mapEventToState()` abstract method for event-to-state transformations
- `add()` method for dispatching events
- `emit()` method for directly emitting states
- `stateStream` for listening to state changes
- `eventSink` for adding events
- `isClosed` property to check if BloC is disposed
- Comprehensive inline documentation
- Example implementations (Counter and Async Data Loading)
- Full test coverage
- README with usage guide and best practices

# Base BloC

A base BloC (Business Logic Component) class for Flutter applications that provides a foundation for managing business logic components with built-in state management, resource cleanup, and event/state stream handling.

## Features

- **State Management**: Handle common state management operations with ease
- **Event-Driven Architecture**: Process events and emit states using Streams
- **Resource Cleanup**: Built-in dispose method to prevent memory leaks
- **Type-Safe**: Strongly typed events and states using Dart generics
- **Well-Documented**: Comprehensive inline documentation for all methods
- **Easy to Use**: Simple and intuitive API for creating BloCs

## Installation

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  base_bloc: ^1.0.0
```

Or if using this as a local package:

```yaml
dependencies:
  base_bloc:
    path: ../base_bloc
```

## Usage

### 1. Define Your Events

```dart
abstract class CounterEvent {}

class IncrementEvent extends CounterEvent {}

class DecrementEvent extends CounterEvent {}
```

### 2. Define Your States

```dart
class CounterState {
  final int count;
  
  CounterState(this.count);
}
```

### 3. Create Your BloC

```dart
import 'package:base_bloc/base_bloc_library.dart';

class CounterBloc extends BaseBloC<CounterEvent, CounterState> {
  CounterBloc() : super(CounterState(0));

  @override
  Stream<CounterState> mapEventToState(CounterEvent event) async* {
    if (event is IncrementEvent) {
      yield CounterState(state.count + 1);
    } else if (event is DecrementEvent) {
      yield CounterState(state.count - 1);
    }
  }
}
```

### 4. Use Your BloC

```dart
void main() async {
  // Create the BloC
  final counterBloc = CounterBloc();

  // Listen to state changes
  final subscription = counterBloc.stateStream.listen((state) {
    print('Count: ${state.count}');
  });

  // Dispatch events
  counterBloc.add(IncrementEvent());
  counterBloc.add(IncrementEvent());
  counterBloc.add(DecrementEvent());

  // Clean up when done
  await subscription.cancel();
  await counterBloc.dispose();
}
```

## API Reference

### BaseBloC<Event, State>

The base class for all BloCs. It manages the event-to-state transformation and provides stream-based state management.

#### Constructor

```dart
BaseBloC(State initialState)
```

Creates a new BloC instance with the specified initial state.

#### Properties

- **`state`** - Gets the current state of the BloC
- **`initialState`** - Gets the initial state that the BloC started with
- **`stateStream`** - Stream of state updates that emits states as they change
- **`eventSink`** - Sink for adding events to the BloC
- **`isClosed`** - Returns true if the BloC has been disposed

#### Methods

- **`add(Event event)`** - Adds an event to be processed by the BloC
- **`emit(State state)`** - Directly emits a new state (bypasses event processing)
- **`mapEventToState(Event event)`** - Abstract method that must be implemented to transform events into states
- **`onError(Object error, StackTrace stackTrace)`** - Handles errors during event processing (can be overridden)
- **`dispose()`** - Disposes the BloC and frees resources

## Advanced Usage

### Custom Error Handling

```dart
class MyBloc extends BaseBloC<MyEvent, MyState> {
  MyBloc() : super(MyState.initial());

  @override
  void onError(Object error, StackTrace stackTrace) {
    // Custom error handling
    logger.error('BloC error: $error');
    // Optionally emit an error state
    emit(MyState.error(error.toString()));
  }

  @override
  Stream<MyState> mapEventToState(MyEvent event) async* {
    // Event processing logic
  }
}
```

### Async Event Processing

```dart
@override
Stream<MyState> mapEventToState(MyEvent event) async* {
  if (event is LoadDataEvent) {
    yield LoadingState();
    
    try {
      final data = await fetchDataFromApi();
      yield LoadedState(data);
    } catch (e) {
      yield ErrorState(e.toString());
    }
  }
}
```

### Multiple State Emissions

```dart
@override
Stream<MyState> mapEventToState(MyEvent event) async* {
  if (event is ProcessDataEvent) {
    yield ProcessingState(progress: 0.0);
    
    for (int i = 0; i < 10; i++) {
      await processChunk(i);
      yield ProcessingState(progress: (i + 1) / 10);
    }
    
    yield CompletedState();
  }
}
```

## Best Practices

1. **Always call dispose()**: Ensure you dispose of BloCs when they're no longer needed to prevent memory leaks
2. **One BloC per feature**: Keep BloCs focused on a single area of business logic
3. **Immutable states**: Make your state classes immutable for predictable behavior
4. **Descriptive events**: Use clear, action-based names for your events
5. **Error handling**: Override `onError` for custom error handling logic

## Testing

The package includes comprehensive tests. To run them:

```bash
dart test
```

Example test:

```dart
import 'package:test/test.dart';
import 'package:base_bloc/base_bloc_library.dart';

void main() {
  test('BloC emits correct states', () async {
    final bloc = CounterBloc();
    
    expect(
      bloc.stateStream,
      emitsInOrder([
        CounterState(0),  // initial
        CounterState(1),  // after increment
        CounterState(2),  // after another increment
      ]),
    );
    
    bloc.add(IncrementEvent());
    bloc.add(IncrementEvent());
    
    await bloc.dispose();
  });
}
```

## Example

See the [example](example/counter_bloc_example.dart) directory for a complete working example.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is open source and available under the MIT License.

## Architecture

The Base BloC class follows these principles:

- **Separation of Concerns**: Business logic is separated from UI
- **Reactive Programming**: Uses Streams for reactive state updates
- **Unidirectional Data Flow**: Events flow in → States flow out
- **Testability**: Easy to test business logic in isolation

```
┌─────────────┐
│    Event    │
└──────┬──────┘
       │
       ▼
┌─────────────────┐
│   mapEventTo    │
│     State       │
└──────┬──────────┘
       │
       ▼
┌─────────────┐
│    State    │
└─────────────┘
```

## Credits

Created by Nguyen Duc Dong
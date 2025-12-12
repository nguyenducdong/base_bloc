import 'dart:async';
import 'package:rxdart/rxdart.dart';

/// Base BloC (Business Logic Component) class that provides a foundation for
/// managing business logic components in Flutter applications.
///
/// This class handles common state management operations, resource cleanup,
/// and provides a clear structure for managing events and states using Streams.
///
/// Type Parameters:
/// * [Event] - The type of events that this BloC will process
/// * [State] - The type of states that this BloC will emit
///
/// Example usage:
/// ```dart
/// // Define your events and states
/// abstract class CounterEvent {}
/// class IncrementEvent extends CounterEvent {}
/// class DecrementEvent extends CounterEvent {}
///
/// class CounterState {
///   final int count;
///   CounterState(this.count);
/// }
///
/// // Create a BloC by extending BaseBloC
/// class CounterBloc extends BaseBloC<CounterEvent, CounterState> {
///   CounterBloc() : super(CounterState(0));
///
///   @override
///   Stream<CounterState> mapEventToState(CounterEvent event) async* {
///     if (event is IncrementEvent) {
///       yield CounterState(state.count + 1);
///     } else if (event is DecrementEvent) {
///       yield CounterState(state.count - 1);
///     }
///   }
/// }
/// ```
abstract class BaseBloC<Event, State> {
  /// The initial state of the BloC
  final State _initialState;

  /// Current state of the BloC
  State _state;

  /// Stream controller for managing state updates
  final BehaviorSubject<State> _stateController = BehaviorSubject<State>();

  /// Stream controller for managing incoming events
  final StreamController<Event> _eventController = StreamController<Event>();

  /// Subscription to event stream
  StreamSubscription<Event>? _eventSubscription;

  /// Creates a new instance of BaseBloC with an initial state
  ///
  /// [initialState] - The initial state that the BloC starts with
  BaseBloC(State initialState)
      : _initialState = initialState,
        _state = initialState {
    _stateController.add(_state);
    _bindEventsToStates();
  }

  /// Gets the current state of the BloC
  State get state => _state;

  /// Gets the initial state of the BloC
  State get initialState => _initialState;

  /// Stream of state updates that can be listened to
  ///
  /// This stream emits the current state immediately when subscribed to,
  /// and then emits new states whenever they are produced.
  Stream<State> get stateStream => _stateController.stream;

  /// Sink for adding events to the BloC
  ///
  /// Use this to dispatch events that will be processed by the BloC.
  /// Example: `bloc.eventSink.add(IncrementEvent());`
  StreamSink<Event> get eventSink => _eventController.sink;

  /// Adds an event to be processed by the BloC
  ///
  /// This is a convenience method that wraps [eventSink.add].
  ///
  /// [event] - The event to be processed
  void add(Event event) {
    if (!_eventController.isClosed) {
      _eventController.sink.add(event);
    }
  }

  /// Binds the event stream to state transformations
  ///
  /// This method sets up the subscription that listens to incoming events
  /// and transforms them into states using [mapEventToState].
  void _bindEventsToStates() {
    _eventSubscription = _eventController.stream.asyncExpand((event) {
      return mapEventToState(event);
    }).listen(
      (state) {
        _state = state;
        _stateController.add(_state);
      },
      onError: onError,
    );
  }

  /// Maps incoming events to state changes
  ///
  /// This abstract method must be implemented by subclasses to define
  /// how events are transformed into states.
  ///
  /// [event] - The event to be processed
  ///
  /// Returns a Stream of states that will be emitted as a result of
  /// processing the event.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Stream<MyState> mapEventToState(MyEvent event) async* {
  ///   if (event is LoadDataEvent) {
  ///     yield LoadingState();
  ///     try {
  ///       final data = await fetchData();
  ///       yield LoadedState(data);
  ///     } catch (e) {
  ///       yield ErrorState(e.toString());
  ///     }
  ///   }
  /// }
  /// ```
  Stream<State> mapEventToState(Event event);

  /// Handles errors that occur during event processing
  ///
  /// Override this method to provide custom error handling.
  /// By default, errors are printed to the console.
  ///
  /// [error] - The error that occurred
  /// [stackTrace] - The stack trace associated with the error
  void onError(Object error, StackTrace stackTrace) {
    print('BaseBloC Error: $error');
    print('Stack trace: $stackTrace');
  }

  /// Emits a new state
  ///
  /// This method can be used to emit states directly without processing events.
  /// Use with caution as it bypasses the event-driven architecture.
  ///
  /// [state] - The state to emit
  void emit(State state) {
    _state = state;
    if (!_stateController.isClosed) {
      _stateController.add(_state);
    }
  }

  /// Checks if the BloC has been disposed
  bool get isClosed => _stateController.isClosed;

  /// Disposes of the BloC and frees up resources
  ///
  /// This method should be called when the BloC is no longer needed.
  /// It closes all streams and cancels subscriptions to prevent memory leaks.
  ///
  /// After calling dispose, the BloC should not be used anymore.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// void dispose() {
  ///   // Dispose of any additional resources
  ///   mySubscription.cancel();
  ///   // Call super to dispose base resources
  ///   super.dispose();
  /// }
  /// ```
  Future<void> dispose() async {
    await _eventSubscription?.cancel();
    await _eventController.close();
    await _stateController.close();
  }
}

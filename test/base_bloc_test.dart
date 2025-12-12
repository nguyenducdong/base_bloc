import 'dart:async';
import 'package:test/test.dart';
import 'package:base_bloc/base_bloc_library.dart';

// Test events
abstract class TestEvent {}

class IncrementEvent extends TestEvent {}

class DecrementEvent extends TestEvent {}

class ErrorEvent extends TestEvent {}

// Test states
class TestState {
  final int value;

  TestState(this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TestState &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'TestState(value: $value)';
}

// Test BloC implementation
class TestBloc extends BaseBloC<TestEvent, TestState> {
  TestBloc(TestState initialState) : super(initialState);

  @override
  Stream<TestState> mapEventToState(TestEvent event) async* {
    if (event is IncrementEvent) {
      yield TestState(state.value + 1);
    } else if (event is DecrementEvent) {
      yield TestState(state.value - 1);
    } else if (event is ErrorEvent) {
      throw Exception('Test error');
    }
  }
}

// Test BloC with custom error handling
class TestBlocWithErrorHandler extends BaseBloC<TestEvent, TestState> {
  final List<Object> errors = [];

  TestBlocWithErrorHandler(TestState initialState) : super(initialState);

  @override
  Stream<TestState> mapEventToState(TestEvent event) async* {
    if (event is ErrorEvent) {
      throw Exception('Test error');
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    errors.add(error);
    super.onError(error, stackTrace);
  }
}

void main() {
  group('BaseBloC', () {
    late TestBloc bloc;

    setUp(() {
      bloc = TestBloc(TestState(0));
    });

    tearDown(() async {
      await bloc.dispose();
    });

    test('initial state is correct', () {
      expect(bloc.state, equals(TestState(0)));
      expect(bloc.initialState, equals(TestState(0)));
    });

    test('state stream emits initial state immediately', () {
      expect(bloc.stateStream, emits(TestState(0)));
    });

    test('dispatching events updates state correctly', () async {
      final states = <TestState>[];

      final subscription = bloc.stateStream.listen((state) {
        states.add(state);
      });

      bloc.add(IncrementEvent());
      await Future.delayed(Duration(milliseconds: 50));

      bloc.add(IncrementEvent());
      await Future.delayed(Duration(milliseconds: 50));

      bloc.add(DecrementEvent());
      await Future.delayed(Duration(milliseconds: 50));

      expect(states.length, equals(4)); // initial + 3 events
      expect(states[0], equals(TestState(0))); // initial
      expect(states[1], equals(TestState(1))); // after first increment
      expect(states[2], equals(TestState(2))); // after second increment
      expect(states[3], equals(TestState(1))); // after decrement

      await subscription.cancel();
    });

    test('add method adds events to the event stream', () async {
      final states = <TestState>[];

      final subscription = bloc.stateStream.listen((state) {
        states.add(state);
      });

      bloc.add(IncrementEvent());
      await Future.delayed(Duration(milliseconds: 50));

      expect(states.length, equals(2)); // initial + 1 event
      expect(states[1], equals(TestState(1)));

      await subscription.cancel();
    });

    test('emit method directly emits a new state', () async {
      final states = <TestState>[];

      final subscription = bloc.stateStream.listen((state) {
        states.add(state);
      });

      bloc.emit(TestState(42));
      await Future.delayed(Duration(milliseconds: 50));

      expect(states.length, equals(2)); // initial + emitted
      expect(states[1], equals(TestState(42)));
      expect(bloc.state, equals(TestState(42)));

      await subscription.cancel();
    });

    test('multiple events are processed in order', () async {
      final states = <TestState>[];

      final subscription = bloc.stateStream.listen((state) {
        states.add(state);
      });

      bloc.add(IncrementEvent());
      bloc.add(IncrementEvent());
      bloc.add(IncrementEvent());
      bloc.add(DecrementEvent());

      await Future.delayed(Duration(milliseconds: 200));

      expect(states.length, equals(5)); // initial + 4 events
      expect(states[0], equals(TestState(0))); // initial
      expect(states[1], equals(TestState(1)));
      expect(states[2], equals(TestState(2)));
      expect(states[3], equals(TestState(3)));
      expect(states[4], equals(TestState(2)));

      await subscription.cancel();
    });

    test('isClosed returns false before dispose', () {
      expect(bloc.isClosed, isFalse);
    });

    test('isClosed returns true after dispose', () async {
      await bloc.dispose();
      expect(bloc.isClosed, isTrue);
    });

    test('dispose closes all streams', () async {
      await bloc.dispose();

      expect(bloc.isClosed, isTrue);

      // Attempting to add events after dispose should not throw
      bloc.add(IncrementEvent());
    });

    test('error handling calls onError', () async {
      final errorBloc = TestBlocWithErrorHandler(TestState(0));

      errorBloc.add(ErrorEvent());
      await Future.delayed(Duration(milliseconds: 100));

      expect(errorBloc.errors.length, equals(1));
      expect(errorBloc.errors[0].toString(), contains('Test error'));

      await errorBloc.dispose();
    });

    test('state stream can have multiple listeners', () async {
      final states1 = <TestState>[];
      final states2 = <TestState>[];

      final subscription1 = bloc.stateStream.listen((state) {
        states1.add(state);
      });

      final subscription2 = bloc.stateStream.listen((state) {
        states2.add(state);
      });

      bloc.add(IncrementEvent());
      await Future.delayed(Duration(milliseconds: 50));

      expect(states1.length, equals(2)); // initial + 1 event
      expect(states2.length, equals(2)); // initial + 1 event
      expect(states1[1], equals(TestState(1)));
      expect(states2[1], equals(TestState(1)));

      await subscription1.cancel();
      await subscription2.cancel();
    });

    test('state is updated before stream emits', () async {
      bloc.add(IncrementEvent());
      await Future.delayed(Duration(milliseconds: 50));

      expect(bloc.state, equals(TestState(1)));
    });

    test('eventSink can be used to add events', () async {
      final states = <TestState>[];

      final subscription = bloc.stateStream.listen((state) {
        states.add(state);
      });

      bloc.eventSink.add(IncrementEvent());
      await Future.delayed(Duration(milliseconds: 50));

      expect(states.length, equals(2));
      expect(states[1], equals(TestState(1)));

      await subscription.cancel();
    });
  });

  group('BaseBloC edge cases', () {
    test('can create BloC with different initial states', () {
      final bloc1 = TestBloc(TestState(10));
      final bloc2 = TestBloc(TestState(100));

      expect(bloc1.state, equals(TestState(10)));
      expect(bloc2.state, equals(TestState(100)));

      bloc1.dispose();
      bloc2.dispose();
    });

    test('disposing multiple times does not throw', () async {
      final bloc = TestBloc(TestState(0));

      await bloc.dispose();
      await bloc.dispose();
      await bloc.dispose();

      expect(bloc.isClosed, isTrue);
    });

    test('emit after dispose does not throw', () async {
      final bloc = TestBloc(TestState(0));
      await bloc.dispose();

      // Should not throw
      bloc.emit(TestState(42));

      expect(bloc.isClosed, isTrue);
    });
  });
}

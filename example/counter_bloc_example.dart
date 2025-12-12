import 'dart:async';
import 'package:base_bloc/base_bloc_library.dart';

/// Example demonstrating how to use the BaseBloC class
/// This example implements a simple counter using the BloC pattern

// Step 1: Define your events
abstract class CounterEvent {}

class IncrementEvent extends CounterEvent {}

class DecrementEvent extends CounterEvent {}

class ResetEvent extends CounterEvent {}

// Step 2: Define your states
class CounterState {
  final int count;

  CounterState(this.count);

  @override
  String toString() => 'CounterState(count: $count)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CounterState &&
          runtimeType == other.runtimeType &&
          count == other.count;

  @override
  int get hashCode => count.hashCode;
}

// Step 3: Create a BloC by extending BaseBloC
class CounterBloc extends BaseBloC<CounterEvent, CounterState> {
  CounterBloc() : super(CounterState(0));

  @override
  Stream<CounterState> mapEventToState(CounterEvent event) async* {
    if (event is IncrementEvent) {
      yield CounterState(state.count + 1);
    } else if (event is DecrementEvent) {
      yield CounterState(state.count - 1);
    } else if (event is ResetEvent) {
      yield CounterState(0);
    }
  }
}

// Example usage
void main() async {
  print('=== Counter BloC Example ===\n');

  // Create the BloC
  final counterBloc = CounterBloc();

  // Listen to state changes
  final subscription = counterBloc.stateStream.listen((state) {
    print('New state: $state');
  });

  print('Initial state: ${counterBloc.state}\n');

  // Dispatch events
  print('Dispatching IncrementEvent...');
  counterBloc.add(IncrementEvent());
  await Future.delayed(Duration(milliseconds: 100));

  print('Dispatching IncrementEvent...');
  counterBloc.add(IncrementEvent());
  await Future.delayed(Duration(milliseconds: 100));

  print('Dispatching IncrementEvent...');
  counterBloc.add(IncrementEvent());
  await Future.delayed(Duration(milliseconds: 100));

  print('Dispatching DecrementEvent...');
  counterBloc.add(DecrementEvent());
  await Future.delayed(Duration(milliseconds: 100));

  print('Dispatching ResetEvent...');
  counterBloc.add(ResetEvent());
  await Future.delayed(Duration(milliseconds: 100));

  print('\nFinal state: ${counterBloc.state}');

  // Clean up resources
  await subscription.cancel();
  await counterBloc.dispose();

  print('\nBloC disposed successfully!');
}

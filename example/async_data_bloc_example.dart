import 'dart:async';
import 'package:base_bloc/base_bloc_library.dart';

/// Example demonstrating async data loading with error handling
/// This shows how to use BaseBloC for real-world async operations

// Events
abstract class DataEvent {}

class LoadDataEvent extends DataEvent {}

class RefreshDataEvent extends DataEvent {}

class ClearDataEvent extends DataEvent {}

// States
abstract class DataState {}

class InitialState extends DataState {
  @override
  String toString() => 'InitialState';
}

class LoadingState extends DataState {
  @override
  String toString() => 'LoadingState';
}

class LoadedState extends DataState {
  final List<String> data;

  LoadedState(this.data);

  @override
  String toString() => 'LoadedState(${data.length} items)';
}

class ErrorState extends DataState {
  final String message;

  ErrorState(this.message);

  @override
  String toString() => 'ErrorState($message)';
}

// BloC implementation
class DataBloc extends BaseBloC<DataEvent, DataState> {
  DataBloc() : super(InitialState());

  // Simulate fetching data from an API
  Future<List<String>> _fetchData() async {
    await Future.delayed(Duration(seconds: 1));
    // Simulate successful data fetch
    return ['Item 1', 'Item 2', 'Item 3', 'Item 4', 'Item 5'];
  }

  @override
  Stream<DataState> mapEventToState(DataEvent event) async* {
    if (event is LoadDataEvent) {
      yield LoadingState();

      try {
        final data = await _fetchData();
        yield LoadedState(data);
      } catch (e) {
        yield ErrorState(e.toString());
      }
    } else if (event is RefreshDataEvent) {
      // Show loading even if we already have data
      yield LoadingState();

      try {
        await Future.delayed(Duration(milliseconds: 500));
        final data = await _fetchData();
        yield LoadedState(data);
      } catch (e) {
        yield ErrorState(e.toString());
      }
    } else if (event is ClearDataEvent) {
      yield InitialState();
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    print('DataBloc encountered an error: $error');
    super.onError(error, stackTrace);
  }
}

// Example usage
void main() async {
  print('=== Async Data BloC Example ===\n');

  final dataBloc = DataBloc();

  // Listen to all state changes
  final subscription = dataBloc.stateStream.listen((state) {
    print('State changed: $state');
  });

  print('1. Loading data...');
  dataBloc.add(LoadDataEvent());

  // Wait for data to load
  await Future.delayed(Duration(milliseconds: 1200));

  print('\n2. Refreshing data...');
  dataBloc.add(RefreshDataEvent());

  // Wait for refresh
  await Future.delayed(Duration(milliseconds: 1200));

  print('\n3. Clearing data...');
  dataBloc.add(ClearDataEvent());

  await Future.delayed(Duration(milliseconds: 100));

  print('\nCurrent state: ${dataBloc.state}');

  // Cleanup
  await subscription.cancel();
  await dataBloc.dispose();

  print('\nBloC disposed successfully!');
}

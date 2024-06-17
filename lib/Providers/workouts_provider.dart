import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/Data/jadyn_workouts.dart';
import 'package:workout_tracker/Models/workout_set.dart';

class WorkoutsNotifier extends StateNotifier<List<WorkoutSet>> {
  WorkoutsNotifier() : super(myWorkouts);

  void workoutsInitialized() {
    state = myWorkouts;
  }
}

final workoutsProvider =
    StateNotifierProvider<WorkoutsNotifier, List<WorkoutSet>>((ref) {
  return WorkoutsNotifier();
});

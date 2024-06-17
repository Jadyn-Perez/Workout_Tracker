import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/Models/workout_set.dart';
import 'package:workout_tracker/Providers/workouts_provider.dart';
import 'package:workout_tracker/Widgets/workout_table.dart';

class ViewWorkoutsScreen extends ConsumerWidget {
  const ViewWorkoutsScreen({super.key});

  static const routeName = 'viewWorkoutsScreen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<WorkoutSet> workoutSets = ref.watch(workoutsProvider);
    Map<String, List<WorkoutSet>> workouts = {};
    for (var set in workoutSets) {
      if (workouts[set.date] == null) {
        workouts[set.date] = [set];
      } else {
        workouts[set.date]!.add(set);
      }
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text('Workouts'),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.all(20),
          child: ListView.builder(
            itemCount: workouts.keys.length,
            itemBuilder: (ctx, i) => GestureDetector(
              onTap: () {
                print(workoutSets.length);
              },
              child: WorkoutTable(
                  workoutSets: workouts[workouts.keys.toList()[i]]!),
            ),
          ),
        ));
  }
}

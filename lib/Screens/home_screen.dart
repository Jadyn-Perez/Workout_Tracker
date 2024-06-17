import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_tracker/Data/jadyn_workouts.dart';
import 'package:workout_tracker/Providers/workouts_provider.dart';
import 'package:workout_tracker/Screens/record_workout_data_screen.dart';
import 'package:workout_tracker/Screens/view_workouts_screen.dart';
import 'package:workout_tracker/Widgets/main_button.dart';
import 'package:workout_tracker/database_helper.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const routeName = 'homeScreen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Workout Tracker'),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset('assets/images/christian_cross.png', height: 300),
                MainButton(
                    function: () async {
                      await DatabaseHelper().database;
                      Navigator.of(context)
                          .pushNamed(RecordWorkoutDataScreen.routeName);
                    },
                    text: 'Record New Workout'),
                MainButton(
                    function: () async {
                      await DatabaseHelper().database;
                      myWorkouts = await DatabaseHelper().getItems();
                      ref.read(workoutsProvider.notifier).workoutsInitialized();
                      for (var entry in myWorkouts) {
                        print(entry.exercise);
                        print(entry.date);
                      }
                      Navigator.of(context)
                          .pushNamed(ViewWorkoutsScreen.routeName);
                    },
                    text: 'View Old Workout'),
              ],
            ),
          ),
        ));
  }
}

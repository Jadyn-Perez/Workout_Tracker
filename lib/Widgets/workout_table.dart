import 'package:flutter/material.dart';
import '../Models/workout_set.dart'; // Make sure to replace with the correct path to your model

class WorkoutTable extends StatelessWidget {
  final List<WorkoutSet> workoutSets;

  WorkoutTable({required this.workoutSets});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(label: Text('Date')),
          DataColumn(label: Text('Number')),
          DataColumn(label: Text('Exercise')),
          DataColumn(label: Text('Reps')),
          DataColumn(label: Text('Weight')),
        ],
        rows: workoutSets.map((set) {
          return DataRow(cells: [
            DataCell(Text(set.date)),
            DataCell(Text(set.number.toString())),
            DataCell(Text(set.exercise)),
            DataCell(Text(set.reps.toString())),
            DataCell(Text(set.weight.toString())),
          ]);
        }).toList(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workout_tracker/Models/workout_set.dart';
import 'package:workout_tracker/Widgets/main_button.dart';
import 'package:uuid/uuid.dart';
import 'package:workout_tracker/database_helper.dart';

var uuid = const Uuid();

class RecordWorkoutDataScreen extends StatefulWidget {
  RecordWorkoutDataScreen({super.key});

  static const routeName = 'recordWorkoutDataScreen';

  @override
  State<RecordWorkoutDataScreen> createState() =>
      _RecordWorkoutDataScreenState();
}

class _RecordWorkoutDataScreenState extends State<RecordWorkoutDataScreen> {
  Map<TextFormField, List<WorkoutSet>> exerciseFields = {};
  Map<String, List<String>> workout = {};
  Map<String, TextEditingController> exerciseControllers = {};
  int numberOfExercises = 0;
  Map<String, TextEditingController> controllers = {};

  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('MMMM/dd/y');

  @override
  Widget build(BuildContext context) {
    final String currentDate = formatter.format(now);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Record Workout'),
        actions: [
          IconButton(
            onPressed: () async {
              for (var entry in exerciseFields.values) {
                for (var currentSet in entry) {
                  print(currentSet.number);
                  await DatabaseHelper().insertItem(currentSet);
                }
              }

              setState(() {
                exerciseFields = {};
                workout = {};
                exerciseControllers = {};
                numberOfExercises = 0;
                controllers = {};
              });
            },
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                height: MediaQuery.of(context).size.height * 0.8,
                child: ListView.builder(
                  cacheExtent: 5000,
                  itemBuilder: (context, index) {
                    TextFormField currentEntry =
                        exerciseFields.keys.toList()[index];
                    return Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        children: [
                          exerciseFields.keys.toList()[index],
                          Container(
                            height: 150,
                            // Rows for Set Information
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, i) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          'Set ${exerciseFields[currentEntry]![i].number}',
                                        ),
                                        DropdownButton<int>(
                                            value:
                                                exerciseFields[currentEntry]![i]
                                                    .reps,
                                            items: <int>[
                                              1,
                                              2,
                                              3,
                                              4,
                                              5,
                                              6,
                                              7,
                                              8,
                                              9,
                                              10,
                                            ].map((int value) {
                                              return DropdownMenuItem<int>(
                                                value: value,
                                                child: Text(value.toString()),
                                              );
                                            }).toList(),
                                            onChanged: (newValue) {
                                              setState(() {
                                                exerciseFields[currentEntry]![i]
                                                    .reps = newValue!;
                                              });
                                            }),
                                        SizedBox(
                                          height: 30,
                                          width: 100,
                                          child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            controller: controllers[i],
                                            style: const TextStyle(
                                                color: Colors.black),
                                            decoration: InputDecoration(
                                                hintText: 'Weight'),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.trim().isEmpty) {
                                                return 'Invalid Weight';
                                              }
                                              return null;
                                            },
                                            onFieldSubmitted: (newValue) {
                                              setState(() {
                                                exerciseFields[currentEntry]![i]
                                                        .weight =
                                                    int.parse(newValue);
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                itemCount:
                                    exerciseFields[currentEntry]!.length),
                          ),
                          MainButton(
                              function: () {
                                String newId = uuid.v4();
                                print(exerciseFields.keys
                                    .toList()[index]
                                    .controller!
                                    .text);
                                setState(() {
                                  controllers[newId] =
                                      TextEditingController.fromValue(
                                    TextEditingValue(
                                      selection:
                                          TextSelection.collapsed(offset: 0),
                                    ),
                                  );
                                  exerciseFields[currentEntry]!.add(WorkoutSet(
                                    number:
                                        exerciseFields[currentEntry]!.length +
                                            1,
                                    weight: 0,
                                    reps: 1,
                                    id: newId,
                                    date: currentDate,
                                    exercise: '',
                                  ));
                                });
                              },
                              text: 'Add Set')
                        ],
                      ),
                    );
                  },
                  itemCount: exerciseFields.length,
                )),
            MainButton(
                function: () {
                  String newId = uuid.v4();
                  exerciseControllers[newId] = TextEditingController();
                  setState(() {
                    numberOfExercises += 1;
                    exerciseFields[TextFormField(
                      controller: exerciseControllers[newId],
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          hintText: 'Exercise $numberOfExercises'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Invalid Exercise Name';
                        }
                        return null;
                      },
                      onFieldSubmitted: (value) {
                        TextFormField savedField = exerciseFields.keys
                            .firstWhere((element) =>
                                element.controller ==
                                exerciseControllers[newId]);
                        for (var entry in exerciseFields[savedField]!) {
                          entry.exercise = value;
                          print(entry.exercise);
                        }
                        print(exerciseControllers[
                            exerciseControllers.length - 1]);
                      },
                    )] = [
                      WorkoutSet(
                        number: 1,
                        weight: 0,
                        reps: 1,
                        id: uuid.v4(),
                        date: currentDate,
                        exercise: '',
                      )
                    ];
                  });
                },
                text: 'Add Exercise'),
          ],
        ),
      ),
    );
  }
}

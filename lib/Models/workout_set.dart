class WorkoutSet {
  WorkoutSet({
    required this.number,
    required this.weight,
    required this.reps,
    required this.id,
    required this.date,
    required this.exercise,
  });

  int number;
  int weight;
  int reps;
  String id;
  String date;
  String exercise;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'weight': weight,
      'reps': reps,
      'number': number,
      'date': date,
      'exercise': exercise,
    };
  }

  factory WorkoutSet.fromMap(Map<String, dynamic> map) {
    return WorkoutSet(
        id: map['id'],
        weight: map['weight'],
        reps: map['reps'],
        number: map['number'],
        date: map['date'],
        exercise: map['exercise']);
  }
}

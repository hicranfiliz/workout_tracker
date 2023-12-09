import 'package:flutter/material.dart';
import 'package:workout_tracker/models/exercise.dart';
import 'package:workout_tracker/models/workout.dart';

class WorkoutData extends ChangeNotifier {
  // WORKOUT DATA STRUCTURE
  // this overall list contains the different workouts
  // each workout has a name, and list of exercises.

  List<Workout> workoutList = [
    // default workout::
    Workout(name: "Upper Body", exercises: [
      Exercise(
        name: "Bicep Curls",
        weight: "10",
        reps: "10",
        sets: "3",
      )
    ])
  ];

  // get the list of workout
  List<Workout> getWokroutList() {
    return workoutList;
  }

  // get lenght of a given workout
  int numberOfExercisesInWorkout(String workoutName) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    return relevantWorkout.exercises.length;
  }

  // add a workout
  void addWorkout(String name) {
    // add a new workout with a blank list of xercises.
    workoutList.add(Workout(name: name, exercises: []));

    notifyListeners();
  }

  // add an exercise to a workout
  void addExercise(String workoutName, String exerciseName, String weight,
      String reps, String sets) {
    // find the relevant workout
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    relevantWorkout.exercises.add(
        Exercise(name: exerciseName, weight: weight, reps: reps, sets: sets));
    notifyListeners();
  }

  // check of exercise
  void checkOffExercise(String workoutName, String exerciseName) {
    //find the relevant workout and relevant exercise in that workout..
    Exercise relevantExercise = getRelevantExercise(workoutName, exerciseName);

    // check off boolean to show user completed the exercise..
    relevantExercise.isCXompleted = !relevantExercise.isCXompleted;

    notifyListeners();
  }

  // return relevant workout object, given a workout name
  Workout getRelevantWorkout(String workoutName) {
    Workout relevantWorkout =
        workoutList.firstWhere((workout) => workout.name == workoutName);

    return relevantWorkout;
  }

  // return relevant exercise object, given a workout name + exercise name
  Exercise getRelevantExercise(String workoutName, String exerciseName) {
    // find relevant workout first:
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    // then find the relevant exercise in that workout..
    Exercise relevantExercise = relevantWorkout.exercises
        .firstWhere((exercise) => exercise.name == exerciseName);

    return relevantExercise;
  }
}

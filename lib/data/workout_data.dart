import 'package:flutter/material.dart';
import 'package:workout_tracker/data/hive_database.dart';
import 'package:workout_tracker/datetime/date_time.dart';
import 'package:workout_tracker/models/exercise.dart';
import 'package:workout_tracker/models/workout.dart';

class WorkoutData extends ChangeNotifier {
  final db = HiveDatabase();

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
    ]),
    Workout(name: "Lower Body", exercises: [
      Exercise(
        name: "Squat",
        weight: "10",
        reps: "10",
        sets: "3",
      )
    ]),
    Workout(name: "Full Body", exercises: [
      Exercise(
        name: "Bicep Curls",
        weight: "10",
        reps: "10",
        sets: "3",
      )
    ])
  ];

  // if there are workouts already in database, then get that workout list, otherwise use default workouts
  void initializeWorkoutList() {
    if (db.previousDataExists()) {
      // List<Workout>? storedWorkouts = db.readFromDatabase();
      // if (storedWorkouts != null) {
      //   workoutList = storedWorkouts;
      // }
      workoutList = db.readFromDatabase();
    } // otherwise use default workouts
    else {
      db.saveToDatabase(workoutList);
    }

    // load heat map
    loadHeatMap();
  }

  // get the list of workout
  List<Workout> getWorkoutList() {
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

    // save to database
    db.saveToDatabase(workoutList);
  }

  // add an exercise to a workout
  void addExercise(String workoutName, String exerciseName, String weight,
      String reps, String sets) {
    // find the relevant workout
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    relevantWorkout.exercises.add(
        Exercise(name: exerciseName, weight: weight, reps: reps, sets: sets));
    notifyListeners();
    // save to database
    db.saveToDatabase(workoutList);
  }

  // check of exercise
  void checkOffExercise(String workoutName, String exerciseName) {
    //find the relevant workout and relevant exercise in that workout..
    Exercise relevantExercise = getRelevantExercise(workoutName, exerciseName);

    // check off boolean to show user completed the exercise..
    relevantExercise.isCXompleted = !relevantExercise.isCXompleted;

    notifyListeners();
    // save to database
    db.saveToDatabase(workoutList);

    // load heat map
    loadHeatMap();
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

  // get start date
  String getStartDate() {
    return db.getStartDate();
  }

  /*
   HEAT MAP
  */

  Map<DateTime, int> heatMapDataSet = {};

  void loadHeatMap() {
    DateTime startDate = createDateTimeObject(getStartDate());

    // count the number of days to load
    int daysInBetween = DateTime.now().difference(startDate).inDays;

    // go from start date to today, and add each competion status to the dataset
    // "COMPETION_STATUS_yyyymmdd" will be the key in the database
    for (int i = 0; i < daysInBetween + 1; i++) {
      String yyyymmdd =
          convertDateTimeToYYYYMMDD(startDate.add(Duration(days: i)));

      // completion status = 0 or 1
      int completionStatus = db.getCompetionStatus(yyyymmdd);

      // year
      int year = startDate.add(Duration(days: i)).year;
      // month
      int month = startDate.add(Duration(days: i)).month;
      // day
      int day = startDate.add(Duration(days: i)).day;

      final percentForEachDay = <DateTime, int>{
        DateTime(year, month, day): completionStatus
      };

      // add to the heat map dataset
      heatMapDataSet.addEntries(percentForEachDay.entries);
    }
  }
}

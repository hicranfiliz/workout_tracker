import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/components/exercise_tile.dart';
import 'package:workout_tracker/data/workout_data.dart';

class WorkoutPage extends StatefulWidget {
  final String workoutName;
  const WorkoutPage({super.key, required this.workoutName});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
// checkbox was tapped:
  // we have to know which workout and exercise is.
  void onCheckBoxChanged(String workoutName, String exerciseName) {
    Provider.of<WorkoutData>(context, listen: false)
        .checkOffExercise(workoutName, exerciseName);
  }

  // text controllers:
  final exerciseNameController = TextEditingController();
  final weightController = TextEditingController();
  final repsController = TextEditingController();
  final setsController = TextEditingController();

  // create eercise:
  void createNewExercise() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Add a new exercise"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // exercise name
                  TextField(
                    controller: exerciseNameController,
                  ),
                  // weight
                  TextField(
                    controller: weightController,
                  ),
                  // reps
                  TextField(
                    controller: repsController,
                  ),
                  // sets
                  TextField(
                    controller: setsController,
                  ),
                ],
              ),
              actions: [
                // save button
                MaterialButton(
                  onPressed: save,
                  child: Text("Save"),
                ),

                // cancel button
                MaterialButton(
                  onPressed: cancel,
                  child: Text("Cancel"),
                )
              ],
            ));
  }

  // save exercise
  void save() {
    // get exercise name from text controller
    String newExerciseName = exerciseNameController.text;
    String newWeight = weightController.text;
    String newReps = repsController.text;
    String newSets = setsController.text;

    // add exercise to the exercisedata list
    Provider.of<WorkoutData>(context, listen: false).addExercise(
        widget.workoutName, newExerciseName, newWeight, newReps, newSets);

    // pop dialog box
    Navigator.pop(context);
    clear();
  }

  // cancel workout
  void cancel() {
    // pop dialog box
    Navigator.pop(context);
    clear();
  }

  // clear text field
  void clear() {
    exerciseNameController.clear();
    weightController.clear();
    repsController.clear();
    setsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
        builder: (context, value, child) => Scaffold(
              appBar: AppBar(
                title: Text(widget.workoutName),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: createNewExercise,
                child: const Icon(Icons.add),
              ),
              body: ListView.builder(
                  itemCount:
                      value.numberOfExercisesInWorkout(widget.workoutName),
                  itemBuilder: (context, index) => ExerciseTile(
                        exerciseName: value
                            .getRelevantWorkout(widget.workoutName)
                            .exercises[index]
                            .name,
                        weight: value
                            .getRelevantWorkout(widget.workoutName)
                            .exercises[index]
                            .weight,
                        reps: value
                            .getRelevantWorkout(widget.workoutName)
                            .exercises[index]
                            .reps,
                        sets: value
                            .getRelevantWorkout(widget.workoutName)
                            .exercises[index]
                            .sets,
                        isCompleted: value
                            .getRelevantWorkout(widget.workoutName)
                            .exercises[index]
                            .isCXompleted,
                        onCheckBoxChanged: (val) => onCheckBoxChanged(
                          widget.workoutName,
                          value
                              .getRelevantWorkout(widget.workoutName)
                              .exercises[index]
                              .name,
                        ),
                      )),
            ));
  }
}

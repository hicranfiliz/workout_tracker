import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/components/heat_map.dart';
import 'package:workout_tracker/data/workout_data.dart';
import 'package:workout_tracker/pages/workout_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    Provider.of<WorkoutData>(context, listen: false).initializeWorkoutList();
  }

  // text controller
  final newWorkoutNameController = TextEditingController();

  // create a new workout:
  void createNewWorkout() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Create New Workout"),
              content: TextField(
                controller: newWorkoutNameController,
              ),
              actions: [
                // save button
                MaterialButton(onPressed: save, child: const Text("Save")),
                MaterialButton(onPressed: cancel, child: const Text("Cancel")),
              ],
            ));
  }

  // go to workout page. First we have to know which workout we go
  void goToWorkoutPage(String workoutName) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WorkoutPage(
                  workoutName: workoutName,
                )));
  }

  // save workot
  void save() {
    // get workout name from text controller
    String newWorkoutName = newWorkoutNameController.text;
    // add workout to the workoutdata list
    Provider.of<WorkoutData>(context, listen: false).addWorkout(newWorkoutName);

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
    newWorkoutNameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
        builder: (context, value, child) => Scaffold(
            backgroundColor: Colors.grey[600],
            appBar: AppBar(
              title: const Text('Workout Tracker'),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: createNewWorkout,
              child: const Icon(Icons.add),
            ),
            body: ListView(
              children: [
                // HEAT MAP
                MyHeatMap(
                    datasets: value.heatMapDataSet,
                    startDateYYYYMMDD: value.getStartDate()),

                // WORKOUT LIST
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: value.getWorkoutList().length,
                    itemBuilder: (context, index) => ListTile(
                          title: Text(value.getWorkoutList()[index].name),
                          trailing: IconButton(
                            icon: Icon(Icons.arrow_forward_ios),
                            onPressed: () => goToWorkoutPage(
                                value.getWorkoutList()[index].name),
                          ),
                        )),
              ],
            )));
  }
}

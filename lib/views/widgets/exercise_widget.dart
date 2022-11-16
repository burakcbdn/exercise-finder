import 'package:exercises_assistant_app/controllers/globals.dart';
import 'package:exercises_assistant_app/models/exercise.model.dart';
import 'package:flutter/material.dart';

// Displays widget for found exercises
class ExerciseWidget extends StatefulWidget {
  const ExerciseWidget({
    Key? key,
    
    required this.currentExercise,
  }) : super(key: key);

  final ExerciseModel currentExercise;

  @override
  State<ExerciseWidget> createState() => _ExerciseWidgetState();
}

class _ExerciseWidgetState extends State<ExerciseWidget> {

  // shows or hides exercise instructions
  bool showInstructions = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey[200],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            // Exercise name
            Text(
              widget.currentExercise.name,
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 5),
            Container(
              height: 25,
              width: 200,
              decoration: BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  Globals.typeData[widget.currentExercise.type]!, // exercise type
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Expanded(child: Text(Globals.muscleData[widget.currentExercise.muscle]!)), // exercise muscle type
                TextButton(
                  onPressed: () {

                    // toggles showInstructions

                    setState(() {
                      showInstructions = !showInstructions;
                    });
                  },
                  child: const Text(
                    'See instructions',
                  ),
                ),
              ],
            ),

            // shows exercise instructions if showInstructions is true
            if (showInstructions)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(widget.currentExercise.instructions),
              )
          ],
        ),
      ),
    );
  }
}


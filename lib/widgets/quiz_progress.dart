import 'package:flutter/material.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';

class QuizProgress extends StatefulWidget {
  final int maxSteps;
  final int currentStep;
  const QuizProgress({
    super.key,
    required this.maxSteps,
    required this.currentStep,
  });

  @override
  State<QuizProgress> createState() => _QuizProgressState();
}

class _QuizProgressState extends State<QuizProgress> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Quiz Progress",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "${widget.currentStep + 1}/${widget.maxSteps}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            LinearProgressBar(
              animateProgress: true,
              animationDuration: Duration(milliseconds: 200),
              progressType: ProgressType.linear,
              progressColor: Colors.white,
              backgroundColor: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
              currentStep: widget.currentStep + 1,
              maxSteps: widget.maxSteps,
            ),
          ],
        ),
      ),
    );
  }
}

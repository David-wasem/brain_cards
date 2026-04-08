import 'package:brain_cards/models/quiz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';

class CustomCard extends StatefulWidget {
  final int indexOfQuiz;
  final List<Quiz> quizzes;
  final Function(bool) onCorrectAnswer;
  const CustomCard({
    super.key,
    required this.indexOfQuiz,
    required this.quizzes,
    required this.onCorrectAnswer,
  });

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  final FlipCardController _flipController = FlipCardController();
  final labels = ['A', 'B', 'C', 'D'];
  final labelColors = [
    Color(0xFF6366F1),
    Color(0xFF10B981),
    Color(0xFFF59E0B),
    Color(0xFFEF4444),
  ];
  bool _isCorrect = false;
  @override
  Widget build(BuildContext context) {
    return FlipCard(
      frontWidget: InkWell(
        child: Container(
          padding: const EdgeInsets.all(24),
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.quizzes[widget.indexOfQuiz].question,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E3A5F),
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              Divider(color: Color(0xFFE2E8F0), thickness: 1.5),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.quizzes[widget.indexOfQuiz].options.length,
                itemBuilder: (context, ind) {
                  // ind ==> index of option
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () {
                          if (ind ==
                              widget
                                  .quizzes[widget.indexOfQuiz]
                                  .correctAnswer) {
                            setState(() {
                              _isCorrect = true;
                            });
                            Future.delayed(const Duration(seconds: 2), () {
                              widget.onCorrectAnswer(true);
                            });
                          } else {
                            setState(() {
                              _isCorrect = false;
                            });
                          }
                          _flipController.flipcard();
                          Future.delayed(const Duration(seconds: 1), () {
                            _flipController.flipcard();
                          });
                        },
                        child: Ink(
                          decoration: BoxDecoration(
                            color: labelColors[ind % labelColors.length]
                                .withOpacity(0.07),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: labelColors[ind % labelColors.length]
                                  .withOpacity(0.3),
                              width: 1.5,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 34,
                                  height: 34,
                                  decoration: BoxDecoration(
                                    color:
                                        labelColors[ind % labelColors.length],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      labels[ind % labels.length],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Text(
                                    widget
                                        .quizzes[widget.indexOfQuiz]
                                        .options[ind],
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1E3A5F),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      backWidget: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _isCorrect
                ? Icon(
                    Icons.check_circle_rounded,
                    color: Colors.green,
                    size: 40,
                  )
                : Icon(Icons.close_rounded, color: Colors.red, size: 40),
            SizedBox(height: 10),
            Center(
              child: _isCorrect
                  ? Text(
                      widget.quizzes[widget.indexOfQuiz].options[widget
                          .quizzes[widget.indexOfQuiz]
                          .correctAnswer],
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2F4D77),
                      ),
                    )
                  : Text(
                      "Wrong Answer",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2F4D77),
                      ),
                    ),
            ),
          ],
        ),
      ),
      controller: _flipController,
      rotateSide: RotateSide.left,
    );
  }
}

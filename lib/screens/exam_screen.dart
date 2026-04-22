import 'package:flutter/material.dart';
import 'package:brain_cards/models/quiz_list.dart';
import 'package:brain_cards/widgets/custom_card.dart';
import 'package:brain_cards/widgets/leave.dart';
import 'package:brain_cards/models/quiz.dart';
import 'package:brain_cards/widgets/quiz_progress.dart';
import 'package:brain_cards/models/result_list.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ExamScreen extends StatefulWidget {
  final String category;
  const ExamScreen({super.key, required this.category});

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  int _currentIndex = 0;
  final Set<int> _correctAnswers = {};
  @override
  Widget build(BuildContext context) {
    List<Quiz> quizzes = quizList[widget.category]!;
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(color: Color(0xFF3B82F6)),
          ),
          // Quiz Progress
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: QuizProgress(
              maxSteps: quizzes.length,
              currentStep: _currentIndex,
            ),
          ),
          // Carousel Slider ==> Main Part of the Screen
          Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.65,
              child: CarouselSlider.builder(
                carouselController: _carouselController,
                itemCount: quizzes.length,
                itemBuilder: (context, index, realIndex) {
                  return CustomCard(
                    indexOfQuiz: index,
                    quizzes: quizzes,
                    onAnswer: onAnswer,
                  );
                },
                options: CarouselOptions(
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  scrollPhysics: NeverScrollableScrollPhysics(),
                  height: MediaQuery.of(context).size.height,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                  autoPlay: false,
                  scrollDirection: Axis.horizontal,
                ),
              ),
            ),
          ),
          // Navigation Buttons
          Positioned(
            bottom: 50,
            left: 60,
            right: 60,
            child: InkWell(
              onTap: () {
                (_currentIndex == quizzes.length - 1)
                    ? {
                        setState(() {
                          addResult(
                            category: widget.category,
                            correctAnswers: _correctAnswers.length,
                            totalAnswers: quizzes.length,
                          );
                        }),
                        showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.celebration_rounded,
                                  size: 60,
                                  color: Colors.green,
                                ),
                                SizedBox(height: 20),
                                Text(
                                  "Congratulations!",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "You have completed the quiz.\nAnd your result is ${_correctAnswers.length}/${quizzes.length}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  child: Text("Exit"),
                                ),
                              ],
                            ),
                          ),
                        ),
                      }
                    : null;
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                height: 56,
                decoration: BoxDecoration(
                  color: (_currentIndex == quizzes.length - 1)
                      ? Color(0xFF57CA5B)
                      : Color(0xFF979797),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: (_currentIndex == quizzes.length - 1)
                          ? Color(0xFF5ADB5E).withOpacity(0.45)
                          : Color(0xFF979797),
                      blurRadius: 16,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.done_all_rounded, color: Colors.white, size: 26),
                    SizedBox(width: 8),
                    Text(
                      "Finish",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Pop Scope ==> Leaving the Exam
          LeaveDialog(
            icon: Icons.exit_to_app_rounded,
            statment:
                "Are you sure you want to leave this quiz? Your progress will not be saved.",
            titleOfDialog: "Exit Quiz?",
            buttonText: "Exit",
            onExit: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void onAnswer(bool isCorrect, int quizIndex) {
    _carouselController.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
    if (isCorrect) {
      setState(() {
        _correctAnswers.add(quizIndex);
      });
    }
  }
}

import 'package:brain_cards/models/quiz_list.dart';
import 'package:brain_cards/widgets/custom_card.dart';
import 'package:brain_cards/widgets/leave.dart';
import 'package:brain_cards/models/quiz.dart';
import 'package:brain_cards/widgets/quiz_progress.dart';
import 'package:flutter/material.dart';
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
                  return CustomCard(indexOfQuiz: index, quizzes: quizzes);
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
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                (_currentIndex <= 0)
                    ? Container()
                    : InkWell(
                        onTap: () {
                          _carouselController.previousPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF3B82F6).withOpacity(0.45),
                                blurRadius: 16,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.arrow_back_rounded,
                                color: Color(0xFF1E3A5F),
                                size: 26,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Previous",
                                style: TextStyle(
                                  color: Color(0xFF1E3A5F),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                (_currentIndex >= quizzes.length - 1)
                    ? Container()
                    : InkWell(
                        onTap: () {
                          _carouselController.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF3B82F6).withOpacity(0.45),
                                blurRadius: 16,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.arrow_forward_rounded,
                                color: Color(0xFF1E3A5F),
                                size: 26,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Next",
                                style: TextStyle(
                                  color: Color(0xFF1E3A5F),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ],
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
}

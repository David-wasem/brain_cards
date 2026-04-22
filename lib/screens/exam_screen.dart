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
  bool _lastQuestionAnswered = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Quiz> quizzes = quizList[widget.category]!;
    return Scaffold(
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 800),
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        child: _isLoading
            ? _buildLoadingScreen()
            : Stack(
                key: ValueKey('exam'),
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
                        (_currentIndex == quizzes.length - 1 &&
                                _lastQuestionAnswered)
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
                                    backgroundColor: Colors.transparent,
                                    insetPadding: EdgeInsets.symmetric(
                                      horizontal: 24,
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.fromLTRB(
                                        24,
                                        32,
                                        24,
                                        24,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(28),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 20,
                                            offset: Offset(0, 10),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // Icon with gradient background
                                          Container(
                                            padding: EdgeInsets.all(20),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              gradient: LinearGradient(
                                                colors: [
                                                  Color(0xFF57CA5B),
                                                  Color(0xFF35A339),
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Color(
                                                    0xFF57CA5B,
                                                  ).withValues(alpha: 0.4),
                                                  blurRadius: 15,
                                                  offset: Offset(0, 8),
                                                ),
                                              ],
                                            ),
                                            child: Icon(
                                              Icons.emoji_events_rounded,
                                              size: 50,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(height: 24),
                                          Text(
                                            "Congratulations!",
                                            style: TextStyle(
                                              fontSize: 26,
                                              fontWeight: FontWeight.w800,
                                              color: Color(0xFF2F4D77),
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                          SizedBox(height: 12),
                                          Text(
                                            "You have successfully completed the quiz.",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.grey.shade600,
                                              height: 1.4,
                                            ),
                                          ),
                                          SizedBox(height: 24),
                                          // Score display
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 24,
                                              vertical: 16,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Color(0xFFF0F5FF),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              border: Border.all(
                                                color: Color(
                                                  0xFF3B82F6,
                                                ).withValues(alpha: 0.2),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.check_circle_rounded,
                                                  color: Color(0xFF3B82F6),
                                                  size: 24,
                                                ),
                                                SizedBox(width: 12),
                                                Text(
                                                  "Score: ",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xFF2F4D77),
                                                  ),
                                                ),
                                                Text(
                                                  "${_correctAnswers.length}/${quizzes.length}",
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w900,
                                                    color: Color(0xFF3B82F6),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 32),
                                          // Button
                                          SizedBox(
                                            width: double.infinity,
                                            height: 54,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Color(
                                                  0xFF3B82F6,
                                                ),
                                                foregroundColor: Colors.white,
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                                shadowColor: Color(
                                                  0xFF3B82F6,
                                                ).withValues(alpha: 0.5),
                                              ),
                                              child: Text(
                                                "Back to Home",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
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
                          color:
                              (_currentIndex == quizzes.length - 1 &&
                                  _lastQuestionAnswered)
                              ? Color(0xFF57CA5B)
                              : Color(0xFF979797),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  (_currentIndex == quizzes.length - 1 &&
                                      _lastQuestionAnswered)
                                  ? Color(0xFF5ADB5E).withValues(alpha: 0.45)
                                  : Color(0xFF979797),
                              blurRadius: 16,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.done_all_rounded,
                              color: Colors.white,
                              size: 26,
                            ),
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
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Container(
      key: ValueKey('loading'),
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF2F4D77)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.school_rounded, size: 80, color: Colors.white),
          ),
          SizedBox(height: 32),
          Text(
            "Preparing Exam",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 12),
          Text(
            widget.category,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          SizedBox(height: 48),
          SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 3,
            ),
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
    setState(() {
      if (isCorrect) {
        _correctAnswers.add(quizIndex);
      }
      if (quizIndex == quizList[widget.category]!.length - 1) {
        _lastQuestionAnswered = true;
      }
    });
  }
}

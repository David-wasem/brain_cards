import 'package:flutter/material.dart';
class Result {
  String category;
  int correctAnswers;
  int totalAnswers;
  Result({
    required this.category,
    required this.correctAnswers,
    required this.totalAnswers,
  });
  late double percantage = (correctAnswers / totalAnswers) * 100;
  
  Color get resultColor {
    if (percantage >= 90) {
      return Colors.green;
    } else if (percantage >= 70) {
      return Colors.yellow;
    } else if (percantage >= 50) {
      return Colors.orange;
    } else if (percantage >= 30) {
      return Colors.red;
    } else if (percantage >= 10) {
      return Colors.red;
    } else {
      return Colors.red;
    }
  }
}

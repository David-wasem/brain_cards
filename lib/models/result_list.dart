import 'package:brain_cards/models/result.dart';

void addResult({
  required String category,
  required int correctAnswers,
  required int totalAnswers,
}) {
  resultList.add(
    Result(
      category: category,
      correctAnswers: correctAnswers,
      totalAnswers: totalAnswers,
    ),
  );
}

List<Result> resultList = [];

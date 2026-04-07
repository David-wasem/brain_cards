import 'package:brain_cards/models/quiz.dart';

Map<String, List<Quiz>> quizList = {
  "Languages": [
    Quiz(
      question: "What is the capital of France?",
      options: ["Paris", "London", "Berlin", "Madrid"],
      correctAnswer: 0,
    ),
    Quiz(
      question: "Which language has the most native speakers in the world?",
      options: ["English", "Spanish", "Mandarin Chinese", "Hindi"],
      correctAnswer: 2,
    ),
    Quiz(
      question: "What is the official language of Brazil?",
      options: ["Spanish", "Portuguese", "French", "Italian"],
      correctAnswer: 1,
    ),
    Quiz(
      question: "Which language uses the Cyrillic alphabet?",
      options: ["Greek", "Arabic", "Russian", "Turkish"],
      correctAnswer: 2,
    ),
    Quiz(
      question: "How do you say 'Hello' in Japanese?",
      options: ["Annyeong", "Konnichiwa", "Ni Hao", "Salaam"],
      correctAnswer: 1,
    ),
  ],

  "Science": [
    Quiz(
      question: "What is the chemical symbol for water?",
      options: ["WO", "H2O", "CO2", "O2"],
      correctAnswer: 1,
    ),
    Quiz(
      question: "How many planets are in our solar system?",
      options: ["7", "8", "9", "10"],
      correctAnswer: 1,
    ),
    Quiz(
      question: "What gas do plants absorb during photosynthesis?",
      options: ["Oxygen", "Nitrogen", "Carbon Dioxide", "Hydrogen"],
      correctAnswer: 2,
    ),
    Quiz(
      question: "What is the powerhouse of the cell?",
      options: ["Nucleus", "Ribosome", "Mitochondria", "Vacuole"],
      correctAnswer: 2,
    ),
    Quiz(
      question: "What is the speed of light (approx.) in km/s?",
      options: ["150,000", "200,000", "300,000", "400,000"],
      correctAnswer: 2,
    ),
  ],

  "Math": [
    Quiz(
      question: "What is the value of π (Pi) to two decimal places?",
      options: ["3.12", "3.14", "3.16", "3.18"],
      correctAnswer: 1,
    ),
    Quiz(
      question: "What is the square root of 144?",
      options: ["10", "11", "12", "13"],
      correctAnswer: 2,
    ),
    Quiz(
      question: "What is 15% of 200?",
      options: ["25", "30", "35", "40"],
      correctAnswer: 1,
    ),
    Quiz(
      question: "What is the result of 2 raised to the power of 10?",
      options: ["512", "1024", "2048", "256"],
      correctAnswer: 1,
    ),
    Quiz(
      question: "What is the sum of angles in a triangle?",
      options: ["90°", "180°", "270°", "360°"],
      correctAnswer: 1,
    ),
  ],

  "History": [
    Quiz(
      question: "In which year did World War II end?",
      options: ["1943", "1944", "1945", "1946"],
      correctAnswer: 2,
    ),
    Quiz(
      question: "Who was the first President of the United States?",
      options: [
        "Abraham Lincoln",
        "Thomas Jefferson",
        "George Washington",
        "John Adams",
      ],
      correctAnswer: 2,
    ),
    Quiz(
      question: "Which ancient wonder was located in Egypt?",
      options: [
        "Colosseum",
        "Great Pyramid of Giza",
        "Parthenon",
        "Stonehenge",
      ],
      correctAnswer: 1,
    ),
    Quiz(
      question: "In which year did man first land on the Moon?",
      options: ["1965", "1967", "1969", "1971"],
      correctAnswer: 2,
    ),
    Quiz(
      question: "Which empire was ruled by Julius Caesar?",
      options: ["Greek", "Ottoman", "Roman", "Persian"],
      correctAnswer: 2,
    ),
  ],

  "Geography": [
    Quiz(
      question: "What is the largest continent by area?",
      options: ["Africa", "Europe", "Asia", "North America"],
      correctAnswer: 2,
    ),
    Quiz(
      question: "Which river is the longest in the world?",
      options: ["Amazon", "Nile", "Yangtze", "Mississippi"],
      correctAnswer: 1,
    ),
    Quiz(
      question: "What is the smallest country in the world?",
      options: ["Monaco", "San Marino", "Vatican City", "Liechtenstein"],
      correctAnswer: 2,
    ),
    Quiz(
      question: "On which continent is the Sahara Desert located?",
      options: ["Asia", "Australia", "South America", "Africa"],
      correctAnswer: 3,
    ),
    Quiz(
      question: "What is the capital city of Australia?",
      options: ["Sydney", "Melbourne", "Canberra", "Brisbane"],
      correctAnswer: 2,
    ),
  ],

  "Computer Science": [
    Quiz(
      question: "What does CPU stand for?",
      options: [
        "Central Process Unit",
        "Central Processing Unit",
        "Computer Personal Unit",
        "Core Processing Unit",
      ],
      correctAnswer: 1,
    ),
    Quiz(
      question: "Which data structure uses LIFO order?",
      options: ["Queue", "Stack", "Linked List", "Tree"],
      correctAnswer: 1,
    ),
    Quiz(
      question: "What is the base of the binary number system?",
      options: ["8", "10", "2", "16"],
      correctAnswer: 2,
    ),
    Quiz(
      question:
          "Which sorting algorithm has O(n log n) average time complexity?",
      options: [
        "Bubble Sort",
        "Selection Sort",
        "Merge Sort",
        "Insertion Sort",
      ],
      correctAnswer: 2,
    ),
    Quiz(
      question: "What does HTML stand for?",
      options: [
        "Hyper Text Markup Language",
        "High Text Machine Language",
        "Hyper Transfer Markup Language",
        "Hyper Text Modern Language",
      ],
      correctAnswer: 0,
    ),
  ],

  "Sports": [
    Quiz(
      question: "How many players are on a standard football (soccer) team?",
      options: ["9", "10", "11", "12"],
      correctAnswer: 2,
    ),
    Quiz(
      question: "In which sport is the term 'slam dunk' used?",
      options: ["Volleyball", "Basketball", "Tennis", "Baseball"],
      correctAnswer: 1,
    ),
    Quiz(
      question: "How many rings are on the Olympic flag?",
      options: ["4", "5", "6", "7"],
      correctAnswer: 1,
    ),
    Quiz(
      question: "Which country has won the most FIFA World Cup titles?",
      options: ["Germany", "Argentina", "Italy", "Brazil"],
      correctAnswer: 3,
    ),
    Quiz(
      question: "How many sets are in a standard tennis match (best of)?",
      options: ["3", "5", "7", "4"],
      correctAnswer: 1,
    ),
  ],
};

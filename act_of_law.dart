import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui'; // Import for the filter
import 'package:shared_preferences/shared_preferences.dart'; // Import for shared_preferences
import 'dart:math';

void main() {
  runApp(MultipleChoiceGame());
}

class MultipleChoiceGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Multiple Choice Game',
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int _questionIndex = 0;
  int _score = 0;
  bool _showAnswer = false;
  bool _isCorrect = false;
  int _remainingTime = 15;
  Timer? _timer;

  final List<Question> _questions = [
    Question('What conduct would constitute a violation within the university community?', ['Damaging university property alone.', 'Violence towards community members off-campus.', 'Vandalizing property in the presence of others.', 'Accidental damage during a sanctioned event off-campus.'], 2),
    Question('What action would be considered a violation of conduct within the university community?', ['Threatening a professor during a lecture.', 'Hitting a fellow student in a privately rented hostel.', 'Offering violence to a community member outside the campus.', 'Using force against a student in a neighboring park'], 1),
    Question('What is considered cheating in exams?', ['Sharing answers.', 'Talking during the exam.', 'Using scratch paper.', 'Checking the time.'], 0),
    Question('Which action violates exam rules?', ['Asking for extra time', 'Drinking water.', 'Reviewing notes.', 'Using a phone.'], 3),
    Question('What is against the student bylaw?', ['Helping a friend.', 'Sharing exam content.', 'Asking for clarification.', 'Using an approved calculator.'], 1),
    Question('What is considered cheating?', ['Requesting a bathroom break.', 'Using a permitted calculator.', 'Copying from another student', 'Writing on the exam paper.'], 2),
    Question('Which action is a breach of exam regulations?', ['Raising hand for assistance.', 'Discussing answers post-exam.', 'Using provided formula sheets.', 'Reporting suspicious behavior.'], 1),
    Question('Which clothing item is not permitted by the dress code?', ['Tank tops with wide straps.', 'Knee-length skirts', 'Sneakers.', 'Knee-length skirts.'], 0),
    Question('Which accessory is against the dress code?', ['Sporting a wristwatch.', 'Wearing stud earrings.', 'Wearing a nose ring.', 'Carrying a wallet.'], 2),
    Question('What behavior is not allowed concerning sexual content according to university laws?', ['Discussing a thesis on human sexuality.', 'Sharing educational videos on sexual health.', 'Engaging in sexual activity in public areas on campus.', 'Organizing a panel discussion on sex education.'], 2),
  ];

  @override
  void initState() {
    super.initState();
    _loadGameState();
    _shuffleQuestions();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _remainingTime = 15;
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        _showAnswer = true;
        _timer?.cancel();
        _nextQuestion();
      }
    });
  }

  void _answerQuestion(int answerIndex) {
    setState(() {
      _showAnswer = true;
      _isCorrect = answerIndex == _questions[_questionIndex].correctAnswerIndex;
      if (_isCorrect) {
        _score++;
      }
      _timer?.cancel();
      _saveGameState();
    });
  }

  void _nextQuestion() {
    setState(() {
      _questionIndex++;
      _showAnswer = false;
      _saveGameState();
      _startTimer();
    });
  }

  void _shuffleQuestions() {
    _questions.shuffle();
  }

  Future<void> _saveGameState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('questionIndex', _questionIndex);
    await prefs.setInt('score', _score);
  }

  Future<void> _loadGameState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _questionIndex = prefs.getInt('questionIndex') ?? 0;
      _score = prefs.getInt('score') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Multiple Choice Game'),
      ),
      body: Container(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/2.jpg',
              fit: BoxFit.cover,
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                color: Colors.black.withOpacity(0),
              ),
            ),
            _questionIndex < _questions.length
                ? _showAnswer
                ? AnswerFeedback(
              isCorrect: _isCorrect,
              correctAnswer: _questions[_questionIndex].choices[_questions[_questionIndex].correctAnswerIndex],
              nextQuestion: _nextQuestion,
            )
                : Quiz(
              question: _questions[_questionIndex],
              answerQuestion: _answerQuestion,
              remainingTime: _remainingTime,
            )
                : Result(_score, _questions.length),
          ],
        ),
      ),
    );
  }
}

class Question {
  final String questionText;
  final List<String> choices;
  final int correctAnswerIndex;

  Question(this.questionText, this.choices, this.correctAnswerIndex);
}

class Quiz extends StatelessWidget {
  final Question question;
  final Function(int) answerQuestion;
  final int remainingTime;

  Quiz({required this.question, required this.answerQuestion, required this.remainingTime});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            question.questionText,
            style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            'Time remaining: $remainingTime seconds',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          SizedBox(height: 20),
          ...(question.choices.asMap().entries.map((entry) {
            int idx = entry.key;
            String choice = entry.value;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: SizedBox(
                width: double.infinity, // Full width of the container
                height: 60, // Fixed height
                child: ElevatedButton(
                  onPressed: () => answerQuestion(idx),
                  child: Text(choice, style: TextStyle(fontSize: 18)),
                ),
              ),
            );
          })).toList(),
        ],
      ),
    );
  }
}

class AnswerFeedback extends StatelessWidget {
  final bool isCorrect;
  final String correctAnswer;
  final VoidCallback nextQuestion;

  AnswerFeedback({
    required this.isCorrect,
    required this.correctAnswer,
    required this.nextQuestion,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isCorrect ? 'Correct!' : 'Wrong!',
            style: TextStyle(fontSize: 32, color: isCorrect ? Colors.green : Colors.red),
          ),
          SizedBox(height: 20),
          Text(
            'The correct answer is: $correctAnswer',
            style: TextStyle(fontSize: 24, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          SizedBox(
            width: 200,
            height: 60,
            child: ElevatedButton(
              onPressed: nextQuestion,
              child: Text('Next Question', style: TextStyle(fontSize: 20)),
            ),
          ),
        ],
      ),
    );
  }
}

class Result extends StatelessWidget {
  final int score;
  final int totalQuestions;

  Result(this.score, this.totalQuestions);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Your final score is $score out of $totalQuestions.',
        style: TextStyle(fontSize: 24, color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }
}

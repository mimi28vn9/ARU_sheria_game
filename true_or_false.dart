import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math'; //for shuffling the questions

void main() {
  runApp(FlutterQuizApp());
}

class FlutterQuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'True or False Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: QuizPage(),
      routes: {
        '/listOfGames': (context) => ListOfGames(), // Define the route for ListOfGames
      },
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  static const maxSeconds = 15; // Set the maximum seconds for the timer
  int _currentSeconds = maxSeconds;
  Timer? _timer;
  bool? _isCorrectAnswer;
  String _answerFeedback = '';

  List<Question> _questions = [
    Question('Does the university conduct policy only apply to student actions causing harm or damage on campus or in university-rented hostels?', true),
    Question('A student cannot be charged with a criminal offense that is not a misdemeanor under the law.', false),
    Question('Unauthorized possession of a key to University property is considered a violation of the conduct policy.', true),
    Question('Forgery with the intent to cause loss to any person, University, or institution, whether in cash or otherwise, is considered a violation of the conduct policy.', true),
    Question('Is disobeying lawful orders under University regulations not a violation of the conduct policy?', false),
    Question('Is disobeying rulings or penalties from University authorities not a violation of the conduct policy?', false),
    Question('Entering with smartphone in examination room is it a violation of laws', true),
    Question('Is spreading lies about someone\'s sex life to damage their character allowed under the University\'s conduct policy?', true),
    Question('Are sexual jokes, innuendoes, lewd suggestions, foul language, and obscene gestures allowed under the University\'s conduct policy?', false),
    Question('is cheating in examination is violation of laws', true),
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
    _shuffleQuestions(); // Shuffle questions at the start
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_currentSeconds > 0) {
          _currentSeconds--;
        } else {
          _timer?.cancel();
          _moveToNextQuestion();
        }
      });
    });
  }

  void _shuffleQuestions() {
    _questions.shuffle(Random());
  }

  void _moveToNextQuestion() {
    setState(() {
      _isCorrectAnswer = null;
      _answerFeedback = '';
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
        _currentSeconds = maxSeconds;
        _startTimer();
      } else {
        _showScore();
      }
    });
  }

  void _checkAnswer(bool userAnswer) {
    final correctAnswer = _questions[_currentQuestionIndex].answer;
    if (userAnswer == correctAnswer) {
      _score++;
      _isCorrectAnswer = true;
      _answerFeedback = 'Correct!';
    } else {
      _isCorrectAnswer = false;
      _answerFeedback = 'Wrong! The correct answer is ${correctAnswer ? "True" : "False"}.';
    }
    Future.delayed(Duration(seconds: 2), _moveToNextQuestion); // Delay for 2 seconds to show the correct answer
  }

  void _resetQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _score = 0;
      _currentSeconds = maxSeconds;
      _isCorrectAnswer = null;
      _answerFeedback = '';
      _shuffleQuestions(); // Shuffle questions again
      _startTimer();
    });
  }

  void _showScore() {
    _timer?.cancel();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Quiz Completed!'),
        content: Text('Your Score: $_score/${_questions.length}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetQuiz();
            },
            child: Text('Restart Quiz'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/listOfGames'); // Navigate to the ListOfGames page
            },
            child: Text('Back to Menu'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('True or False Game'),
      ),
      body: Stack(
        children: [
          // Background Image
          Image.asset(
            'assets/2.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // Quiz Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _currentQuestionIndex < _questions.length
                ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Question ${_currentQuestionIndex + 1}/${_questions.length}',
                  style: TextStyle(fontSize: 24, color: Colors.redAccent),
                ),
                SizedBox(height: 20),
                Text(
                  _questions[_currentQuestionIndex].questionText,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold, // Make text bold here
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Text(
                  'Time left: $_currentSeconds seconds',
                  style: TextStyle(fontSize: 22, color: Colors.red),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => _checkAnswer(true),
                      child: Text('True'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: _isCorrectAnswer == true ? Colors.green : null, textStyle: TextStyle(fontSize: 24), disabledForegroundColor: Colors.grey.withOpacity(0.38), disabledBackgroundColor: Colors.grey.withOpacity(0.12),
                        minimumSize: Size(150, 60),
                        shadowColor: Colors.black,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(
                          color: _isCorrectAnswer == true ? Colors.green : Colors.blue,
                          width: 2,
                        ),
                      ).copyWith(
                        backgroundColor: _isCorrectAnswer == true
                            ? MaterialStateProperty.all(Colors.green)
                            : MaterialStateProperty.all(Colors.red),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _checkAnswer(false),
                      child: Text('False'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: _isCorrectAnswer == false ? Colors.green : null, textStyle: TextStyle(fontSize: 24), disabledForegroundColor: Colors.grey.withOpacity(0.38), disabledBackgroundColor: Colors.grey.withOpacity(0.12),
                        minimumSize: Size(150, 60),
                        shadowColor: Colors.black,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(
                          color: _isCorrectAnswer == false ? Colors.green : Colors.blue,
                          width: 2,
                        ),
                      ).copyWith(
                        backgroundColor: _isCorrectAnswer == false
                            ? MaterialStateProperty.all(Colors.green)
                            : MaterialStateProperty.all(Colors.red),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  _answerFeedback,
                  style: TextStyle(fontSize: 22, color: _isCorrectAnswer == true ? Colors.green : Colors.red),
                ),
              ],
            )
                : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Quiz Completed!',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 20),
                Text(
                  'Your Score: $_score/${_questions.length}',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _resetQuiz,
                  child: Text('Restart Quiz'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/listOfGames'); // Navigate to the ListOfGames page
                  },
                  child: Text('Back to Menu'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Question {
  final String questionText;
  final bool answer;

  Question(this.questionText, this.answer);
}

class ListOfGames extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List of Games'),
      ),
      body: Center(
        child: Text('This is the List of Games page'),
      ),
    );
  }
}

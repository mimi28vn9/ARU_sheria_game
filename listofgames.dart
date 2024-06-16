import 'package:flutter/material.dart';
import 'true_or_false.dart';
import 'act_of_law.dart';

class ListOfGames extends StatefulWidget {
  @override
  _ListOfGamesState createState() => _ListOfGamesState();
}

class _ListOfGamesState extends State<ListOfGames> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    // Delay the animation for 500 milliseconds after the widget is built
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _isVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('List of Games'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop(); // Navigate back to the previous screen
            },
          ),
        ),
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/2.jpg'), // Add the path to your background image
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedOpacity(
                    opacity: _isVisible ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 500),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MultipleChoiceGame()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Colors.purple.withOpacity(0.2), // Text color
                        shadowColor: Colors.purpleAccent, // Shadow color
                        elevation: 10, // Elevation to give 3D effect
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30), // Rounded edges
                          side: BorderSide(color: Colors.purple, width: 2), // Border color and width
                        ),
                        minimumSize: const Size(300, 60), // Set minimum size of the button
                        textStyle: const TextStyle(
                          fontSize: 20, // Adjust font size
                          fontWeight: FontWeight.bold, // Bold text
                        ),
                      ),
                      child: const Text('MULTIPLE CHOICES'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  AnimatedOpacity(
                    opacity: _isVisible ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 500),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FlutterQuizApp()), // Navigate to the TrueOrFalse game
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Colors.blue.withOpacity(0.2), // Text color
                        shadowColor: Colors.blueAccent, // Shadow color
                        elevation: 10, // Elevation to give 3D effect
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30), // Rounded edges
                          side: BorderSide(color: Colors.blue, width: 2), // Border color and width
                        ),
                        minimumSize: const Size(300, 60), // Set minimum size of the button
                        textStyle: const TextStyle(
                          fontSize: 20, // Adjust font size
                          fontWeight: FontWeight.bold, // Bold text
                        ),
                      ),
                      child: const Text('TRUE OR FALSE'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  AnimatedOpacity(
                    opacity: _isVisible ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 500),
                    child: ElevatedButton(
                      onPressed: () {
                        // Add onPressed logic for "NAME THAT THING" button
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Colors.green.withOpacity(0.2), // Text color
                        shadowColor: Colors.greenAccent, // Shadow color
                        elevation: 10, // Elevation to give 3D effect
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30), // Rounded edges
                          side: BorderSide(color: Colors.green, width: 2), // Border color and width
                        ),
                        minimumSize: const Size(300, 60), // Set minimum size of the button
                        textStyle: const TextStyle(
                          fontSize: 20, // Adjust font size
                          fontWeight: FontWeight.bold, // Bold text
                        ),
                      ),
                      child: const Text('NAME THAT THING'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

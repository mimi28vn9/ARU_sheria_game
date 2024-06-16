import 'package:flutter/material.dart';
import 'listofgames.dart';

class LevelsPage extends StatefulWidget {
  @override
  _LevelsPageState createState() => _LevelsPageState();
}

class _LevelsPageState extends State<LevelsPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  bool _isEasyHovered = false;
  bool _isMediumHovered = false;
  bool _isHardHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Levels'),
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
                image: AssetImage('assets/2.jpg'), // Provide the path to your background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildButton(
                  'EASY',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ListOfGames()), // Navigate to the ListOfGames page
                    );
                  },
                  isHovered: _isEasyHovered,
                  onEnter: () {
                    setState(() {
                      _isEasyHovered = true;
                    });
                  },
                  onExit: () {
                    setState(() {
                      _isEasyHovered = false;
                    });
                  },
                  borderColor: Colors.green,
                ),
                const SizedBox(height: 20),
                _buildButton(
                  'MEDIUM',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ListOfGames()), // Navigate to the ListOfGames page
                    );
                  },
                  isHovered: _isMediumHovered,
                  onEnter: () {
                    setState(() {
                      _isMediumHovered = true;
                    });
                  },
                  onExit: () {
                    setState(() {
                      _isMediumHovered = false;
                    });
                  },
                  borderColor: Colors.orange,
                ),
                const SizedBox(height: 20),
                _buildButton(
                  'HARD',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ListOfGames()), // Navigate to the ListOfGames page
                    );
                  },
                  isHovered: _isHardHovered,
                  onEnter: () {
                    setState(() {
                      _isHardHovered = true;
                    });
                  },
                  onExit: () {
                    setState(() {
                      _isHardHovered = false;
                    });
                  },
                  borderColor: Colors.red,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
      String text, {
        required VoidCallback onPressed,
        required bool isHovered,
        required VoidCallback onEnter,
        required VoidCallback onExit,
        required Color borderColor,
      }) {
    return MouseRegion(
      onEnter: (_) => onEnter(),
      onExit: (_) => onExit(),
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 200),
        opacity: isHovered ? 0.8 : 1.0,
        child: ElevatedButton(
          onPressed: onPressed,
          child: Text(text),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: borderColor.withOpacity(0.2), // Text color
            shadowColor: borderColor.withOpacity(0.5), // Shadow color
            elevation: 10, // Elevation to give 3D effect
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30), // Rounded edges
              side: BorderSide(color: borderColor, width: 2), // Border color and width
            ),
            minimumSize: Size(200, 60), // Set minimum size of the button
            textStyle: TextStyle(
              fontSize: 24, // Adjust font size
              fontWeight: FontWeight.bold, // Bold text
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

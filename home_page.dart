import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';
import 'levels.dart';
import 'sign_up.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey, // Set the default scaffold background color to grey
        appBarTheme: AppBarTheme(
          color: Colors.blue,
        ),
        drawerTheme: DrawerThemeData(
          backgroundColor: Colors.white,
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black, // Set the dark theme scaffold background color to black
      ),
      themeMode: themeNotifier.currentTheme,
      home: HomePage(),
      routes: {
        '/levels': (context) => LevelsPage(), // Define the route
      },
    );
  }
}

class ThemeNotifier extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeMode get currentTheme => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ARU SHERIA GAME',
          style: TextStyle(
            fontSize: 28, // Adjusted font size
            fontWeight: FontWeight.bold, // Bold text
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28, // Adjusted font size
                  fontWeight: FontWeight.bold, // Bold text
                ),
              ),
            ),
            ListTile(
              title: Text('Levels'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.pushNamed(context, '/levels');
              },
            ),
            ListTile(
              title: Text('Registration'), // Changed "Sign Up" to "Registration"
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterForm()),
                );
              },
            ),
            ListTile(
              title: Text('Toggle Dark Mode'),
              leading: Icon(Icons.lightbulb_outline), // Icon for toggling dark mode
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Provider.of<ThemeNotifier>(context, listen: false).toggleTheme();
              },
            ),
          ],
        ),
      ),
      body: BackgroundImage(),
    );
  }
}

class BackgroundImage extends StatefulWidget {
  @override
  _BackgroundImageState createState() => _BackgroundImageState();
}

class _BackgroundImageState extends State<BackgroundImage> with SingleTickerProviderStateMixin {
  Color _textColor = Colors.white;
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: 1.0, end: -1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/2.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MouseRegion(
                  onEnter: (_) => setState(() {
                    _textColor = Colors.indigo;
                  }),
                  onExit: (_) => setState(() {
                    _textColor = Colors.black;
                  }),
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return FractionalTranslation(
                        translation: Offset(_animation.value, 0),
                        child: child,
                      );
                    },
                    child: Text(
                      'ARU Sheria Game Mobile App',
                      style: TextStyle(
                        color: _textColor,
                        fontSize: 28, // Adjusted font size
                        fontWeight: FontWeight.bold, // Bold text
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16), // Space between the title and the container
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        style: TextStyle(
                          fontSize: 18, // Adjusted font size
                          fontWeight: FontWeight.bold, // Bold text
                        ),
                        decoration: InputDecoration(
                          hintText: 'Registration no:',
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        style: TextStyle(
                          fontSize: 18, // Adjusted font size
                          fontWeight: FontWeight.bold, // Bold text
                        ),
                        decoration: InputDecoration(
                          hintText: 'Password',
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 16),
                      _buildButton(
                        text: 'Login',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LevelsPage()),
                          ); // Navigate to LevelsPage
                        },
                        color: Colors.green,
                      ),
                      const SizedBox(height: 10),
                      _buildButton(
                        text: 'Registration', // Changed "Sign Up" to "Registration"
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RegisterForm()),
                          );
                        },
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButton({
    required String text,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 20, // Adjusted font size
          fontWeight: FontWeight.bold, // Bold text
        ),
      ),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: color.withOpacity(0.2), // Text color
        shadowColor: color.withOpacity(0.5), // Shadow color
        elevation: 10, // Elevation to give 3D effect
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Rounded corners
          side: BorderSide(color: color, width: 2), // Border color and width
        ),
        minimumSize: Size(150, 50), // Set custom size
        textStyle: TextStyle(
          fontSize: 20, // Adjust font size
          fontWeight: FontWeight.bold, // Bold text
        ),
      ),
    );
  }
}

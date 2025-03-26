import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Firebase initialization
import 'package:fitness_tracker/screens/main_page.dart'; // Main workout screen
import 'package:fitness_tracker/screens/responsive_demo_page.dart'; // ✅ Responsive demo screen
import 'package:fitness_tracker/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Log full errors for better debugging
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
  };

  // Initialize Firebase and notifications
  await Firebase.initializeApp();
  await NotificationService.initialize();

  runApp(const FitnessTrackerApp());
}

/// Root of the app
class FitnessTrackerApp extends StatelessWidget {
  const FitnessTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fitness Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/main': (context) => const MainPage(),
        '/responsive': (context) => const ResponsiveDemoPage(), // ✅ Add route
      },
    );
  }
}

/// Home Page of the App
/// Contains App Logo, Welcome Message, and buttons to enter app or view responsive demo
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo
            Image.asset('assets/images/fitness_logo.png', width: 150),
            const SizedBox(height: 20),

            // App name
            const Text(
              'Fitness Tracker',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Welcome message
            const Text(
              'Track your workouts and stay fit!',
              style: TextStyle(fontSize: 18, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // Enter app button
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/main');
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Enter'),
            ),

            const SizedBox(height: 16),

            // Responsive Demo button
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/responsive');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text('Responsive Demo'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Firebase Initialisation
import 'package:fitness_tracker/screens/main_page.dart';
import 'package:fitness_tracker/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
  };

  await Firebase.initializeApp();
  await NotificationService.initialize();

  runApp(const FitnessTrackerApp());
}


//Root of the app
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
      },
    );
  }
}

//Home Page of the App, contains App Logo, Welcome Message and an Enter button, which takes you to the workouts page
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
            Image.asset('assets/images/fitness_logo.png', width: 150),
            const SizedBox(height: 20),
            const Text(
              'Fitness Tracker', //App Name
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Track your workouts and stay fit!', // Welcome Message
              style: TextStyle(fontSize: 18, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/main');
              },
              style: ElevatedButton.styleFrom( // Code for the Enter button which take the use to the main page
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Enter'),
            ),
          ],
        ),
      ),
    );
  }
}

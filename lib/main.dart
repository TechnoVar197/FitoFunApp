import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:diet/ui/auth/auth_gate.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

// Entry point of the app
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter binding is initialized
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // Initialize Firebase
  FirebaseAppCheck.instance.activate();
  runApp(const MyApp()); // Launch the app
}

// Primary widget tree of the app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FIT O FUN',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AuthGate(),
    );
  }
}

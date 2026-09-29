import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  // Ensure Flutter bindings are initialized before calling Firebase
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const FlowApp());
}

class FlowApp extends StatelessWidget {
  const FlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flow Expense Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF1F3D32), // Deep Green
        scaffoldBackgroundColor: const Color(0xFFF7F8F5), // Warm Off-White
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1F3D32),
          primary: const Color(0xFF1F3D32),
          secondary: const Color(0xFF5F806F), // Muted Green
        ),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Text(
            'Firebase Connected!',
            style: TextStyle(
              fontSize: 24, 
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F3D32),
            ),
          ),
        ),
      ),
    );
  }
}
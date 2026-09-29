import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/expense_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserAuthProvider()),
        ChangeNotifierProxyProvider<UserAuthProvider, ExpenseProvider>(
          create: (_) => ExpenseProvider(),
          update: (_, authProvider, expenseProvider) {
            return expenseProvider!..updateUser(authProvider.user?.uid);
          },
        ),
      ],
      child: const FlowApp(),
    ),
  );
}

class FlowApp extends StatelessWidget {
  const FlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flow — Personal Expense Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Automatically adapts to user's device setting
      home: const AuthWrapper(),
    );
  }
}

// Routes user to Dashboard if logged in, or Login screen if not
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<UserAuthProvider>(context);

    if (authProvider.isAuthenticated) {
      return const Scaffold(
        body: Center(child: Text('Home Dashboard (Coming Next)')),
      );
    } else {
      return const Scaffold(
        body: Center(child: Text('Login Screen (Coming Next)')),
      );
    }
  }
}
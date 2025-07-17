import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pocket_growth/firebase_options.dart';
import 'package:pocket_growth/screens/admin/admin_dashboard.dart';
import 'package:pocket_growth/screens/auth/login_screen.dart';
import 'package:pocket_growth/screens/auth/register_screen.dart';
import 'package:pocket_growth/screens/user/dashboard_screen.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'services/auth_service.dart';
import 'services/savings_service.dart';
import 'services/loan_service.dart';
import 'services/mobile_money_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => SavingsService()),
        ChangeNotifierProvider(create: (_) => LoanService()),
        ChangeNotifierProvider(create: (_) => MobileMoneyService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Savings & Loan App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const AuthWrapper(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/admin': (context) => const AdminDashboard(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);

    if (auth.isAuthenticated) {
      return auth.isAdmin ? const AdminDashboard() : const DashboardScreen();
    } else {
      return const HomeScreen();
    }
  }
}

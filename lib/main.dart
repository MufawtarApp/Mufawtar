import 'package:flutter/material.dart';
import 'package:mufawtar/auth.dart';
import 'package:mufawtar/screens/home_screen.dart';
import 'package:mufawtar/screens/list_invoices_screen.dart';
import 'package:mufawtar/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mufawtar/screens/signup_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(),
        //home: const Auth(), //LoginScreen()
        routes: {
          '/': (context) => const Auth(),
          'homeScreen': (context) => const HomeScreen(),
          'signupScreen': (context) => const SignupScrenn(),
          'loginScreen': (context) => const LoginScreen(),
          'listInvoicesScreen': (context) => const ListScreen(),
        });
  }
}

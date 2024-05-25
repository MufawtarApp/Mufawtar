import 'package:flutter/material.dart';
import 'package:mufawtar/auth.dart';
import 'package:mufawtar/screens/home_screen.dart';
import 'package:mufawtar/screens/list_invoices_screen.dart';
import 'package:mufawtar/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mufawtar/screens/signup_screen.dart';
import 'package:mufawtar/screens/description_Screen1.dart';
import 'firebase_options.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:mufawtar/screens/charts_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AwesomeNotifications().initialize(null, [
    NotificationChannel(
        channelKey: 'scheduled',
        channelName: 'scheduledchannel',
        channelDescription: 'notifications for test',
        playSound: true,
        channelShowBadge: true,
        onlyAlertOnce: true,
        importance: NotificationImportance.Max,
        defaultColor: const Color(0xFF9D50DD),
        criticalAlerts: true)
  ]);
  bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowed) {
    AwesomeNotifications().requestPermissionToSendNotifications();
  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  tz.initializeTimeZones;

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
          'descriptionScreen': (context) => const DescriptionScreen(),
          'chartsScreen' : (context) => const SummaryScreen(),
          
        });
  }
}

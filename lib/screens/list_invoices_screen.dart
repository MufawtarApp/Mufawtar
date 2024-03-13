import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final user =
      FirebaseAuth.instance.currentUser!; // this will save all actions user did
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'YOU ARE IN LIST INVOICES SCREEN',
              style: TextStyle(fontSize: 22),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('homeScreen');
              },
              color: Colors.purple,
              child: Text('Home Screan'),
            ),
          ],
        ),
      ),
    );
  }
}

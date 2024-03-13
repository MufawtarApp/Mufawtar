import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  XFile? _image; // Change the type to XFile?

  Future<void> getImage(bool isCamera) async {
    ImagePicker _picker = ImagePicker();
    XFile? image;

    if (isCamera) {
      image = await _picker.pickImage(source: ImageSource.camera);
    } else {
      image = await _picker.pickImage(source: ImageSource.gallery);
    }

    setState(() {
      _image = image; // Assign the XFile to _image
    });
  }

  final user =
      FirebaseAuth.instance.currentUser!; // this will save all actions user did
  @override
  Widget build(BuildContext context) {
    int numIndex = 0;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mufawtar'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                getImage(true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                minimumSize: const Size.fromHeight(
                    200), // Increased height to accommodate the icon and text
                elevation: 0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize
                    .min, // Use min to make the column's height just enough for its children
                mainAxisAlignment: MainAxisAlignment
                    .center, // Center the icon and text vertically
                children: <Widget>[
                  Image.asset("images/document.png",
                      width: 150, height: 150), // Your icon image
                  const SizedBox(height: 8), // Space between icon and text
                  const Text(
                    'Scan Invoice', // The label text
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    textAlign: TextAlign.center, // Center align text
                  ),
                ],
              ),
            ),
            const Divider(
              height: 10,
              thickness: 2,
              indent: 10,
              endIndent: 10,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                getImage(false);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                minimumSize:
                    const Size.fromHeight(200), // Same here for consistency
                elevation: 0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset("images/file.png",
                      width: 150, height: 150), // Your second icon image
                  const SizedBox(height: 8), // Space between icon and text
                  const Text(
                    'Upload Invoice', // The label text for the second button
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: numIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 14,
        unselectedFontSize: 14,
        onTap: (value) {
          // Respond to item press.
          if (value == 0) {
            // FirebaseAuth.instance.signOut();
            Navigator.of(context).pushReplacementNamed('loginScreen');
          } else if (value == 1) {
            Navigator.of(context).pushReplacementNamed('homeScreen');
          } else if (value == 2) {
            Navigator.of(context).pushReplacementNamed('listInvoicesScreen');
          } else {
            Navigator.of(context).pushReplacementNamed('homeScreen');
          }
        },
        items: const [
          BottomNavigationBarItem(
            label: 'Log Out',
            icon: Icon(Icons.logout),
          ),
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'List invoices ',
            icon: Icon(Icons.receipt),
          ),
        ],
      ),
    );
  }
}

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mufawtar/screens/charts_screen.dart';
import 'package:mufawtar/screens/description_Screen1.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:mufawtar/screens/enhancement_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  XFile? _image; 
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> getImage(bool isCamera) async {
    ImagePicker picker = ImagePicker();
    XFile? image;

    if (isCamera) {
      image = await picker.pickImage(source: ImageSource.camera);
    } else {
      image = await picker.pickImage(source: ImageSource.gallery);
    }

    setState(() {
      _image = image; // Assign the XFile to _image
    });

    if (image != null) {
      File imageFile = File(image.path);
      var editedImage;
      editedImage = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageCropper(
            image: imageFile.readAsBytesSync(),
          ),
        ),
      );
      if (editedImage != null) {
        imageFile.writeAsBytes(editedImage);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EnhanceScreen(
              image: imageFile,
            ),
          ),
        );
      } else {
        Navigator.of(context).pushReplacementNamed('homeScreen');
      }
    }
  }

  final user = FirebaseAuth.instance.currentUser!; // this will save all actions user did
  @override
  Widget build(BuildContext context) {
    int numIndex = 0;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.purple,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'MUFAWTAR',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'All Invoices In One Place',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
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
                      width: 150, height: 150), // icon image
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
                    const Size.fromHeight(200), 
                elevation: 0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset("images/file.png",
                      width: 150, height: 150), //  second icon image
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
        currentIndex: 1,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        onTap: (value) {
          // Respond to item press.
          if (value == 0) {
            FirebaseAuth.instance.signOut();
            Navigator.of(context).pushReplacementNamed('loginScreen');
          } else if (value == 1) {
            Navigator.of(context).pushReplacementNamed('homeScreen');
          } else if (value == 2) {
            Navigator.of(context).pushReplacementNamed('listInvoicesScreen');
          }else if (value == 3) {
            Navigator.of(context).pushReplacementNamed('chartsScreen');
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
          BottomNavigationBarItem(
            label: 'summary',
            icon: Icon(Icons.bar_chart)
          ),
        ],
      ),
    );
  }
}

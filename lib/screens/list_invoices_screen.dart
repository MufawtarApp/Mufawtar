import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mufawtar/addInvoice.dart';
import 'package:mufawtar/screens/image_Full_screen.dart';
import 'package:mufawtar/screens/text_Full_screen.dart';


class FullScreenView extends StatelessWidget {
  final Widget content;
  const FullScreenView({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Full Screen View'),
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: content,
      ),
    );
  }
}

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
   @override
  Widget build(BuildContext context) {
    int numIndex = 0;
    return Scaffold(
      appBar: AppBar(
        title: const Text('List of Invoices'),
        backgroundColor: Colors.purple,
      ),
      body: ListView.builder(
  itemCount: InvoiceManager().invoices.length,
  itemBuilder: (context, index) {
    final invoice = InvoiceManager().invoices[index];
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FullScreenTextView(
              text: invoice['description'],
              onTextChanged: (newText) {
                setState(() {
                  invoice['description'] = newText;
                });
              },
            ),
          ),
        );
      },
      child: Card(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FullScreenImageView(
                      image: invoice['image'],
                      onImageChanged: (newImage) {
                        setState(() {
                          invoice['image'] = newImage;
                        });
                      },
                    ),
                  ),
                );
              },
              child: Image.file(invoice['image'], width: 200, height: 200),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(invoice['description']),
            ),
          ],
        ),
      ),
    );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushReplacementNamed('homeScreen');
        },
        child: const Icon(Icons.add),
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
          if (value == 0) {
            Navigator.of(context).pushReplacementNamed('loginScreen');
          } else if (value == 1) {
            Navigator.of(context).pushReplacementNamed('homeScreen');
          } else if (value == 2) {
            Navigator.of(context).pushReplacementNamed('listInvoicesScreen');
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
            label: 'List invoices',
            icon: Icon(Icons.receipt),
          ),
        ],
      ),
    );
  }
}

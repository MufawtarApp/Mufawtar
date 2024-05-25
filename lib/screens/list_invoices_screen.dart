import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart'; 
import 'package:mufawtar/addInvoice.dart';
import 'package:mufawtar/invoce.dart';
import 'dart:io';
import 'package:mufawtar/screens/filter_screen.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final InvoiceManager invoiceManager = InvoiceManager();

  // Function to pick an image from the gallery
  Future<File?> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    return pickedFile != null ? File(pickedFile.path) : null;
  }

  // Function to fetch invoices from Firestore
  Future<void> fetchInvoicesFromFirestore() async {
    try {
      InvoiceManager().invoices.clear(); // Clear the list of invoices
      await FirebaseFirestore.instance
          .collection('invoices')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get() // Get the collection of invoices
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          // For each document in the collection
          InvoiceManager().addInvoice(
            doc['imageUrl'],
            doc['storeName'],
            doc['totalPrice'],
            doc['dateOfTime'],
            doc.id,
          );
        });
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  // Function to show the dialog
  void _showEditDialog(String title, String value) {
    
       showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text('The $title is $value'),
        actions: <Widget>[
          TextButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
  }

  // Function to show the image in a dialog
  void _showImageinDialog(Invoice invoice, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Image.network(invoice.image),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List of Invoices',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      FilterScreen(invoices: invoiceManager.invoices),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: fetchInvoicesFromFirestore(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while fetching invoices
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: invoiceManager.invoices.length,
            itemBuilder: (context, index) {
              var invoice = invoiceManager.invoices[index];
              return Card(
                margin: const EdgeInsets.all(16), // Add padding around the card
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        InkWell(
                          onTap: () => _showImageinDialog(invoice, index),
                          child: Image.network(
                            invoice.image,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: IconButton(
                            icon:
                                const Icon(Icons.delete, color: Colors.white),
                            onPressed: () async {
                              // Show a confirmation dialog before deleting the invoice
                              bool confirmDelete = await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Confirm Delete'),
                                  content: const Text(
                                      'Are you sure you want to delete this invoice?'),
                                  actions: [
                                    TextButton(
                                      child: const Text('Cancel'),
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                    ),
                                    TextButton(
                                      child: const Text('Delete'),
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                    ),
                                  ],
                                ),
                              );
                              if (confirmDelete == true) {
                                // Delete the invoice from Firestore
                                await FirebaseFirestore.instance
                                    .collection('invoices')
                                    .doc(invoice.docId)
                                    .delete();
                                setState(() {});
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Invoice deleted successfully')),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const Divider(), // Add a divider between image and text details
                    Padding(
                      padding:
                          const EdgeInsets.all(16), // Add padding around the text details
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () => _showEditDialog(
                                'Store Name',invoice.companyName,),
                            child: Row(
                              children: [
                                const Icon(Icons.business,
                                    color: Colors.purple), // Add an icon for company name
                                const SizedBox(width: 8), // Add spacing between icon and text
                                Text(
                                  invoice.companyName,
                                  style: const TextStyle(
                                    fontSize: 13, // Increase font size for better readability
                                    fontWeight: FontWeight.bold, // Make the text bold
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                              height:
                                  8), // Add spacing between company name and total price
                          InkWell(
                            onTap: () => _showEditDialog(
                                 'Total Price',invoice.totalPrice,),
                            child: Row(
                              children: [
                                const Icon(Icons.attach_money,
                                    color: Colors.purple), // Add an icon for total price
                                const SizedBox(width: 8), // Add spacing between icon and text
                                Text(
                                  'Total Price: ${invoice.totalPrice} US',
                                  style: const TextStyle(
                                      fontSize:
                                          13), 
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                              height:
                                  8), // Add spacing between total price and date of time
                          InkWell(
                            onTap: () => _showEditDialog(
                                 'Date Of Time',invoice.dateOfTime,
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today,
                                    color: Colors.purple), // Add an icon for date of time
                                const SizedBox(width: 8), // Add spacing between icon and text
                                Text(
                                  'Date Of Time: ${DateFormat('MMM d, yyyy hh:mm a').format(DateTime.parse(invoice.dateOfTime))}', // Format the date and time
                                  style: const TextStyle(
                                      fontSize:
                                          11), 
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
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
        currentIndex: 2,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        onTap: (value) {
          if (value == 0) {
            FirebaseAuth.instance.signOut();
            Navigator.of(context).pushReplacementNamed('loginScreen');
          } else if (value == 1) {
            Navigator.of(context).pushReplacementNamed('homeScreen');
          } else if (value == 2) {
            Navigator.of(context).pushReplacementNamed('listInvoicesScreen');
          } else if (value == 3) {
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
            label: 'List invoices',
            icon: Icon(Icons.receipt),
          ),
          BottomNavigationBarItem(
            label: 'Summary',
            icon: Icon(Icons.bar_chart),
          ),
        ],
      ),
    );
  }
}



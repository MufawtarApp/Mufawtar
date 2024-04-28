import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mufawtar/addInvoice.dart';
import 'package:mufawtar/invoce.dart';
import 'dart:io';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final InvoiceManager invoiceManager = InvoiceManager();

  Future<File?> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    return pickedFile != null ? File(pickedFile.path) : null;
  }

  void _showEditDialog(
      String title, String currentValue, Function(String) onSave,
      {bool isNumeric = false}) {
    TextEditingController textController =
        TextEditingController(text: currentValue);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit $title'),
          content: TextFormField(
            controller: textController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Enter $title', // Provide a hint to enter text
            ),
            keyboardType: isNumeric
                ? TextInputType.numberWithOptions(decimal: true)
                : TextInputType.text,
            validator: isNumeric
                ? (value) {
                    if (value == null ||
                        value.isEmpty ||
                        double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  }
                : null,
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                // If numeric, validate for number
                if (isNumeric &&
                    (textController.text.isEmpty ||
                        double.tryParse(textController.text) == null)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text('Please enter a valid number for $title')),
                  );
                  return;
                }
                // For non-empty company name
                if (!isNumeric && textController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$title cannot be empty')),
                  );
                  return;
                }
                onSave(textController.text.trim());
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showImageEditDialog(Invoice invoice, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Image'),
          content: Image.file(invoice.image),
          actions: [
            TextButton(
              child: Text('Change Image'),
              onPressed: () async {
                var newImage = await _pickImage();
                if (newImage != null) {
                  setState(() {
                    invoice.image = newImage;
                  });
                  Navigator.of(context).pop();
                } else {
                  // Show an error if no new image is selected
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('You must select an image')),
                  );
                }
              },
            ),
            TextButton(
              child: Text('Close'),
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
      ),
      body: ListView.builder(
        itemCount: invoiceManager.invoices.length,
        itemBuilder: (context, index) {
          var invoice = invoiceManager.invoices[index];
          return Card(
            child: Column(
              children: [
                InkWell(
                  onTap: () => _showImageEditDialog(invoice, index),
                  child: Image.file(invoice.image, width: 200, height: 200),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () => _showEditDialog(
                            'Company Name', invoice.companyName, (newValue) {
                          setState(() {
                            invoice.companyName = newValue;
                          });
                        }),
                        child: Text('Compny Name: ${invoice.companyName} ',
                            ),
                      ),Text("",
                            ),
                      // When tapping on the total price text
                      InkWell(
                        onTap: () => _showEditDialog(
                            'Total Price', invoice.totalPrice, (newValue) {
                          setState(() {
                            invoice.totalPrice = newValue;
                          });
                        }, isNumeric: true),
                        child: Text('Total Price: ${invoice.totalPrice} SAR',
                            ),
                      ),
                    ],
                  ),
                ),
              ],
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
        currentIndex:
            0, // Assuming you want 'List of Invoices' to be the selected item
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

// Function to show the image in a popup dialog
void _showImagePopup(BuildContext context, File imageFile) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Image.file(imageFile),
        ),
      );
    },
  );
}

// Function to show the text in a popup dialog
void _showTextPopup(BuildContext context, String text) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Text(text),
        actions: <Widget>[
          TextButton(
            child: Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

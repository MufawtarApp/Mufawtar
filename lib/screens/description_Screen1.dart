import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../addInvoice.dart';

class DescriptionScreen extends StatefulWidget {
  final File? image;

  // Constructor with an optional image parameter.
  const DescriptionScreen({super.key, this.image});

  @override
  State<DescriptionScreen> createState() => _DescriptionScreenState();
}

class _DescriptionScreenState extends State<DescriptionScreen> {
  final user =
      FirebaseAuth.instance.currentUser!; // this will save all actions user did
  // Text editing controllers for the store name and total price fields.
  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _totalPriceController = TextEditingController();

  // Clean up controllers when the widget is disposed.
  @override
  void dispose() {
    _storeNameController.dispose();
    _totalPriceController.dispose();
    super.dispose();
  }

  // This method is used to validate if the entered text is a number.
  String? _validateNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a number';
    }
    final number = num.tryParse(value);
    if (number == null) {
      return 'Please enter a valid number';
    }
    return null; // return null if the input is a valid number
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Description Screen',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.purple,
      ),
      // Using a single child scroll view to allow for scrolling when the keyboard is displayed.
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              // SingleChildScrollView allows the content to be scrollable.
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    // Conditionally display the image if it is provided.
                    if (widget.image != null)
                      Image.file(widget.image!, width: 300, height: 300),
                    const SizedBox(height: 16),
                    // Text field for the store name input.
                    TextField(
                      controller: _storeNameController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        labelText: 'Store Name',
                        prefixIcon:
                            const Icon(Icons.store, color: Colors.purple),
                      ),
                    ),
                    // Text field for the total price input.
                    TextFormField(
                      controller: _totalPriceController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        labelText: 'Total Price',
                        prefixIcon: const Icon(Icons.attach_money,
                            color: Colors.purple),
                        suffixText: 'SAR', // Change the currency.
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true), // Numeric input for price.
                      validator:
                          _validateNumber, // Use the validator method for number validation
                    ),
                  ],
                ),
              ),
            ),
            // Confirm button at the bottom of the screen.
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              width: double
                  .infinity, // Ensure the button takes full width of the screen
              child: ElevatedButton.icon(
                onPressed: () {
                  // Validate inputs before saving.
                  if (_storeNameController.text.isNotEmpty &&
                      _totalPriceController.text.isNotEmpty) {
                    InvoiceManager().addInvoice(
                      widget.image ??
                          File(''), // Handle null image case appropriately
                      _storeNameController.text,
                      _totalPriceController.text,
                    );
                    Navigator.pop(context);
                  }
                },
                icon: const Icon(Icons.check), // Icon for the button.
                label: const Text('Confirm'), // Text label for the button.
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(
                      50), // Set the height of the button.
                  backgroundColor: Colors.purple, // Button color.
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

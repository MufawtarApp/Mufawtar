import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../addInvoice.dart';

class DescriptionScreen extends StatefulWidget {
  final File? image;
  final Function(File, String)? addInvoice;
  const DescriptionScreen({Key? key, this.image, this.addInvoice}) : super(key: key);

  @override
  State<DescriptionScreen> createState() => _DescriptionScreenState();
}

class _DescriptionScreenState extends State<DescriptionScreen> {
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Description'),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView( // Wrap the Column in a SingleChildScrollView
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (widget.image != null)
              Image.file(widget.image!, width: 300, height: 300),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Description',
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
  if (widget.image != null) {
    InvoiceManager().addInvoice(widget.image!, _descriptionController.text);
    Navigator.pop(context);
  }
},

        child: const Icon(Icons.check),
      ),
    );
  }
}

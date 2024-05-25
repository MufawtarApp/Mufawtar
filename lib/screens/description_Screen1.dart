import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mufawtar/ocr/ocr.dart';
import 'package:mufawtar/screens/list_invoices_screen.dart';
import '../addInvoice.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class DescriptionScreen extends StatefulWidget {
  final File? image;

  const DescriptionScreen({super.key, this.image});

  @override
  State<DescriptionScreen> createState() => _DescriptionScreenState();
}

class _DescriptionScreenState extends State<DescriptionScreen> {
  bool isLoading = false; 
  // Text editing controllers for the store name, total price, and extracted text fields.
  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _totalPriceController = TextEditingController();
  final TextEditingController _extractedTextController = TextEditingController();
  OCR? _ocr; // The OCR instance for text recognition

  @override
  void initState() {
    super.initState();
    _initializeAwesomeNotifications();
    _ocr = OCR(); // Initialize the OCR instance
    if (widget.image != null) {
      extractDetails(widget.image!); // Start extracting details if an image is provided
    }
  }

  void _initializeAwesomeNotifications() {
    AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'scheduled',
          channelName: 'Scheduled Notifications',
          channelDescription: 'Channel for scheduled notifications',
          importance: NotificationImportance.High,
          defaultColor: Colors.purple,
          ledColor: Colors.white,
        ),
      ],
      debug: true // Enable debug to see more details in logs
    );

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    AwesomeNotifications().setListeners(
      onActionReceivedMethod: (ReceivedAction receivedAction) async {
        // Handle notification action
        if (receivedAction.buttonKeyPressed == 'open_screen') {
          // Navigate to the List Screen when the notification is pressed
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => ListScreen()),
            (Route<dynamic> route) => false,
          );
        }
      },
    );
  }


  Future<DateTime?> pickDateTime(BuildContext context, DateTime initialDate) async {
    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (date == null) return null; // User canceled the date picker.

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(DateTime.now()),
    );
    if (time == null) return null; // User canceled the time picker.

    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

 Future<void> scheduleNotification(DateTime dateTime) async {
    final DateTime dateTime_15s = dateTime.add(const Duration(seconds: 15 ));
    final DateTime fiveDaysBefore = dateTime_15s.subtract(const Duration(days: 5));

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey: 'scheduled',
        title: 'Mufawtar',
        body: 'Your Invoice Warranty Has Expired!',
        notificationLayout: NotificationLayout.Default,
        displayOnBackground: true,
        displayOnForeground: true,
        actionType: ActionType.Default,
        payload: {'navigateTo': 'list_screen'},
      ),
      schedule: NotificationCalendar.fromDate(date: dateTime_15s),
      actionButtons: [
        NotificationActionButton(
          key: 'open_screen',
          label: 'Open',
        ),
      ],
    );

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: (DateTime.now().millisecondsSinceEpoch + 1).remainder(100000),
        channelKey: 'scheduled',
        title: 'Mufawtar',
        body: 'Your Invoice Warranty is about to expire in 5 days!',
        notificationLayout: NotificationLayout.Default,
        displayOnBackground: true,
        displayOnForeground: true,
        actionType: ActionType.Default,
        payload: {'navigateTo': 'list_screen'},
      ),
      schedule: NotificationCalendar.fromDate(date: fiveDaysBefore),
      actionButtons: [
        NotificationActionButton(
          key: 'open_screen',
          label: 'Open',
        ),
      ],
    );
  }


  Future<void> storeDataInFirebase(String storeName, String totalPrice, String dateOfTime, File image) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser!.uid;
      Reference ref = FirebaseStorage.instance.ref().child('invoices').child('$currentUser${DateTime.now()}.jpg'); // Create a reference to the location you want to upload to in Firebase Storage
      UploadTask uploadTask = ref.putFile(image); // Put the file in the created storage location
      TaskSnapshot storageTaskSnapshot = await uploadTask.whenComplete(() => null); // Waits for the upload to complete
      String imageUrl = await storageTaskSnapshot.ref.getDownloadURL(); // Get the download URL of the image uploaded

      print("Storing Data");

      InvoiceManager().invoices.clear(); // Clear the list of invoices

      await FirebaseFirestore.instance.collection('invoices').add({
        // Add the data to the FireStore collection
        'storeName': storeName,
        'totalPrice': totalPrice,
        'dateOfTime': dateOfTime,
        'imageUrl': imageUrl,
        'userId': currentUser,
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to upload the invoice'),
        ),
      );
      print(e);
    }
  }

  void extractDetails(File imageFile) async {
    setState(() {
      isLoading = true; 
    });
    final details = await _ocr!.extractInvoiceDetails(imageFile); // Call the OCR method to extract details
    setState(() {
      // Set the text in the controllers with the extracted data
      _storeNameController.text = details['companyName'] ?? '';
      _totalPriceController.text = details['totalAmount'] ?? '';
      _extractedTextController.text = details['dateOfTime'] ?? ''; 
      isLoading = false; // Set loading to false after extraction
    });
  }

  @override
  void dispose() {
    // Dispose of all the controllers and OCR resources
    _storeNameController.dispose();
    _totalPriceController.dispose();
    _extractedTextController.dispose();
    _ocr?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Description Screen', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.purple,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    if (widget.image != null) Image.file(widget.image!, width: 300, height: 300),
                    const SizedBox(height: 16),
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
                        prefixIcon: const Icon(Icons.store, color: Colors.purple),
                      ),
                    ),
                    const SizedBox(height: 16),
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
                        prefixIcon: const Icon(Icons.attach_money, color: Colors.purple),
                        suffixText: 'US',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')), // Allow only numbers and up to two decimal points
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _extractedTextController,
                      readOnly: true, // Make this text field read-only so the user cant edit it
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        labelText: 'Date of Time',
                        prefixIcon: const Icon(Icons.calendar_month, color: Colors.purple),
                      ),
                      maxLines: null, // Allows the text field to expand as text grows
                      keyboardType: TextInputType.multiline,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final dateTime = await pickDateTime(context, DateTime.now());
                        if (dateTime != null) {
                          scheduleNotification(dateTime);
                        }
                      },
                      icon: const Icon(Icons.calendar_month_sharp),
                      label: const Text('Reminder', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () async {
                        if (_storeNameController.text.isNotEmpty &&
                            _totalPriceController.text.isNotEmpty &&
                            _extractedTextController.text.isNotEmpty) {
                          await storeDataInFirebase(
                            _storeNameController.text,
                            _totalPriceController.text,
                            _extractedTextController.text,
                            widget.image!,
                          );

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => ListScreen()),
                            (Route<dynamic> route) => false, // Replace NextScreen with the screen you want to navigate to.
                          );


                        }else if (_storeNameController.text.isEmpty &&
                                   _totalPriceController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Both Store Name and Total Price are empty')),
                          );
                        } else if (_storeNameController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Store Name is empty')),
                          );
                        } else if (_totalPriceController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Total Price is empty')),
                          );
                        }
                      },
                      icon: const Icon(Icons.check),
                      label: const Text('Confirm', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

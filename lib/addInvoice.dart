import 'dart:io';

class InvoiceManager {
  static final InvoiceManager _instance = InvoiceManager._internal();
  factory InvoiceManager() => _instance;
  InvoiceManager._internal();

  List<Map<String, dynamic>> invoices = [];

  void addInvoice(File image, String description) {
    invoices.add({'image': image, 'description': description});
  }
}
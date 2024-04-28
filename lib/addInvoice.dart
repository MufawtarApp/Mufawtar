import 'dart:io';

import 'package:mufawtar/invoce.dart';

class InvoiceManager {
  static final InvoiceManager _instance = InvoiceManager._internal();
  factory InvoiceManager() => _instance;
  InvoiceManager._internal();

  List<Invoice> invoices = [];

  void addInvoice(File image, String companyName, String totalPrice) {
    Invoice newInvoice = Invoice(image: image, companyName: companyName, totalPrice: totalPrice);
    invoices.add(newInvoice);
  }
}
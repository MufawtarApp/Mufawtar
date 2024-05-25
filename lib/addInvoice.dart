import 'dart:io';

import 'package:mufawtar/invoce.dart';

class InvoiceManager {
  static final InvoiceManager _instance = InvoiceManager._internal();

  factory InvoiceManager() => _instance;

  InvoiceManager._internal();

  List<Invoice> invoices = [];

  void addInvoice(String image, String companyName, String totalPrice,
      String dateOfTime, String docId) {
    Invoice newInvoice = Invoice(
        image: image,
        companyName: companyName,
        totalPrice: totalPrice,
        dateOfTime: dateOfTime,
        docId: docId
    );
    invoices.add(newInvoice);
  }
}

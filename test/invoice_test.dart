import 'package:flutter_test/flutter_test.dart';
import 'package:mufawtar/addInvoice.dart';


void main() {


  group('Invoices Tests', () {
    test('Fetch invoices from Firestore', () async {
      // test that invoice are store in the list of invoices that we are showing in the list of invoices screen
      final invoiceManager = InvoiceManager();

      invoiceManager.addInvoice('', "Hello", "20", "7", "sampleId");

      // Assert that invoices are fetched correctly
      expect(invoiceManager.invoices.isNotEmpty, true);
      // Add more assertions as needed
    });
  });
}

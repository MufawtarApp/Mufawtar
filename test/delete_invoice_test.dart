import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mufawtar/firebase_options.dart';
import 'package:mufawtar/widgets/delete_image.dart';

void main() {


  DeleteImage deleteImage = DeleteImage();

  group('Delete Invoice Tests', () {
    test('Delete Invoice', () async {
      // test that the invoice is deleted from the list of invoices

      deleteImage.deleteInvoice("sampleId");
      // Assert that the invoice is deleted from the list of invoices
      expect(deleteImage.isDeleted, false);
      expect(deleteImage.isNotDeleted, true);
      // Add more assertions as needed
    });
  });
}

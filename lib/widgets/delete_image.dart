

import 'package:cloud_firestore/cloud_firestore.dart';

class DeleteImage{

  bool isDeleted = false;
  bool isNotDeleted = false;

  void deleteInvoice(String name)  {
    try {
      FirebaseFirestore.instance.collection('invoices').doc(name).delete();
      isDeleted = true;
    } catch (e) {
      isNotDeleted = true;
      print(e);
    }
  }

}
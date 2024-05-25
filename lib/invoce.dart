import 'dart:io';

class Invoice {
  String image;
  String companyName;
  String totalPrice;
  String dateOfTime;
  String docId;

  Invoice(
      {required this.image,
      required this.companyName,
      required this.docId,
      required this.totalPrice,
      required this.dateOfTime});
}

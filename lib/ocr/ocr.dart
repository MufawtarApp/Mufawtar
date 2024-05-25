import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:google_mlkit_entity_extraction/google_mlkit_entity_extraction.dart';
import 'package:tflite/tflite.dart';

class OCR {
  final TextRecognizer textRecognizer;

  OCR() : textRecognizer = TextRecognizer(script: TextRecognitionScript.latin) {
    loadModel(); // Load the TFLite model
  }

  // Load the TFLite model
  void loadModel() async {
    await Tflite.loadModel(
      model: 'assets/model.tflite',
      labels: 'assets/labels.txt',
    );
  }

  Future<Map<String, String?>> extractInvoiceDetails(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

    // Use the TFLite model to extract the store name
    String? companyName = await predictStoreName(imageFile, recognizedText);

    final entityExtractor = EntityExtractor(language: EntityExtractorLanguage.english);
    final List<EntityAnnotation> annotations = await entityExtractor.annotateText(recognizedText.text);
    entityExtractor.close(); // Ensure the extractor is closed after use

    String? totalAmount = extractTotalAmount(recognizedText.text, annotations);

    String? dateOfTime = DateTime.now().toString().substring(0, 16);

    textRecognizer.close(); // Close the text recognizer resource

    return {
      'companyName': companyName,
      'totalAmount': totalAmount,
      'dateOfTime': dateOfTime,
    };
  }

  // Use TFLite to predict the store name from the image
  Future<String?> predictStoreName(File imageFile, RecognizedText recognizedText) async {
   
   
    var output = await Tflite.runModelOnImage(
      path: imageFile.path,
      imageMean: 127.5,   // defaults to 117.0
      imageStd: 127.5,  // defaults to 1.0
      numResults: 1,    // defaults to 5
      threshold: 0.7,  // defaults to 0.1
    );

    if (output != null && output.isNotEmpty && output[0]['confidence'] >= 0.7) {
           

      if(recognizedText.blocks.isNotEmpty){return extractCompanyName(output.first['label']); }
    } else {
      // If the accuracy is less than 70%, use OCR to extract the company name from the first line
      if (recognizedText.blocks.isNotEmpty) {
        return recognizedText.blocks.first.lines.first.text;
      }
    }
    return null;

    
  }
  

  String? extractTotalAmount(String text, List<EntityAnnotation> annotations) {
    // Initialize both potential totals as null.
    String? totalAmountEntity = null;
    String? totalAmountRegex = null;

    // First, extract the total amount using entity extraction.
    for (final annotation in annotations) {
      for (final entity in annotation.entities) {
        if (entity.type.name.contains("money")) {
          totalAmountEntity = annotation.text;
          break; // Break once a money entity is found.
        }
      }


    }

    // Extract the total amount using regex.
    totalAmountRegex = extractTotalWithRegex(text);

    // Remove the dollar sign from totalAmountRegex and totalAmountEntity
    totalAmountRegex = totalAmountRegex?.replaceAll('\$', '');
    totalAmountEntity = totalAmountEntity?.replaceAll('\$', '');

    // Replace comma with dot in totalAmountRegex and totalAmountEntity
    totalAmountRegex = totalAmountRegex?.replaceAll(',', '.');
    totalAmountEntity = totalAmountEntity?.replaceAll(',', '.');

    // Now convert both string amounts to doubles for comparison, defaulting to 0 if null.
    double entityAmount = 0;
    if (totalAmountEntity != null) {
      entityAmount = double.tryParse(totalAmountEntity) ?? 0;
      print('Entity extraction value:============== $entityAmount'); // Debug print
    }

    double regexAmount = 0;
    if (totalAmountRegex != null) {
      regexAmount = double.tryParse(totalAmountRegex) ?? 0;
      print('regex extraction value:================= $regexAmount');
    }

    // Compare the amounts and choose the larger one.
    String? finalTotalAmount;
    if (entityAmount >= regexAmount) {
      finalTotalAmount = totalAmountEntity;
    } else {
      finalTotalAmount = totalAmountRegex;
    }

    return finalTotalAmount;
  }

  String? extractTotalWithRegex(String text) {
      // regex pattern
    RegExp regExp = RegExp(r'(?:grand\s+)?(?:total|balance|amount)(?:\s+due)?(?:\s+owing)?(?:\s+owed)?(?:\s+payable)?\s*[:=]?\s*(\d+[.,]?\d{0,2})', caseSensitive: false);
    // Find all matches
    Iterable<RegExpMatch> matches = regExp.allMatches(text);

    // Assume the last match is the total amount
    RegExpMatch? lastMatch;
    for (final match in matches) {
      lastMatch = match;
      
    }

    // Return the amount found in the last match, or null if there was no match
     return lastMatch?.group(1)?.replaceAll(',', ''); // Remove commas and return the amount
  }

    String extractCompanyName(String companyName1) {
    // Find the index of the first space
    int spaceIndex = companyName1.indexOf(' ');

    // Check if there's a space
    if (spaceIndex != -1) {
      // Return the substring starting after the first space
      return companyName1.substring(spaceIndex + 1);
    }

    // If no space is found, return the original trimmed companyName
    return companyName1;
  }

  void dispose() {
    Tflite.close();
    textRecognizer.close();
  }
}

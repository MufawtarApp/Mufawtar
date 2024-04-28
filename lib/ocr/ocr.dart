import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'dart:io';

class OCR {
  final TextRecognizer textRecognizer;

  OCR() : textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  Future<Map<String, String?>> extractInvoiceDetails(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

    String? companyName;
    String? totalAmount;

    if (recognizedText.blocks.isNotEmpty) {
      companyName = recognizedText.blocks.first.text.split('\n').first;
    }

    final totalAmountRegex = RegExp(r'TOTAL\s+\$?([\d,]+\.?\d*)', caseSensitive: false);
    for (final block in recognizedText.blocks) {
      for (final line in block.lines) {
        if (line.text.contains('TOTAL')) {
          final totalMatch = totalAmountRegex.firstMatch(line.text);
          if (totalMatch != null) {
            totalAmount = totalMatch.group(1)?.replaceAll(',', '');
            break;
          }
        }
      }
      if (totalAmount != null) break;
    }

    return {
      'companyName': companyName,
      'totalAmount': totalAmount,
    };
  }

  void dispose() {
    textRecognizer.close();
  }
}

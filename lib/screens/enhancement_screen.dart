import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mufawtar/ocr/ocr.dart';
import 'package:mufawtar/screens/description_Screen1.dart';
import '../addInvoice.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class EnhanceScreen extends StatefulWidget {
  File? image;

  // Constructor with an optional image parameter.
  EnhanceScreen({super.key, this.image});

  @override
  State<EnhanceScreen> createState() => _EnhanceScreenState();
}

class _EnhanceScreenState extends State<EnhanceScreen> {
  bool isLoading = false; // Define the isLoading variable
  // Text editing controllers for the store name, total price, and extracted text fields.
  late img.Image inputImage;
  bool isBlackAndWhite = false;

  @override
  initState() {
    super.initState();
    inputImage = img.decodeImage(this.widget.image!.readAsBytesSync())!;
    enhanceImage();
  }

  enhanceImage() {
    img.Image temp = img.decodeImage(this.widget.image!.readAsBytesSync())!;
    img.adjustColor(temp, brightness: brightness);
    inputImage = img.contrast(temp, contrast: contrast);

    if (isBlackAndWhite) {
      inputImage = img.grayscale(inputImage);
    }

    setState(() {
      inputImage;
    });
  }

  double contrast = 100;
  double brightness = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enhancement Screen',
            style: TextStyle(color: Colors.white)),
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
                    Image.memory(
                      Uint8List.fromList(img.encodeBmp(inputImage)),
                      width: 500,
                      height: 500,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 10),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.contrast,
                            size: 30,
                            color: Colors.purple[600],
                          ),
                          Expanded(
                            child: Slider(
                              value: contrast,
                              onChanged: (value) {
                                contrast = value;
                                enhanceImage();
                                setState(() {
                                  contrast;
                                });
                              },
                              min: 80,
                              max: 200,
                              divisions: 10,
                              label: contrast.toStringAsFixed(2),
                              activeColor: Colors.purple[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 10),
                      child: Row(
                        children: [
                          Icon(
                            Icons.brightness_2,
                            size: 30,
                            color: Colors.purple[600],
                          ),
                          Expanded(
                            child: Slider(
                              value: brightness,
                              onChanged: (value) {
                                brightness = value;
                                enhanceImage();
                                setState(() {
                                  brightness;
                                });
                              },
                              min: 1,
                              max: 10,
                              divisions: 10,
                              label: brightness.toStringAsFixed(2),
                              activeColor: Colors.purple[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 10),
                      child: Row(
                        children: [
                          Icon(
                            Icons.filter_b_and_w,
                            size: 30,
                            color: Colors.purple[600],
                          ),
                          const SizedBox(width: 10),
                          const Text('Black & White'),
                          const SizedBox(width: 10),
                          Switch(
                            value: isBlackAndWhite,
                            onChanged: (value) {
                              setState(() {
                                isBlackAndWhite = value;
                                enhanceImage();
                              });
                            },
                            activeColor: Colors.purple[600],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          Uint8List encodedImage = img.encodePng(inputImage);
                          String timestamp =
                              DateTime.now().millisecondsSinceEpoch.toString();
                          String fileName =
                              path.basenameWithoutExtension(widget.image!.path);
                          String fileExtension =
                              path.extension(widget.image!.path);
                          String newFileName =
                              '${fileName}_$timestamp$fileExtension';
                          Directory tempDir = await getTemporaryDirectory();
                          String filePath =
                              path.join(tempDir.path, newFileName);
                          widget.image =
                              await File(filePath).writeAsBytes(encodedImage);
                          setState(() {
                            widget.image;
                          });

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DescriptionScreen(
                                image: widget.image,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.check),
                        label: const Text('Confirm',
                            style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

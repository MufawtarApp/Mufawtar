import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class FullScreenImageView extends StatefulWidget {
  final File image;
  final Function(File) onImageChanged;

  const FullScreenImageView({
    Key? key,
    required this.image,
    required this.onImageChanged,
  }) : super(key: key);

  @override
  State<FullScreenImageView> createState() => _FullScreenImageViewState();
}

class _FullScreenImageViewState extends State<FullScreenImageView> {
  Future<void> _changeImage() async {
    ImagePicker _picker = ImagePicker();
    XFile? newImage = await _picker.pickImage(source: ImageSource.gallery);

    if (newImage != null) {
      setState(() {
        widget.onImageChanged(File(newImage.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Image'),
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _changeImage,
          ),
        ],
      ),
      body: Center(
        child: Image.file(widget.image),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FullScreenTextView extends StatefulWidget {
  final String text;
  final Function(String) onTextChanged;

  const FullScreenTextView({
    Key? key,
    required this.text,
    required this.onTextChanged,
  }) : super(key: key);

  @override
  State<FullScreenTextView> createState() => _FullScreenTextViewState();
}

class _FullScreenTextViewState extends State<FullScreenTextView> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.text);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Text'),
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              widget.onTextChanged(_controller.text);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _controller,
          maxLines: null,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}

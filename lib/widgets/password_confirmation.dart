import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ConfirmPassword {

  bool passwordConfirmed(TextEditingController _passwordController,
      TextEditingController _confirmPasswordController) {
    if (_passwordController.text.trim() ==
        _confirmPasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

}

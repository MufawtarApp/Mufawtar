import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mufawtar/addInvoice.dart';
import 'package:mufawtar/widgets/password_confirmation.dart';

void main() {
  ConfirmPassword confirmPassword = ConfirmPassword();

  group('Password Tests', () {
    test('Confirm Password', () async {
      // test that the password and the confirm password are the same
      final _passwordController = TextEditingController();
      final _confirmPasswordController = TextEditingController();

      _passwordController.text = "123456";
      _confirmPasswordController.text = "123456";

      // Assert that the password and the confirm password are the same
      expect(
          confirmPassword.passwordConfirmed(
              _passwordController, _confirmPasswordController),
          true);
      // Add more assertions as needed
    });
  });
}

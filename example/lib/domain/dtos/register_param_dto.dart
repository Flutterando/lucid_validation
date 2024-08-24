import 'package:flutter/material.dart';

class RegisterParamDto extends ChangeNotifier {
  String _email;
  String _phone;
  String _password;
  String _confirmPassword;

  String get email => _email;
  String get phone => _phone;
  String get password => _password;
  String get confirmPassword => _confirmPassword;

  RegisterParamDto({
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
  })  : _email = email,
        _phone = phone,
        _password = password,
        _confirmPassword = confirmPassword;

  factory RegisterParamDto.empty() => RegisterParamDto(email: '', password: '', phone: '', confirmPassword: '');

  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    notifyListeners();
  }

  void setConfirmPassword(String value) {
    _confirmPassword = value;
    notifyListeners();
  }

  void setPhone(String value) {
    _phone = value;
    notifyListeners();
  }
}

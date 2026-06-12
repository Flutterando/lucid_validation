import 'package:flutter/material.dart';

/// DTO for the "Company / Profile" form used to showcase the 1.4.0 features:
/// async validation, rule sets, `ruleForEach`, `include`, `unless` and `normalize`.
class ProfileParamDto extends ChangeNotifier {
  String _email;
  bool _isCompany;
  String _companyName;
  final List<String> _tags;

  ProfileParamDto({
    required String email,
    required bool isCompany,
    required String companyName,
    required List<String> tags,
  })  : _email = email,
        _isCompany = isCompany,
        _companyName = companyName,
        _tags = tags;

  factory ProfileParamDto.empty() => ProfileParamDto(
        email: '',
        isCompany: false,
        companyName: '',
        tags: [''],
      );

  String get email => _email;
  bool get isCompany => _isCompany;
  String get companyName => _companyName;
  List<String> get tags => List.unmodifiable(_tags);

  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void setIsCompany(bool value) {
    _isCompany = value;
    notifyListeners();
  }

  void setCompanyName(String value) {
    _companyName = value;
    notifyListeners();
  }

  void setTag(int index, String value) {
    _tags[index] = value;
    notifyListeners();
  }

  void addTag() {
    _tags.add('');
    notifyListeners();
  }

  void removeTag(int index) {
    _tags.removeAt(index);
    notifyListeners();
  }
}

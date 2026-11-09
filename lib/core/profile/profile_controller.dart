import 'dart:io';

import 'package:flutter/foundation.dart';

class ProfileController extends ChangeNotifier {
  ProfileController._();

  static final ProfileController instance = ProfileController._();

  File? _avatar;
  String _name = '';
  String _phone = '';
  String _email = '';
  String _outageGroup = '';

  File? get avatar => _avatar;
  String get name => _name;
  String get phone => _phone;
  String get email => _email;
  String get outageGroup => _outageGroup;

  void setAvatar(File? value) {
    _avatar = value;
    notifyListeners();
  }

  void setName(String value) {
    _name = value;
    notifyListeners();
  }

  void setPhone(String value) {
    _phone = value;
    notifyListeners();
  }

  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void setOutageGroup(String value) {
    _outageGroup = value;
    notifyListeners();
  }
}
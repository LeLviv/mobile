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
  String? _token;

  File? get avatar => _avatar;
  String get name => _name;
  String get phone => _phone;
  String get email => _email;
  String get outageGroup => _outageGroup;
  String? get token => _token;

  void setAvatar(File? value) {
    if (_avatar?.path == value?.path) return;
    _avatar = value;
    notifyListeners();
  }

  void setName(String value) {
    if (_name == value) return;
    _name = value;
    notifyListeners();
  }

  void setToken(String value) {
    if (_token == value) return;
    _token = value;
    notifyListeners();
  }

  void setPhone(String value) {
    if (_phone == value) return;
    _phone = value;
    notifyListeners();
  }

  void setEmail(String value) {
    if (_email == value) return;
    _email = value;
    notifyListeners();
  }

  void setOutageGroup(String value) {
    if (_outageGroup == value) return;
    _outageGroup = value;
    notifyListeners();
  }

  void clear() {
    _avatar = null;
    _name = '';
    _token='';
    _phone = '';
    _email = '';
    _outageGroup = '';
    notifyListeners();
  }
}
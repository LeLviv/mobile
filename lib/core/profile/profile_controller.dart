
import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends ChangeNotifier {
  ProfileController._();

  static final ProfileController instance = ProfileController._();

  static const String _nameKey = 'profile_name';
  static const String _emailKey = 'profile_email';

  File? _avatar;
  String _name = '';
  String _phone = '';
  String _email = '';
  List<String> _outageGroups = [];
  String? _token;

  File? get avatar => _avatar;
  String get name => _name;
  String get phone => _phone;
  String get email => _email;
  List<String> get outageGroups => List.unmodifiable(_outageGroups);
  String? get token => _token;

  Future<void> restoreName() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedName = prefs.getString(_nameKey);

      final savedEmail = prefs.getString(_emailKey);

      if (savedEmail != null) {
        _email = savedEmail;
      }

      if ((savedName != null && savedName.isNotEmpty) ||
          (savedEmail != null && savedEmail.isNotEmpty)) {
        if (savedName != null) _name = savedName;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Name restore error: $e');
    }
  }

  Future<void> _saveName(String value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_nameKey, value);
    } catch (e) {
      debugPrint('Name save error: $e');
    }
  }

  Future<void> _saveEmail(String value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_emailKey, value);
    } catch (e) {
      debugPrint('Email save error: $e');
    }
  }

  void setAvatar(File? value) {
    if (_avatar?.path == value?.path) return;
    _avatar = value;
    notifyListeners();
  }

  void setName(String value) {
    if (_name == value) return;
    _name = value;
    notifyListeners();

    unawaited(_saveName(value));
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
    unawaited(_saveEmail(value));
  }

  void setOutageGroups(List<String> value) {
    if (listEquals(_outageGroups, value)) return;
    _outageGroups = List<String>.from(value);
    notifyListeners();
  }

  void clear() {
    _avatar = null;
    _name = '';
    _token = '';
    _phone = '';
    _email = '';
    _outageGroups = [];
    notifyListeners();

    unawaited(_removeSavedName());
  }

  Future<void> _removeSavedName() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_nameKey);
      await prefs.remove(_emailKey);
    } catch (e) {
      debugPrint('Name remove error: $e');
    }
  }
}
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserNotifier extends ChangeNotifier {
  User? _user;

  User? get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void clearUser() async {
    _user = null;
    await SharedPreferences.getInstance().then((prefs) {
      prefs.clear();
    });
    notifyListeners();
  }
}

class User {
  final String name;
  final String id;
  final String email;
  final String? image;

  User({required this.name, required this.email, this.image, required this.id});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      image: json['image'],
    );
  }
}

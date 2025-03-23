import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _userName = 'Faizur Rehman';
  String _profilePicture = 'assets/profile_picture.png';

  String get userName => _userName;
  String get profilePicture => _profilePicture;

  void updateUserName(String newName) {
    _userName = newName;
    notifyListeners();
  }

  void updateProfilePicture(String newImagePath) {
    _profilePicture = newImagePath;
    notifyListeners();
  }
}

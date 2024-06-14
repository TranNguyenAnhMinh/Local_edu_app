import 'package:flutter/material.dart';
import 'package:local_education_app/api/auth_api.dart';
import 'package:local_education_app/models/user/user.dart';
import 'package:local_education_app/services/storage/auth_storage.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  void setJwtToken(String token) {
    _token = token;
    notifyListeners();
  }

  String? get jwtToken => _token;
  Future<int> login(String username, String password) async {
    try {
      final response = await authLogin(username, password);
      if (response['statusCode'] == 200) {
        final result = response['result'];
        _token = result['token'];
        await AuthStorage.saveToken(_token!);
        notifyListeners();
        return 200;
      } else {
        return 400;
      }
    } catch (e) {
      debugPrint('Error while login in : $e');
      return -1;
    }
  }

  Future<void> logOut() async {
    _token = "";
    notifyListeners();
    await AuthStorage.deleteToken();
  }

  Future<User?> getProfile() async {
    try {
      final response = await authGetProfile(_token!);
      if (response['statusCode'] == 200) {
        final result = response['result'];
        return User.fromMap(result);
      } else {
        debugPrint("Unauthorized");
        return null;
      }
    } catch (e) {
      debugPrint("There is Error: $e");
      return null;
    }
  }
}

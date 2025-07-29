import 'dart:convert';

import 'package:qadam/src/model/api/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppCache{
  Future<void> saveLoginUser(UserModel user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user', jsonEncode(user.toJson()));
    prefs.setInt("id", user.id);
    prefs.setString("name", user.name);
    prefs.setString("phone", user.phone);
    prefs.setString("image", user.image);
    prefs.setInt("region_id", user.regionId);
    prefs.setInt("district_id", user.districtId);
    prefs.setInt("quarter_id", user.quarterId);
    prefs.setString("role", user.role);
    prefs.setBool("is_verified", user.isVerified==1?true:false);
  }
}
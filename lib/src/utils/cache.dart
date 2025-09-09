import 'package:qadam/src/model/api/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/api/get_user_model.dart';

class AppCache {
  Future<void> saveLoginUser(UserModel user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("id", user.id);
    prefs.setString("name", user.name);
    prefs.setString("phone", user.phone);
    prefs.setString("role", user.role);
    prefs.setBool("is_verified", user.isVerified == 1 ? true : false);
  }

  Future<void> saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("id", user.id);
    prefs.setString("first_name", user.firstName);
    prefs.setString("last_name", user.lastName);
    prefs.setString("father_name", user.fatherName);
    prefs.setString("email", user.email);
    prefs.setString("phone", user.phone);
    prefs.setString("role", user.role);
    prefs.setString(
        "driving_verification_status", user.drivingVerificationStatus);
    prefs.setString("balance", user.balance.balance);
  }

  Future<User> cacheGetMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    User info = User(
      id: prefs.getInt("id") ?? 0,
      firstName: prefs.getString("first_name") ?? "",
      lastName: prefs.getString("last_name") ?? "",
      fatherName: prefs.getString("father_name") ?? "",
      email: prefs.getString("email") ?? "",
      phone: prefs.getString("phone") ?? "",
      role: prefs.getString("role") ?? "",
      birthDate: prefs.getString("birth_date") != null
          ? DateTime.tryParse(prefs.getString("birth_date") ?? "")
          : DateTime(2000, 1, 1, 1, 1),
      drivingVerificationStatus:
          prefs.getString("driving_verification_status") ?? "none",
      createdAt: prefs.getString("created_at") != null
          ? DateTime.tryParse(prefs.getString("created_at") ?? "")
          : DateTime(2000, 1, 1, 1, 1),
      image: prefs.getString("image") ?? "",
      balance: prefs.getString("balance") != null
          ? Balance(
              balance: "",
              afterTax: "",
              tax: "",
              lockedBalance: "",
              currency: "")
          : Balance(
              balance: "",
              afterTax: "",
              tax: "",
              lockedBalance: "",
              currency: ""),
    );
    return info;
  }
}

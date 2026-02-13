import 'package:qadam/src/model/api/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/api/get_user_model.dart';

class AppCache {
  Future<void> saveLoginUser(UserModel user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("id", user.id);
    prefs.setString("first_name", user.firstName);
    prefs.setString("last_name", user.lastName);
    prefs.setString("father_name", user.fatherName);
    prefs.setString("email", user.email);
    prefs.setString("phone", user.phone);
    prefs.setString("role", user.role);
    prefs.setBool("is_verified", user.isVerified == 1 ? true : false);
    prefs.setString(
        "driving_verification_status", user.drivingVerificationStatus);
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
    prefs.setString("balance_after_tax", user.balance.afterTax);
    prefs.setString("balance_tax", user.balance.tax);
    prefs.setString("balance_locked", user.balance.lockedBalance);
    prefs.setString("balance_currency", user.balance.currency);
    prefs.setBool("isDocsAdded", user.role == "driver" ? true : false);
    if (user.birthDate != null) {
      prefs.setString("birth_date", user.birthDate!.toIso8601String());
    }
    if (user.createdAt != null) {
      prefs.setString("created_at", user.createdAt!.toIso8601String());
    }
    prefs.setString("image", user.image);
  }

  Future<User> cacheGetMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final birthDateStr = prefs.getString("birth_date");
    final createdAtStr = prefs.getString("created_at");

    User info = User(
      id: prefs.getInt("id") ?? 0,
      firstName: prefs.getString("first_name") ?? "",
      lastName: prefs.getString("last_name") ?? "",
      fatherName: prefs.getString("father_name") ?? "",
      email: prefs.getString("email") ?? "",
      phone: prefs.getString("phone") ?? "",
      role: prefs.getString("role") ?? "",
      birthDate: birthDateStr != null
          ? (DateTime.tryParse(birthDateStr) ?? DateTime(2000, 1, 1))
          : DateTime(2000, 1, 1),
      drivingVerificationStatus:
          prefs.getString("driving_verification_status") ?? "none",
      createdAt: createdAtStr != null
          ? (DateTime.tryParse(createdAtStr) ?? DateTime(2000, 1, 1))
          : DateTime(2000, 1, 1),
      image: prefs.getString("image") ?? "",
      balance: Balance(
        balance: prefs.getString("balance") ?? "0",
        afterTax: prefs.getString("balance_after_tax") ?? "0",
        tax: prefs.getString("balance_tax") ?? "0",
        lockedBalance: prefs.getString("balance_locked") ?? "0",
        currency: prefs.getString("balance_currency") ?? "USD",
      ),
    );
    return info;
  }
}

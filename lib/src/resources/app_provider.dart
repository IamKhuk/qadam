import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/event_bus/http_result.dart';

class ApiProvider {
  static Duration durationTimeout = const Duration(seconds: 30);
  static String baseUrl = "https://test.qadam.services/api/v1";

  static Future<HttpResult> postRequest(url, body, head) async {
    debugPrint(url);
    debugPrint(body);
    dynamic headers = await _getReqHeader();

    debugPrint(headers);
    try {
      http.Response response = await http
          .post(
        Uri.parse(url),
        headers: head ? headers : null,
        body: body,
      )
          .timeout(durationTimeout);
      debugPrint(response.body);
      return _result(response);
    } on TimeoutException catch (_) {
      return HttpResult(
        isSuccess: false,
        status: -1,
        result: {},
      );
    } on SocketException catch (_) {
      return HttpResult(
        isSuccess: false,
        status: -1,
        result: {},
      );
    }
  }

  static Future<HttpResult> getRequest(url) async {
    debugPrint(url);
    final dynamic headers = await _getReqHeader();
    try {
      http.Response response = await http
          .get(
        Uri.parse(url),
        headers: headers,
      )
          .timeout(durationTimeout);
      debugPrint(response.body);
      return _result(response);
    } on TimeoutException catch (_) {
      return HttpResult(
        isSuccess: false,
        status: -1,
        result: {},
      );
    } on SocketException catch (_) {
      return HttpResult(
        isSuccess: false,
        status: -1,
        result: {},
      );
    }
  }

  static HttpResult _result(response) {
    int status = response.statusCode ?? 404;

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var result;
      result = json.decode(utf8.decode(response.bodyBytes));
      return HttpResult(
        isSuccess: true,
        status: status,
        result: result,
      );
    } else {
      try {
        var result;
        result = json.decode(utf8.decode(response.bodyBytes));
        return HttpResult(
          isSuccess: false,
          status: status,
          result: result,
        );
      } catch (_) {
        return HttpResult(
          isSuccess: false,
          status: status,
          result: {
            "msg": "Server error, please try again",
          },
        );
      }
    }
  }

  static _getReqHeader() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getString('token') == null) {
      return {
        "Accept": "application/json",
      };
    } else {
      return {
        "Accept": "application/json",
        "Authorization": "Bearer ${prefs.getString('token') ?? ""}",
      };
    }
  }

  /// Register Post
  Future<HttpResult> fetchRegister(
      String phone,
      String password,
      String passwordConfirm,
      String name,
      ) async {
    String url = '$baseUrl/auth/register';

    final data = {
      "phone": phone,
      "password": password,
      "password_confirmation": passwordConfirm,
      "name": name,
    };
    return await postRequest(url, data, false);
  }

  /// Verification Resend Post
  Future<HttpResult> fetchVerificationResend(String phone) async{
    String url = '$baseUrl/auth/resend-code';

    final data = {
      "phone": phone,
    };
    return await postRequest(url, data, false);
  }

  /// Verify Code Post
  Future<HttpResult> fetchVerifyCode(String phone, String code) async{
    String url = '$baseUrl/auth/verify-code';

    final data = {
      "phone": phone,
      "code": code,
    };
    return await postRequest(url, data, false);
  }

  /// Login Post
  Future<HttpResult> fetchLogin(String phone, String password) async{
    String url = '$baseUrl/auth/login';
    final data = {
      "phone": phone,
      "password": password,
    };
    return await postRequest(url, data, false);
  }
}
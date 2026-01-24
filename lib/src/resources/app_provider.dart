import 'dart:async';

import 'dart:io';
import 'package:flutter/cupertino.dart';
// import 'package:http/http.dart' as http; // Removed
import 'package:image/image.dart' as img;
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../model/event_bus/http_result.dart';
import '../model/passenger_model.dart';

class ApiProvider {
  static Duration durationTimeout = const Duration(seconds: 30);
  static String baseUrl = "https://qadam.services/api/v1";

  // --- Helpers ---

  static Future<Map<String, dynamic>> _getReqHeader() async {
    final prefs = await SharedPreferences.getInstance();
    // No Content-Type here by default, let Dio or specific request handle it
    final headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };

    if (prefs.getString('token') != null) {
      headers["Authorization"] = "Bearer ${prefs.getString('token') ?? ""}";
    }
    return headers;
  }

  static HttpResult _handleDioError(DioException e) {
    debugPrint("DioError: ${e.message}");
    debugPrint("DioError Response: ${e.response?.data}");
    if (e.response != null) {
      // Check if response data is usable map
      final result = e.response?.data is Map
          ? e.response?.data
          : {"error": e.response?.data.toString()};
      
      return HttpResult(
        isSuccess: false,
        status: e.response?.statusCode ?? -1,
        result: result,
      );
    } else {
      return HttpResult(
        isSuccess: false,
        status: -1,
        result: {},
      );
    }
  }

  static HttpResult _handleGenericError(Object e) {
    debugPrint("Error: $e");
    return HttpResult(
      isSuccess: false,
      status: -1,
      result: {"error": e.toString()},
    );
  }

   static HttpResult _processResponse(Response response) {
    debugPrint("Response Body: ${response.data}");
    
    // Check for success range
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! <= 299) {
      
      return HttpResult(
        isSuccess: true,
        status: response.statusCode!,
        result: response.data is Map ? response.data : {"data": response.data},
      );
    } else {
      return HttpResult(
        isSuccess: false,
        status: response.statusCode ?? -1,
        result: response.data is Map
            ? response.data
            : {"error": response.data.toString()},
      );
    }
  }

  // --- Core Methods ---

  /// GET Request using Dio
  static Future<HttpResult> getRequest(String url) async {
    debugPrint("GET: $url");
    Dio dio = Dio();
    final headers = await _getReqHeader();
    debugPrint("Headers: $headers");

    try {
      Response response = await dio.get(
        url,
        options: Options(
          headers: headers,
          sendTimeout: durationTimeout,
          receiveTimeout: durationTimeout,
          validateStatus: (status) => true, // Handle status manually
          followRedirects: false,
        ),
      );
      return _processResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return _handleGenericError(e);
    }
  }

  /// POST Request (JSON)
  static Future<HttpResult> postRequest(String url, Map<String, dynamic> body) async {
    debugPrint("POST: $url");
    debugPrint("Body: $body");

    Dio dio = Dio();
    final headers = await _getReqHeader();
    debugPrint("Headers: $headers");

    try {
      Response response = await dio.post(
        url,
        data: body,
        options: Options(
          headers: headers,
          sendTimeout: durationTimeout,
          receiveTimeout: durationTimeout,
          validateStatus: (status) => true,
        ),
      );
      return _processResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return _handleGenericError(e);
    }
  }

  // Legacy postRequest shim (deprecating but keeping if internal usage exists, 
  // though we will replace all calls)
  // Replaced by postFormRequest or postJsonRequest usage below.


  /// Register Post
  Future<HttpResult> fetchRegister(
    String firstName,
    String lastName,
    String fatherName,
    String email,
    String phone,
    String password,
    String passwordConfirm,
  ) async {
    String url = '$baseUrl/auth/register';

    final data = {
      "first_name": firstName,
      "last_name": lastName,
      "father_name": fatherName,
      "email": email,
      "phone": phone,
      "password": password,
      "password_confirmation": passwordConfirm,
    };
    return await postRequest(url, data);
  }

  /// Verification Resend Post
  Future<HttpResult> fetchVerificationResend(String phone) async {
    String url = '$baseUrl/auth/resend-code';

    final data = {
      "phone": phone,
    };
    return await postRequest(url, data);
  }

  /// Verify Code Post
  Future<HttpResult> fetchVerifyCode(String phone, String code) async {
    String url = '$baseUrl/auth/verify-code';

    final data = {
      "phone": phone,
      "code": code,
    };
    return await postRequest(url, data);
  }

  /// Login Post
  Future<HttpResult> fetchLogin(String phone, String password) async {
    String url = '$baseUrl/auth/login';
    if(phone.contains("+") == false){
      phone = "+$phone";
    }

    final data = {
      "phone": phone,
      "password": password,
    };
    return await postRequest(url, data);
  }

  /// Get User Data
  Future<HttpResult> fetchMe() async {
    String url = '$baseUrl/auth/me';
    return await getRequest(url);
  }

  /// Get Trip List
  Future<HttpResult> fetchTripList() async {
    String url = '$baseUrl/public/trips/view';
    return await getRequest(url);
  }

  /// Get Trip Search
  Future<HttpResult> fetchTripSearch(
    String fromVillageId,
    String toVillageId,
    DateTime departureDate,
    DateTime? returnDate,
    bool? isRoundTrip,
  ) async {
    isRoundTrip ??= false;
    String returnDateStr = "";
    if (returnDate != null) {
      returnDateStr = returnDate.toIso8601String();
    } else {
      returnDateStr = "";
    }

    String url =
        '$baseUrl/public/trips/search/available-trips?start_quarter_id=$fromVillageId&end_quarter_id=$toVillageId&departure_date=${departureDate.toIso8601String()}&return_date=$returnDateStr&is_round_trip=$isRoundTrip';
    return await getRequest(url);
  }


  /// Top Up Balance Post
  Future<HttpResult> fetchTopUp(String amount) async {
    String url = '$baseUrl/auth/fill-balance';

    final data = {
      "amount": amount,
    };
    return await postRequest(url, data);
  }

  /// Book A Trip Post
  Future<HttpResult> fetchBookTrip(
      String tripId, List<PassengerModel> passengers) async {
    String url = '$baseUrl/client/booking';

    final data = {
      "trip_id": int.parse(tripId),
      "passengers": passengers
          .map((e) => {
                "name": e.fullName,
                "phone": e.phoneNumber,
              })
          .toList(),
    };
    debugPrint(url);
    debugPrint("Post: ${data.toString()}");
    
    return await postRequest(url, data);
  }

  /// Get Booked Trips List
  Future<HttpResult> fetchBookedTripsList() async {
    String url = '$baseUrl/client/booking';
    return await getRequest(url);
  }

  Future<File> _resizeImage(File file,
      {int maxWidth = 480, int quality = 80}) async {
    final bytes = await file.readAsBytes();
    img.Image? image =
        img.decodeImage(bytes); // return original if decoding fails

    // Resize proportionally if wider than maxWidth
    if (image!.width > maxWidth) {
      image = img.copyResize(image, width: maxWidth);
    }

    // Encode as JPEG with compression
    final resizedBytes = img.encodeJpg(image, quality: quality);

    // Save into a temporary file
    final tempDir = Directory.systemTemp;
    final resizedFile = File(
      '${tempDir.path}/resized_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
    await resizedFile.writeAsBytes(resizedBytes, flush: true);

    return resizedFile;
  }

  ///Driving Licence Front Upload
  Future<HttpResult> fetchDrivingFrontUpload(String path) async {
    String url = '$baseUrl/auth/upload-driver-passport-driving-licence';

    final prefs = await SharedPreferences.getInstance();
    Dio dio = Dio();
    final dynamic headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${prefs.getString('token') ?? ""}",
    };

    File? fileToUpload;
    if (path.isNotEmpty) {
      final originalFile = File(path);
      fileToUpload =
          await _resizeImage(originalFile, maxWidth: 480, quality: 80);
    }

    FormData formData = FormData.fromMap({
      "driving_licence_front": path.isEmpty
          ? path
          : await MultipartFile.fromFile(
              fileToUpload!.path,
              filename: basename(fileToUpload.path),
            ),
    });

    Response response = await dio.post(
      url,
      data: formData,
      options: Options(headers: headers),
      onSendProgress: (int sent, int total) {
        String percentage = (sent / total * 100).toStringAsFixed(2);
        debugPrint("$sent Bytes of $total Bytes - $percentage % uploaded");
      },
    );

    debugPrint("Response: ${response.data}");

    if (response.statusCode == 200) {
      return HttpResult(
        isSuccess: true,
        status: response.statusCode!,
        result: response.data,
      );
    }
    return HttpResult(
      isSuccess: false,
      status: -1,
      result: {},
    );
  }

  ///Driving Licence Back Upload
  Future<HttpResult> fetchDrivingBackUpload(String path) async {
    String url = '$baseUrl/auth/upload-driver-passport-driving-licence';

    final prefs = await SharedPreferences.getInstance();
    Dio dio = Dio();
    final dynamic headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${prefs.getString('token') ?? ""}",
    };

    File? fileToUpload;
    if (path.isNotEmpty) {
      final originalFile = File(path);
      fileToUpload =
          await _resizeImage(originalFile, maxWidth: 480, quality: 80);
    }

    FormData formData = FormData.fromMap({
      "driving_licence_back": path.isEmpty
          ? path
          : await MultipartFile.fromFile(
              fileToUpload!.path,
              filename: basename(fileToUpload.path),
            ),
    });

    Response response = await dio.post(
      url,
      data: formData,
      options: Options(headers: headers),
      onSendProgress: (int sent, int total) {
        String percentage = (sent / total * 100).toStringAsFixed(2);
        debugPrint("$sent Bytes of $total Bytes - $percentage % uploaded");
      },
    );

    debugPrint("Response: ${response.data}");

    if (response.statusCode == 200) {
      return HttpResult(
        isSuccess: true,
        status: response.statusCode!,
        result: response.data,
      );
    }
    return HttpResult(
      isSuccess: false,
      status: -1,
      result: {},
    );
  }

  ///Passport Upload
  Future<HttpResult> fetchPassportUpload(String path) async {
    String url = '$baseUrl/auth/upload-driver-passport-driving-licence';

    final prefs = await SharedPreferences.getInstance();
    Dio dio = Dio();
    final dynamic headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${prefs.getString('token') ?? ""}",
    };

    File? fileToUpload;
    if (path.isNotEmpty) {
      final originalFile = File(path);
      fileToUpload =
          await _resizeImage(originalFile, maxWidth: 480, quality: 80);
    }

    FormData formData = FormData.fromMap({
      "driver_passport_image": path.isEmpty
          ? path
          : await MultipartFile.fromFile(
              fileToUpload!.path,
              filename: basename(fileToUpload.path),
            ),
    });

    Response response = await dio.post(
      url,
      data: formData,
      options: Options(headers: headers),
      onSendProgress: (int sent, int total) {
        String percentage = (sent / total * 100).toStringAsFixed(2);
        debugPrint("$sent Bytes of $total Bytes - $percentage % uploaded");
      },
    );

    debugPrint("Response: ${response.data}");

    if (response.statusCode == 200) {
      return HttpResult(
        isSuccess: true,
        status: response.statusCode!,
        result: response.data,
      );
    }
    return HttpResult(
      isSuccess: false,
      status: -1,
      result: {},
    );
  }

  /// Apply for Driver Post
  Future<HttpResult> fetchApplyDriver(
    String drivingLicenceNumber,
    DateTime expiryDate,
    DateTime birthDate,
  ) async {
    String url = '$baseUrl/auth/become-a-driver';
    String expiryDateStr = '${expiryDate.day},${expiryDate.month},${expiryDate.year}';
    String birthDateStr = '${birthDate.day},${birthDate.month},${birthDate.year}';
    final data = {
      "driving_license_number": drivingLicenceNumber,
      "driving_license_expiration_date": expiryDateStr,
      "birthday": birthDateStr,
    };
    return await postRequest(url, data);
  }

  /// Add Vehicle Info Post
  Future<HttpResult> fetchAddVehicleInfo(
      String vehicleNumber,
      String vehicleModel,
      int vehicleColorId,
      String vehicleTechPassport,
      int seats,
      ) async {
    String url = '$baseUrl/vehicles';
    final data = {
      "vehicle_number": vehicleNumber,
      "car_model": vehicleModel,
      "car_color_id": vehicleColorId,
      "tech_passport_number": vehicleTechPassport,
      "seats": seats,
    };
    return await postRequest(url, data);
  }

  /// Verify Driver Post
  Future<HttpResult> fetchVerifyDriver(String userId) async {
    String url = '$baseUrl/auth/approve-driver';

    final data = {
      "user_id": userId,
    };
    return await postRequest(url, data);
  }

  /// Upload Car Images
  Future<HttpResult> fetchUploadCarImages(
      String vehicleId,
      String techPassportFront,
      String techPassportBack,
      List<String> carImages,
      ) async {
    String url = '$baseUrl/auth/upload-car-images';

    final prefs = await SharedPreferences.getInstance();
    Dio dio = Dio();
    final dynamic headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${prefs.getString('token') ?? ""}",
    };

    // Prepare files
    Map<String, dynamic> bodyMap = {
      'vehicle_id': vehicleId,
    };

    try {
      // --- START: Image Compression Logic ---
      if (techPassportFront.isNotEmpty) {
        File resizedFront = await _resizeImage(File(techPassportFront));
        bodyMap['tech_passport_front'] = await MultipartFile.fromFile(
          resizedFront.path,
          filename: basename(resizedFront.path),
        );
      }
      if (techPassportBack.isNotEmpty) {
        File resizedBack = await _resizeImage(File(techPassportBack));
        bodyMap['tech_passport_back'] = await MultipartFile.fromFile(
          resizedBack.path,
          filename: basename(resizedBack.path),
        );
      }

      if (carImages.isNotEmpty) {
        List<MultipartFile> carFiles = [];
        for (var path in carImages) {
          File resizedCarImage = await _resizeImage(File(path));
          carFiles.add(await MultipartFile.fromFile(
              resizedCarImage.path,
              filename: basename(resizedCarImage.path)
          ));
        }
        bodyMap['car_images[]'] = carFiles;
      }

      FormData formData = FormData.fromMap(bodyMap);

      debugPrint("POST Multipart: $url");
      debugPrint("Body Keys: ${bodyMap.keys}");

      Response response = await dio.post(
        url,
        data: formData,
        options: Options(
          headers: headers,
          validateStatus: (status) => true, // Handle status manually
        ),
      );
      return _processResponse(response);
    } on DioException catch (e) {
      // Specific handling for the 413 error if it still occurs
      if (e.response?.statusCode == 413) {
        debugPrint("DioError 413: Image(s) still too large after compression.");
        return HttpResult(
          isSuccess: false,
          status: 413,
          result: {"error": "Image file is too large."},
        );
      }
      return _handleDioError(e);
    } catch (e) {
      return _handleGenericError(e);
    }
  }

  /// Create Trip Post
  Future<HttpResult> fetchCreateTrip(
      String vehicleId,
      DateTime startDate,
      DateTime endDate,
      String pricePerSeat,
      String availableSeats,
      String startLat,
      String startLong,
      String endLat,
      String endLong,
      String startRegionId,
      String startDistrictId,
      String startQuarterId,
      String endRegionId,
      String endDistrictId,
      String endQuarterId,
      ) async {
    String url = '$baseUrl/driver/trips';
    final data = {
      "vehicle_id": vehicleId,
      "start_time": startDate.toIso8601String(),
      "end_time": endDate.toIso8601String(),
      "start_region_id": startRegionId,
      "start_district_id": startDistrictId,
      "start_quarter_id": startQuarterId,
      "end_region_id": endRegionId,
      "end_district_id": endDistrictId,
      "end_quarter_id": endQuarterId,
      "price_per_seat": pricePerSeat,
      "available_seats": availableSeats,
      "start_lat": startLat,
      "start_long": startLong,
      "end_lat": endLat,
      "end_long": endLong,
    };
    return await postRequest(url, data);
  }

  /// Get One Driver Trip
  Future<HttpResult> fetchOneDriverTrip(String tripId) async {
    String url = '$baseUrl/driver/trips/$tripId';
    return await getRequest(url);
  }

  /// Get Card List
  Future<HttpResult> fetchCardList() async {
    String url = '$baseUrl/bank/my-registered-cards/';
    return await getRequest(url);
  }

  /// Add Credit Card Post (Updated)
  Future<HttpResult> fetchAddCreditCard(
      String cardNumber, String expiry, String phone, String holderName) async {
    String url = '$baseUrl/bank/add-card';
    final data = {
      "number": cardNumber,
      "expiry": expiry,
      "phone": phone,
      "holder_name": holderName,
    };
    return await postRequest(url, data);
  }

  /// Verify Card Post
  Future<HttpResult> fetchVerifyCard(
      int id, String cardKey, String confirmCode) async {
    String url = '$baseUrl/bank/verify-card';
    final data = {
      "id": id.toString(),
      "card_key": cardKey,
      "confirm_code": confirmCode,
    };
    return await postRequest(url, data);
  }
  
  /// Create Payment (Fill Balance)
  Future<HttpResult> fetchCreatePayment(String amount, {String? cardId}) async {
    String url = '$baseUrl/bank/create-payment';
    final data = {
      "amount": amount,
      if (cardId != null) "card_id": cardId,
    };
    return await postRequest(url, data);
  }

  /// Confirm Payment
  Future<HttpResult> fetchConfirmPayment(String payId, String confirmCode) async {
    String url = '$baseUrl/bank/confirm-payment';
    final data = {
      "pay_id": payId,
      "confirm_code": confirmCode,
    };
    return await postRequest(url, data);
  }

  /// Get Transaction List
  Future<HttpResult> fetchTransactionList() async {
    String url = '$baseUrl/user/balance-transactions';
    return await getRequest(url);
  }

  /// Get My Vehicles
  Future<HttpResult> fetchVehiclesList() async {
    String url = '$baseUrl/vehicles';
    return await getRequest(url);
  }

  /// Get All Driver Trips
  Future<HttpResult> fetchDriverTripsList(String action) async {
    String getDriverTripsUrl(String action) {
      const basePath = '/driver/trips';

      switch (action.toLowerCase()) {
        case 'completed':
          return '$basePath/get-completed-trips/driver';
        case 'canceled':
          return '$basePath/get-canceled-trips/driver';
        case 'active':
          return '$basePath/get-active-trips/driver';
        case 'all':
        default:
          return basePath;
      }
    }

    final String url = '$baseUrl${getDriverTripsUrl(action)}';

    return await getRequest(url);
  }
}

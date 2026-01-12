import 'package:qadam/src/model/api/user_model.dart';
import 'package:qadam/src/model/event_bus/http_result.dart';

import '../model/api/get_user_model.dart';
import '../model/passenger_model.dart';
import '../utils/cache.dart';
import 'app_provider.dart';

class Repository {
  final apiProvider = ApiProvider();
  final appCache = AppCache();

  Future<HttpResult> fetchRegister(
    String firstName,
    String lastName,
    String fatherName,
    String email,
    String phone,
    String password,
    String passwordConfirm,
  ) =>
      apiProvider.fetchRegister(
        firstName,
        lastName,
        fatherName,
        email,
        phone,
        password,
        passwordConfirm,
      );

  Future<HttpResult> fetchVerificationResend(String phone) =>
      apiProvider.fetchVerificationResend(phone);

  Future<HttpResult> fetchVerifyCode(String phone, String code) =>
      apiProvider.fetchVerifyCode(phone, code);

  Future<HttpResult> fetchLogin(String phone, String password) =>
      apiProvider.fetchLogin(phone, password);

  Future<HttpResult> fetchMe() => apiProvider.fetchMe();

  Future<HttpResult> fetchTripList() => apiProvider.fetchTripList();

  Future<HttpResult> fetchTripSearch(
    String fromVillageId,
    String toVillageId,
    DateTime departureDate,
    DateTime? returnDate,
    bool? isRoundTrip,
  ) =>
      apiProvider.fetchTripSearch(
        fromVillageId,
        toVillageId,
        departureDate,
        returnDate,
        isRoundTrip,
      );

  Future<HttpResult> fetchTopUp(String amount) =>
      apiProvider.fetchTopUp(amount);

  Future<HttpResult> fetchBookTrip(
    String tripId,
    List<PassengerModel> passengers,
  ) =>
      apiProvider.fetchBookTrip(
        tripId,
        passengers,
      );

  Future<HttpResult> fetchBookedTripsList() =>
      apiProvider.fetchBookedTripsList();

  Future<HttpResult> fetchDrivingFrontUpload(String path) =>
      apiProvider.fetchDrivingFrontUpload(path);

  Future<HttpResult> fetchDrivingBackUpload(String path) =>
      apiProvider.fetchDrivingBackUpload(path);

  Future<HttpResult> fetchPassportUpload(String path) =>
      apiProvider.fetchPassportUpload(path);

  Future<HttpResult> fetchApplyDriver(
    String drivingLicenceNumber,
    DateTime expiryDate,
    DateTime birthDate,
  ) =>
      apiProvider.fetchApplyDriver(
        drivingLicenceNumber,
        expiryDate,
        birthDate,
      );

  Future<HttpResult> fetchAddVehicleInfo(
    String vehicleNumber,
    String vehicleModel,
    int vehicleColorId,
    String vehicleTechPassport,
    int seats,
  ) =>
      apiProvider.fetchAddVehicleInfo(
        vehicleNumber,
        vehicleModel,
        vehicleColorId,
        vehicleTechPassport,
        seats,
      );

  Future<HttpResult> fetchUploadCarImages(
    String vehicleId,
    String techPassportFront,
    String techPassportBack,
    List<String> carImages,
  ) =>
      apiProvider.fetchUploadCarImages(
        vehicleId,
        techPassportFront,
        techPassportBack,
        carImages,
      );

  Future<HttpResult> fetchVerifyDriver(String userId) =>
      apiProvider.fetchVerifyDriver(userId);

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
  ) =>
      apiProvider.fetchCreateTrip(
        vehicleId,
        startDate,
        endDate,
        pricePerSeat,
        availableSeats,
        startLat,
        startLong,
        endLat,
        endLong,
        startRegionId,
        startDistrictId,
        startQuarterId,
        endRegionId,
        endDistrictId,
        endQuarterId,
      );

  Future<HttpResult> fetchOneDriverTrip(String tripId) =>
      apiProvider.fetchOneDriverTrip(tripId);

  Future<HttpResult> fetchCardList() => apiProvider.fetchCardList();

  Future<HttpResult> fetchAddCreditCard(
    String cardNumber,
    String expiry,
    String phone,
    String holderName,
  ) =>
      apiProvider.fetchAddCreditCard(
        cardNumber,
        expiry,
        phone,
        holderName,
      );

  Future<HttpResult> fetchVerifyCard(
          int id, String cardKey, String confirmCode) =>
      apiProvider.fetchVerifyCard(id, cardKey, confirmCode);

  Future<HttpResult> fetchCreatePayment(String amount, {String? cardId}) =>
      apiProvider.fetchCreatePayment(amount, cardId: cardId);

  Future<HttpResult> fetchConfirmPayment(String payId, String confirmCode) =>
      apiProvider.fetchConfirmPayment(payId, confirmCode);

  Future<HttpResult> fetchTransactionList() =>
      apiProvider.fetchTransactionList();

  Future<HttpResult> fetchVehiclesList() => apiProvider.fetchVehiclesList();

  Future<void> cacheLoginUser(UserModel user) => appCache.saveLoginUser(user);

  Future<void> cacheSetMe(User user) => appCache.saveUser(user);

  Future<User> cacheGetMe() => appCache.cacheGetMe();
}

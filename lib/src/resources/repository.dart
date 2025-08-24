import 'package:qadam/src/model/api/user_model.dart';
import 'package:qadam/src/model/event_bus/http_result.dart';

import '../model/api/get_user.model.dart';
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

  Future<void> cacheLoginUser(UserModel user) => appCache.saveLoginUser(user);

  Future<void> cacheSetMe(User user) => appCache.saveUser(user);

  Future<User> cacheGetMe() => appCache.cacheGetMe();
}

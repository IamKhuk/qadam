import 'package:qadam/src/model/api/user_model.dart';
import 'package:qadam/src/model/event_bus/http_result.dart';

import '../utils/cache.dart';
import 'app_provider.dart';

class Repository {
  final apiProvider = ApiProvider();
  final appCache = AppCache();

  Future<HttpResult> fetchRegister(
    String phone,
    String password,
    String passwordConfirm,
    String name,
  ) =>
      apiProvider.fetchRegister(
        phone,
        password,
        passwordConfirm,
        name,
      );

  Future<HttpResult> fetchVerificationResend(String phone) =>
      apiProvider.fetchVerificationResend(phone);

  Future<HttpResult> fetchVerifyCode(String phone, String code) =>
      apiProvider.fetchVerifyCode(phone, code);

  Future<HttpResult> fetchLogin(String phone, String password) =>
      apiProvider.fetchLogin(phone, password);

  Future<void> cacheLoginUser(UserModel user) => appCache.saveLoginUser(user);
}

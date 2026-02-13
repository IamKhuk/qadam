import 'package:qadam/src/model/api/get_user_model.dart';
import 'package:rxdart/rxdart.dart';

import '../resources/repository.dart';
import 'bloc_errors.dart';

class ProfileBloc {
  final Repository _repository = Repository();

  final _infoFetcher = PublishSubject<User>();
  final _infoCacheFetcher = PublishSubject<User>();
  final _errorFetcher = PublishSubject<String>();

  Stream<User> get getInfo => _infoFetcher.stream;
  Stream<User> get getInfoCache => _infoCacheFetcher.stream;
  Stream<String> get getError => _errorFetcher.stream;

  fetchMe() async {
    try {
      var response = await _repository.fetchMe();
      if (response.isSuccess) {
        if (response.result is Map<String, dynamic>) {
          GetUserModel result = GetUserModel.fromJson(response.result);
          if (result.status == "success") {
            _repository.cacheSetMe(result.user);
            _infoFetcher.sink.add(result.user);
          } else {
            _errorFetcher.sink.add(BlocErrors.serverError);
          }
        } else {
          _errorFetcher.sink.add(BlocErrors.unexpectedFormat);
        }
      } else if (response.status == -1) {
        _errorFetcher.sink.add(BlocErrors.noInternet);
      } else {
        _errorFetcher.sink.add(BlocErrors.serverError);
      }
    } catch (e) {
      _errorFetcher.sink.add(BlocErrors.somethingWentWrong);
    }
  }

  fetchUpdateInfo(GetUserModel data) async {
    _repository.cacheSetMe(data.user);
    _infoFetcher.sink.add(data.user);
  }

  fetchMeCache() async {
    try {
      User response = await _repository.cacheGetMe();
      _infoCacheFetcher.sink.add(response);
    } catch (e) {
      _errorFetcher.sink.add(BlocErrors.somethingWentWrong);
    }
  }

  void dispose() {
    _infoFetcher.close();
    _infoCacheFetcher.close();
    _errorFetcher.close();
  }
}

ProfileBloc _blocProfile = ProfileBloc();
ProfileBloc get blocProfile => _blocProfile;

void resetProfileBloc() {
  _blocProfile.dispose();
  _blocProfile = ProfileBloc();
}
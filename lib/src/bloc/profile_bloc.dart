import 'package:qadam/src/model/api/get_user.model.dart';
import 'package:rxdart/rxdart.dart';

import '../resources/repository.dart';

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
        GetUserModel result = GetUserModel.fromJson(response.result);
        if (result.status == "success") {
          _repository.cacheSetMe(result.user);
          _infoFetcher.sink.add(result.user);
        } else {
          _errorFetcher.sink.add("Failed to load user data: ${result.status}");
        }
      } else if (response.status == -1) {
        _errorFetcher.sink.add("No internet connection. Please check your network.");
      } else {
        _errorFetcher.sink.add("Server error: 'Unknown server error'");
      }
    } catch (e) {
      _errorFetcher.sink.add("Unexpected error: ${e.toString()}");
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
      _errorFetcher.sink.add("Failed to load cached user data.");
    }
  }

  dispose() {
    _infoFetcher.close();
    _infoCacheFetcher.close();
    _errorFetcher.close();
  }
}

final blocProfile = ProfileBloc();
import 'package:qadam/src/model/api/created_trip_model.dart';
import 'package:qadam/src/model/api/trip_search_model.dart';
import 'package:rxdart/rxdart.dart';

import '../model/api/trip_list_model.dart';
import '../resources/repository.dart';
import 'bloc_errors.dart';

class HomeBloc {
  final Repository _repository = Repository();

  final _infoTripsFetcher = BehaviorSubject<List<TripListModel>>();
  final _infoTripSearchFetcher = PublishSubject<TripSearchModel>();
  final _infoOneDriverTripFetcher = PublishSubject<CreatedTripResponseModel>();
  final _infoOneBookedTripFetcher = PublishSubject<TripListModel>();
  final _errorFetcher = PublishSubject<String>();

  Stream<List<TripListModel>> get getTrips => _infoTripsFetcher.stream;
  Stream<TripSearchModel> get getTripSearch => _infoTripSearchFetcher.stream;
  Stream<CreatedTripResponseModel> get getOneDriverTrip => _infoOneDriverTripFetcher.stream;
  Stream<TripListModel> get getOneBookedTrip => _infoOneBookedTripFetcher.stream;
  Stream<String> get getError => _errorFetcher.stream;

  fetchTripList() async {
    try {
      var response = await _repository.fetchTripList();
      if (response.isSuccess) {
        var data = response.result;
        if (data is Map && data.containsKey('data')) {
          data = data['data'];
        }
        if (data is List) {
          List<TripListModel> result = data
              .whereType<Map<String, dynamic>>()
              .map((item) => TripListModel.fromJson(item))
              .toList();
          _infoTripsFetcher.sink.add(result);
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

  fetchTripSearch(
    String fromVillageId,
    String toVillageId,
    DateTime departureDate,
    DateTime? returnDate,
    bool? isRoundTrip,
  ) async {
    try {
      var response = await _repository.fetchTripSearch(
        fromVillageId,
        toVillageId,
        departureDate,
        returnDate,
        isRoundTrip,
      );
      if (response.isSuccess) {
        if (response.result is Map<String, dynamic>) {
          TripSearchModel result = TripSearchModel.fromJson(response.result);
          _infoTripSearchFetcher.sink.add(result);
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

  fetchOneDriverTrip(
      String tripId,
      ) async {
    try {
      var response = await _repository.fetchOneDriverTrip(tripId);
      if (response.isSuccess) {
        if (response.result is Map<String, dynamic>) {
          CreatedTripResponseModel result =
              CreatedTripResponseModel.fromJson(response.result);
          _infoOneDriverTripFetcher.sink.add(result);
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

  fetchOneBookedTrip(
      String tripId,
      ) async {
    try {
      var response = await _repository.fetchOneBookedTrip(tripId);
      if (response.isSuccess) {
        if (response.result is Map<String, dynamic>) {
          TripListModel result = TripListModel.fromJson(response.result);
          _infoOneBookedTripFetcher.sink.add(result);
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

  void dispose() {
    _infoTripsFetcher.close();
    _infoTripSearchFetcher.close();
    _infoOneDriverTripFetcher.close();
    _infoOneBookedTripFetcher.close();
    _errorFetcher.close();
  }
}

HomeBloc _blocHome = HomeBloc();
HomeBloc get blocHome => _blocHome;

void resetHomeBloc() {
  _blocHome.dispose();
  _blocHome = HomeBloc();
}

import 'package:qadam/src/model/api/created_trip_model.dart';
import 'package:qadam/src/model/api/trip_search_model.dart';
import 'package:rxdart/rxdart.dart';

import '../model/api/trip_list_model.dart';
import '../resources/repository.dart';

class HomeBloc {
  final Repository _repository = Repository();

  final _infoTripsFetcher = PublishSubject<List<TripListModel>>();
  final _infoTripSearchFetcher = PublishSubject<TripSearchModel>();
  final _infoOneDriverTripFetcher = PublishSubject<CreatedTripResponseModel>();
  final _errorFetcher = PublishSubject<String>();

  Stream<List<TripListModel>> get getTrips => _infoTripsFetcher.stream;
  Stream<TripSearchModel> get getTripSearch => _infoTripSearchFetcher.stream;
  Stream<CreatedTripResponseModel> get getOneDriverTrip => _infoOneDriverTripFetcher.stream;
  Stream<String> get getError => _errorFetcher.stream;

  fetchTripList() async {
    try{
      var response = await _repository.fetchTripList();
      if (response.isSuccess) {
        List<TripListModel> result = (response.result as List)
            .map((item) => TripListModel.fromJson(item))
            .toList();
        _infoTripsFetcher.sink.add(result);
      } else if (response.status == -1) {
        _errorFetcher.sink.add("No internet connection. Please check your network.");
      } else {
        _errorFetcher.sink.add("Server error: 'Unknown server error'");
      }
    }catch(e){
      _errorFetcher.sink.add("Unexpected error: ${e.toString()}");
    }
  }

  fetchTripSearch(
    String fromVillageId,
    String toVillageId,
    DateTime departureDate,
    DateTime? returnDate,
    bool? isRoundTrip,
  ) async {
    try{
      var response = await _repository.fetchTripSearch(
        fromVillageId,
        toVillageId,
        departureDate,
        returnDate,
        isRoundTrip,
      );
      if (response.isSuccess) {
        TripSearchModel result = TripSearchModel.fromJson(response.result);
        _infoTripSearchFetcher.sink.add(result);
      } else if (response.status == -1) {
        _errorFetcher.sink.add("No internet connection. Please check your network.");
      } else {
        _errorFetcher.sink.add("Server error: 'Unknown server error'");
      }
    }catch (e){
      _errorFetcher.sink.add("Unexpected error: ${e.toString()}");
    }
  }

  fetchOneDriverTrip(
      String tripId,
      ) async {
    try{
      var response = await _repository.fetchOneDriverTrip(tripId);
      if (response.isSuccess) {
        CreatedTripResponseModel result = CreatedTripResponseModel.fromJson(response.result);
        _infoOneDriverTripFetcher.sink.add(result);
      } else if (response.status == -1) {
        _errorFetcher.sink.add("No internet connection. Please check your network.");
      } else {
        _errorFetcher.sink.add("Server error: 'Unknown server error'");
      }
    }catch (e){
      _errorFetcher.sink.add("Unexpected error: ${e.toString()}");
    }
  }

  dispose() {
    _infoTripsFetcher.close();
    _infoTripSearchFetcher.close();
    _infoOneDriverTripFetcher.close();
    _errorFetcher.close();
  }
}

final blocHome = HomeBloc();

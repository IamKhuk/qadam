import 'package:qadam/src/model/api/created_trip_model.dart';
import 'package:qadam/src/model/api/driver_trips_list_model.dart';
import 'package:qadam/src/model/api/trip_search_model.dart';
import 'package:rxdart/rxdart.dart';

import '../model/api/trip_list_model.dart';
import '../resources/repository.dart';

class QadamBloc {
  final Repository _repository = Repository();

  final _infoTripsFetcher = BehaviorSubject<List<DriverTripModel>>();
  final _errorFetcher = PublishSubject<String>();

  Stream<List<DriverTripModel>> get getTrips => _infoTripsFetcher.stream;
  Stream<String> get getError => _errorFetcher.stream;

  fetchDriverTripList(String status) async {
    _infoTripsFetcher.sink.add([]);
    try{
      var response = await _repository.fetchDriverTripsList(status);
      if (response.isSuccess) {
        var dataList = DriverTripsListModel.fromJson(response.result);
        _infoTripsFetcher.sink.add(dataList.data);
      } else if (response.status == -1) {
        _errorFetcher.sink.add("No internet connection. Please check your network.");
      } else {
        _errorFetcher.sink.add("Server error: 'Unknown server error'");
      }
    }catch(e){
      _errorFetcher.sink.add("Unexpected error: ${e.toString()}");
    }
  }

  dispose() {
    _infoTripsFetcher.close();
    _errorFetcher.close();
  }
}

final blocQadam = QadamBloc();

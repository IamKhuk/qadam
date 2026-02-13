import 'package:qadam/src/model/api/driver_trips_list_model.dart';
import 'package:rxdart/rxdart.dart';

import '../resources/repository.dart';
import 'bloc_errors.dart';

class QadamBloc {
  final Repository _repository = Repository();

  final _infoTripsFetcher = BehaviorSubject<List<DriverTripModel>>();
  final _errorFetcher = PublishSubject<String>();

  Stream<List<DriverTripModel>> get getTrips => _infoTripsFetcher.stream;
  Stream<String> get getError => _errorFetcher.stream;

  fetchDriverTripList(String status) async {
    _infoTripsFetcher.sink.add([]);
    try {
      var response = await _repository.fetchDriverTripsList(status);
      if (response.isSuccess) {
        if (response.result is Map<String, dynamic>) {
          var dataList = DriverTripsListModel.fromJson(response.result);
          _infoTripsFetcher.sink.add(dataList.data);
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
    _errorFetcher.close();
  }
}

QadamBloc _blocQadam = QadamBloc();
QadamBloc get blocQadam => _blocQadam;

void resetQadamBloc() {
  _blocQadam.dispose();
  _blocQadam = QadamBloc();
}

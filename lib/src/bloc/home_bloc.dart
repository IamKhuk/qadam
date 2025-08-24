import 'package:rxdart/rxdart.dart';

import '../model/api/trip_list_model.dart';
import '../resources/repository.dart';

class HomeBloc {
  final Repository _repository = Repository();

  final _infoTripsFetcher = PublishSubject<List<TripListModel>>();

  Stream<List<TripListModel>> get getDocs => _infoTripsFetcher.stream;

  fetchDocList() async {
    var response = await _repository.fetchTripList();
    if (response.isSuccess) {
      List<TripListModel> result = (response.result as List)
          .map((item) => TripListModel.fromJson(item))
          .toList();
      _infoTripsFetcher.sink.add(result);
    }
  }

  dispose() {
    _infoTripsFetcher.close();
  }
}

final blocHome = HomeBloc();
import 'package:qadam/src/model/api/book_list_model.dart';
import 'package:qadam/src/model/api/book_model.dart';
import 'package:rxdart/rxdart.dart';

import '../model/event_bus/http_result.dart';
import '../resources/repository.dart';
import 'bloc_errors.dart';

class HistoryBloc {
  final Repository _repository = Repository();

  final _infoBookingsFetcher = BehaviorSubject<List<BookModel>>();
  final _loadingFetcher = BehaviorSubject<bool>.seeded(false);
  final _errorFetcher = PublishSubject<String>();

  Stream<List<BookModel>> get getBookings => _infoBookingsFetcher.stream;
  Stream<bool> get getLoading => _loadingFetcher.stream;
  Stream<String> get getError => _errorFetcher.stream;

  Future<void> fetchBookingsByStatus(int status) async {
    _loadingFetcher.sink.add(true);
    try {
      HttpResult response;
      switch (status) {
        case 0:
          response = await _repository.fetchInProgressTrips();
          break;
        case 1:
          response = await _repository.fetchCompletedTrips();
          break;
        case 2:
          response = await _repository.fetchCanceledTrips();
          break;
        default:
          response = await _repository.fetchInProgressTrips();
      }

      if (response.isSuccess) {
        if (response.result is Map<String, dynamic>) {
          var dataList = BookListModel.fromJson(response.result);
          _infoBookingsFetcher.sink.add(dataList.data);
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
    } finally {
      _loadingFetcher.sink.add(false);
    }
  }

  void dispose() {
    _infoBookingsFetcher.close();
    _loadingFetcher.close();
    _errorFetcher.close();
  }
}

HistoryBloc _blocHistory = HistoryBloc();
HistoryBloc get blocHistory => _blocHistory;

void resetHistoryBloc() {
  _blocHistory.dispose();
  _blocHistory = HistoryBloc();
}

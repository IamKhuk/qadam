import 'dart:convert';

import 'package:qadam/src/model/api/trip_list_model.dart';

TripSearchModel tripSearchModelFromJson(String str) => TripSearchModel.fromJson(json.decode(str));

String tripSearchModelToJson(TripSearchModel data) => json.encode(data.toJson());

class TripSearchModel {
  List<TripListModel> departureTrips;
  List<TripListModel> returnTrips;

  TripSearchModel({
    required this.departureTrips,
    required this.returnTrips,
  });

  factory TripSearchModel.fromJson(Map<String, dynamic> json) => TripSearchModel(
    departureTrips: List<TripListModel>.from(json["departure_trips"].map((x) => TripListModel.fromJson(x))),
    returnTrips: List<TripListModel>.from(json["return_trips"].map((x) => TripListModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "departure_trips": List<dynamic>.from(departureTrips.map((x) => x.toJson())),
    "return_trips": List<dynamic>.from(returnTrips.map((x) => x.toJson())),
  };
}
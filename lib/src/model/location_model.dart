class LocationModel {
  int id;
  String text;
  int parentID;

  LocationModel({
    required this.id,
    required this.text,
    this.parentID = 0,
  });
}

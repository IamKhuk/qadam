class PassengerInfoModel {
  String fullName;
  String phone;
  int numberOfSeats;

  PassengerInfoModel({
    required this.fullName,
    required this.phone,
    this.numberOfSeats = 1,
  });
}

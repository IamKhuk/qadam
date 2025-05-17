class PassengerModel {
  String fullName;
  String email;
  String phoneNumber;

  PassengerModel({
    required this.fullName,
    this.email = "",
    this.phoneNumber = "",
  });
}

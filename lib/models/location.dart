import 'package:pass_slip_management/models/auth.dart';

class LocationModel{
  String latitude;
  String longitude;

  LocationModel({
    this.latitude = "",
    this.longitude = "",
  });

  Map<String, dynamic> toMap() => {
    "firstname": authModel.loggedUser!["firstname"],
    "lastname": authModel.loggedUser!["lastname"],
    "email": authModel.loggedUser!["email"],
    "latitude": latitude,
    "longitude": longitude,
  };
}

final LocationModel locationModel = new LocationModel();
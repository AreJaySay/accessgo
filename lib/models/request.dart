import 'package:pass_slip_management/models/auth.dart';

class RequestModel{
  String date;
  String time;
  String reason;
  String status;
  String expiration;

  RequestModel({
    this.date = "",
    this.reason = "",
    this.time = "",
    this.status = "Pending",
    this.expiration = "NA"
  });

  Map<String, dynamic> toMap({String key = ""}) => {
    if(key == "")...{
      "firstname": authModel.loggedUser!["firstname"],
      "lastname": authModel.loggedUser!["lastname"],
      "email": authModel.loggedUser!["email"],
      "date": date,
      "time": time,
      "reason": reason,
      "status": status,
      "expiration": expiration
    }else...{
      "$key/firstname": authModel.loggedUser!["firstname"],
      "$key/lastname": authModel.loggedUser!["lastname"],
      "$key/email": authModel.loggedUser!["email"],
      "$key/date": date,
      "$key/time": time,
      "$key/reason": reason,
      "$key/status": status,
      "$key/expiration": expiration
    }
  };
}

final RequestModel requestModel = new RequestModel();
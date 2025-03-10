import 'package:pass_slip_management/models/auth.dart';

class RequestModel{
  String employee_name;
  String date;
  String request_type;
  String start_time;
  String end_time;
  String purpose;
  String official_name;
  String reason;

  RequestModel({
    this.employee_name = "",
    this.date = "",
    this.request_type = "",
    this.start_time = "",
    this.end_time = "",
    this.purpose = "",
    this.official_name = "",
    this.reason = "",
  });

  Map<String, dynamic> toMap({String key = ""}) => {
    if(key == "")...{
      "firstname": authModel.loggedUser!["firstname"],
      "lastname": authModel.loggedUser!["lastname"],
      "email": authModel.loggedUser!["email"],
      "date": date,
      "request_type": request_type,
      "start_time": start_time,
      "end_time": end_time,
      "purpose": purpose,
      "official_name": official_name,
      "reason": reason,
      "status": "Pending"
    }else...{
      "$key/firstname": authModel.loggedUser!["firstname"],
      "$key/lastname": authModel.loggedUser!["lastname"],
      "$key/email": authModel.loggedUser!["email"],
      "$key/request_type": request_type,
      "$key/start_time": start_time,
      "$key/end_time": end_time,
      "$key/purpose": purpose,
      "$key/official_name": official_name,
      "$key/reason": reason,
      "status": "Pending"
    }
  };
}

final RequestModel requestModel = new RequestModel();
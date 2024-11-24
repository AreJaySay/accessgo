class RegisterModel{
  String fname;
  String lname;
  String email;
  String phone;
  String gender;
  String address;
  String password;
  String status;

  RegisterModel({
    this.fname = "",
    this.lname = "",
    this.email = "",
    this.phone = "",
    this.gender = "",
    this.address = "",
    this.password = "",
    this.status = "Activate"
  });

  Map<String, dynamic> toMap({String key = ""}) => {
    if(key == "")...{
      "firstname": fname,
      "lastname": lname,
      "email": email,
      "phone number": phone,
      "gender": gender,
      "address": address,
      "password": password,
      "status": status
    }else...{
      "$key/firstname": fname,
      "$key/lastname": lname,
      "$key/email": email,
      "$key/phone number": phone,
      "$key/gender": gender,
      "$key/address": address,
      "$key/password": password,
    }
  };
}

final RegisterModel registerModel = new RegisterModel();
class AuthModel{
  String email;
  String pass;
  String token;
  Map? loggedUser;

  AuthModel({
    this.email = "",
    this.pass = "",
    this.token = "",
    this.loggedUser
  });
}

AuthModel authModel = new AuthModel();
class UserModel {
  String email;
  String password;

  UserModel({required this.email, required this.password});

  bool isValid() {
    return email.isNotEmpty && password.length >= 6;
  }
}

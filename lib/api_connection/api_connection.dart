class API {
  static const hostConnect = "http://192.168.21.55/api_menu";
  static const hostConnectUser = "$hostConnect/user";

  //singUp user
  static const signUp =
      "$hostConnect/user/signup.php"; //perform the sign up functionality for a new user
  static const logIn = "$hostConnect/user/login.php";
  static const validateEmail = "$hostConnect/user/validate_email.php";
}

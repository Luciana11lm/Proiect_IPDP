class API {
  static const hostConnect = "http://192.168.21.55/api_menu";
  static const hostConnectUser = "$hostConnect/user";
  static const hostUploadItem = "$hostConnect/items";

  //singUp user
  static const signUp =
      "$hostConnectUser/signup.php"; //perform the sign up functionality for a new user
  static const logIn = "$hostConnectUser/login.php";
  static const validateEmail = "$hostConnectUser/validate_email.php";

  //save new products to database
  static const uploadNewItem = "$hostUploadItem/upload.php";
}

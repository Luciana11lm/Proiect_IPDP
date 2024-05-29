class API {
  static const hostConnect = "http://192.168.22.130/api_menu";
  static const hostConnectUser = "$hostConnect/user";
  static const hostUploadItem = "$hostConnect/items";
  static const hostProducts = "$hostConnect/products";
  static const hostRestaurant = "$hostConnect/restaurant";
  static const hostCart = "$hostConnect/cart";

  //singUp user
  static const signUp =
      "$hostConnectUser/signup.php"; //perform the sign up functionality for a new user
  static const logIn = "$hostConnectUser/login.php";
  static const validateEmail = "$hostConnectUser/validate_email.php";

  //save new products to database
  static const uploadNewItem = "$hostUploadItem/upload.php";

  // get trending products
  static const getTrendingMostPopularProducts = "$hostProducts/trending.php";
  // get all products
  static const getAllProducts = "$hostProducts/all_products.php";

  //retaurant login
  static const logInRestaurant = "$hostRestaurant/login_restaurant.php";
  // get all products from a restaurant
  static const getRestaurantProductsList = "$hostRestaurant/get_products.php";
  // add orders to database
  static const addToCart = "$hostCart/add.php";
  static const getCartList = "$hostCart/read.php";
  static const addOrderDetails = "$hostCart/add_order_details.php";
}

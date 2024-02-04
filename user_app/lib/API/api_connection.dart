class API {
  static const hostConnect = "http://192.168.18.24/api_takoyakiko_app";
  static const hostConnectUser = "$hostConnect/user";

  static const loginConn = "$hostConnectUser/login.php";
  static const registerConn = "$hostConnectUser/register.php";
  static const addToCart = "$hostConnectUser/addOrder.php";
  static const fetchCart = "$hostConnectUser/fetchCart.php";
  static const deleteCart = "$hostConnectUser/deleteCart.php";
  static const addCheckOut = "$hostConnectUser/addCheckOut.php";
  static const fetchOrder = "$hostConnectUser/fetchOrder.php";
  static const fetchTakoyakiProduct =
      "$hostConnectUser/fetchTakoyakiProduct.php";
  static const fetchBurgerProduct = "$hostConnectUser/fetchBurgerProduct.php";
}

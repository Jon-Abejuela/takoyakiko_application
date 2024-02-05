class API {
  static const hostConnect = "http://192.168.18.24/app_takoyakiko_api/takoyakiko_backend/api_takoyakiko_app";
  static const hostConnectUser = "$hostConnect/admin";

  static const loginConn = "$hostConnectUser/login.php";
  static const productsConn = '$hostConnectUser/products.php';
  static const dashboardItems = '$hostConnectUser/dashboard.php';
  static const fetchOrders = '$hostConnectUser/fetchOrder.php';
  static const updateOrderStatus = '$hostConnectUser/updateOrder.php';
  static const addProduct = '$hostConnectUser/addProduct.php';
  static const fetchProduct = '$hostConnectUser/fetchProductList.php';
  static const deleteProduct = '$hostConnectUser/deleteProduct.php';
  static const updateProduct = '$hostConnectUser/updateProduct.php';
}

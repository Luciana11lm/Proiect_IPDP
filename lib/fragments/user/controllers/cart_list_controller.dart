import 'package:get/get.dart';
import 'package:menu_app/repositories/models/cart.dart';

class CartListController extends GetxController {
  RxList<Cart> _cartlist = <Cart>[].obs; //user all items in the cart
  RxList<int> _selectedItemList = <int>[]
      .obs; // user selected items for whcih user want to place final order
  RxBool _isSelectedAll = false.obs;
  RxDouble _total = 0.0.obs;

  List<Cart> get cartList => _cartlist.value;
  List<int> get selectedItemList => _selectedItemList.value;
  bool get isSelectedAll => _isSelectedAll.value;
  double get total => _total.value;

  setList(List<Cart> list) {
    _cartlist.value = list;
  }

  addSelectedItem(int selectedItemCartID) {
    _selectedItemList.value.add(selectedItemCartID);
    update();
  }

  deleteSelectedItem(int itemSelectedItemCartID) {
    _selectedItemList.value.remove(itemSelectedItemCartID);
    update();
  }

  setIsSelectedAllItems() {
    _isSelectedAll.value = !_isSelectedAll.value;
  }

  clearAllSelectedItems() {
    _selectedItemList.value.clear();
    update();
  }

  setTotal(double overallTotal) {
    _total.value = overallTotal;
  }
}

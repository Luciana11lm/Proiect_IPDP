import 'package:get/get.dart';

class ItemDetailsController extends GetxController {
  final RxInt _quantityItem = 1.obs;
  final RxInt _sizeItem = 0.obs;

  int get quantity => _quantityItem.value;
  int get size => _sizeItem.value;

  setQuantityItem(int quantityOfItem) {
    _quantityItem.value = quantityOfItem;
  }

  setSizeItem(int sizeOfItem) {
    _sizeItem.value = sizeOfItem;
  }
}

import 'package:storeRahisi/models/index.dart';
import 'package:storeRahisi/providers/base_model.dart';

class CartModel extends BaseModel {
  List<Cart> _carts = [];
  List<Cart> get carts => _carts;
  Cart _cart;
  Cart get item => _cart;

  setItem(Item i) {
    bool isItemFound = false;
    if (_carts != null) {
      for (int itemcount = 0; itemcount < _carts.length; itemcount++) {
        Cart item = _carts[itemcount];
        if (item.itemId == i.id) {
          item.quantity = i.quantity;
          if (i.quantity == 0) {
            removeItem(i);
          }
          isItemFound = true;
          break;
        }
      }
    } else {
      _carts = new List();
    }

    if (!isItemFound) {
      // items..add(action.item);
      if (i.quantity > 0) {
        _carts = List.from(_carts)
          ..add(Cart(
              itemId: i.id, paidAmount: i.salePrice, quantity: i.quantity));
      }
    }
    notifyListeners();
  }

  removeItem(Item i) {
    return _carts..removeWhere((cart) => cart.itemId == i.id);
  }

  removeAllItems() {
    _carts = [];
  }

  double get totalPrice => _carts.fold(
      0, (total, item) => total + (item.paidAmount * item.quantity));
}

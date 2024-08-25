import 'package:flutter/foundation.dart';
import 'cartitem.dart';

class CartModel extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addItem(CartItem item) {
    _items.add(item);
    notifyListeners();
  }

  void removeItem(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void increaseQuantity(CartItem item) {
    item.quantity++;
    notifyListeners();
  }

  void decreaseQuantity(CartItem item) {
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _items.remove(item);
    }
    notifyListeners();
  }

  int get total {
    return _items.fold(0, (sum, item) => sum + item.price * item.quantity);
  }

  int get total_qty{
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  String get all_items{
    return _items.map((e) {
      return '{"id": "${e.id}","name": "${e.title}","quantity": "${e.quantity}", "price": "${e.price}", "total": "${e.quantity * e.price}"}';
    },).toList().toString();
  }
}

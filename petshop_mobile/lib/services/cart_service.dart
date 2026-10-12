import 'package:flutter/foundation.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';

class CartService {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  final List<CartItemModel> _items = [];

  // Notifier để các widget AppBar tự động cập nhật badge số lượng
  final ValueNotifier<int> cartCountNotifier = ValueNotifier<int>(0);

  List<CartItemModel> get items => List.unmodifiable(_items);

  int get totalCount {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  double get totalPrice {
    return _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  void addToCart(ProductModel product, [int quantity = 1]) {
    final index = _items.indexWhere((item) => item.product.maSP == product.maSP);
    if (index >= 0) {
      _items[index].quantity += quantity;
    } else {
      _items.add(CartItemModel(product: product, quantity: quantity));
    }
    _notify();
  }

  void updateQuantity(int maSP, int delta) {
    final index = _items.indexWhere((item) => item.product.maSP == maSP);
    if (index >= 0) {
      _items[index].quantity += delta;
      if (_items[index].quantity <= 0) {
        _items.removeAt(index);
      }
      _notify();
    }
  }

  void removeFromCart(int maSP) {
    _items.removeWhere((item) => item.product.maSP == maSP);
    _notify();
  }

  void clearCart() {
    _items.clear();
    _notify();
  }

  void _notify() {
    cartCountNotifier.value = totalCount;
  }
}

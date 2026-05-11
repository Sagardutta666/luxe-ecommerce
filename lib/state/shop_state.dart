import 'package:flutter/material.dart';
import '../models/product.dart';

class ShopState extends ChangeNotifier {
  // Store product + quantity together so all product sources work (dummyProducts + bulkProducts)
  final Map<String, MapEntry<Product, int>> _cart = {};
  final Map<String, Product> _wishlist = {};
  bool _isDarkMode = true; // Default dark theme

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  // ── Cart ────────────────────────────────────────────────────
  void addToCart(Product product) {
    final qty = _cart[product.id]?.value ?? 0;
    _cart[product.id] = MapEntry(product, qty + 1);
    notifyListeners();
  }

  void removeFromCart(Product product) {
    final qty = _cart[product.id]?.value ?? 0;
    if (qty > 1) {
      _cart[product.id] = MapEntry(product, qty - 1);
    } else {
      _cart.remove(product.id);
    }
    notifyListeners();
  }

  void removeAllFromCart(String productId) {
    _cart.remove(productId);
    notifyListeners();
  }

  List<Product> get cartItems => _cart.values.map((e) => e.key).toList();
  int getProductQuantity(String productId) => _cart[productId]?.value ?? 0;
  int get cartCount => _cart.values.fold(0, (sum, e) => sum + e.value);
  double get totalPrice =>
      _cart.values.fold(0.0, (sum, e) => sum + e.key.priceValue * e.value);

  // ── Wishlist ────────────────────────────────────────────────
  void toggleWishlist(Product product) {
    if (_wishlist.containsKey(product.id)) {
      _wishlist.remove(product.id);
    } else {
      _wishlist[product.id] = product;
    }
    notifyListeners();
  }

  bool isInWishlist(String productId) => _wishlist.containsKey(productId);
  List<Product> get wishlistItems => _wishlist.values.toList();
}

final shopState = ShopState();

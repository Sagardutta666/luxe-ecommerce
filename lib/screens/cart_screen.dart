import 'package:flutter/material.dart';
import '../state/shop_state.dart';
import '../models/product.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  static const Color _gold = Color(0xFFC8962A);
  static const Color _darkBg = Color(0xFF0C0C0E);
  static const Color _darkSurface = Color(0xFF161618);

  bool _isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  @override
  Widget build(BuildContext context) {
    final isDark = _isDark(context);

    return Scaffold(
      backgroundColor: isDark ? _darkBg : const Color(0xFFFAFAF8),
      appBar: _buildAppBar(context, isDark),
      body: ListenableBuilder(
        listenable: shopState,
        builder: (context, _) {
          final items = shopState.cartItems;
          if (items.isEmpty) return _buildEmptyState(context, isDark);

          return LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth > 900;
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? constraints.maxWidth * 0.08 : 16,
                  vertical: 24,
                ),
                child: isDesktop
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 3, child: _buildItemsList(context, isDark)),
                          const SizedBox(width: 28),
                          SizedBox(
                              width: 320,
                              child: _buildSummary(context, isDark)),
                        ],
                      )
                    : Column(
                        children: [
                          _buildItemsList(context, isDark),
                          const SizedBox(height: 24),
                          _buildSummary(context, isDark),
                        ],
                      ),
              );
            },
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isDark) {
    return AppBar(
      backgroundColor: isDark ? _darkSurface : Colors.white,
      foregroundColor: isDark ? Colors.white : const Color(0xFF1A1A1A),
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      title: Text(
        'YOUR BAG',
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 14,
          letterSpacing: 3,
          color: isDark ? Colors.white : const Color(0xFF1A1A1A),
        ),
      ),
      actions: [
        ListenableBuilder(
          listenable: shopState,
          builder: (_, _) => Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${shopState.cartCount} items',
                style: const TextStyle(
                    color: _gold, fontWeight: FontWeight.w700, fontSize: 12),
              ),
            ),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.black.withValues(alpha: 0.06),
        ),
      ),
    );
  }

  // ── Empty State ─────────────────────────────────────────────
  Widget _buildEmptyState(BuildContext context, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.06)
                  : Colors.black.withValues(alpha: 0.04),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.shopping_bag_outlined,
                size: 56,
                color: isDark ? Colors.white30 : Colors.black26),
          ),
          const SizedBox(height: 24),
          Text(
            'Your bag is empty',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
                color: isDark ? Colors.white : const Color(0xFF1A1A1A)),
          ),
          const SizedBox(height: 8),
          Text(
            'Add items you love to your bag',
            style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white38 : Colors.black38),
          ),
          const SizedBox(height: 36),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
              decoration: BoxDecoration(
                  color: _gold, borderRadius: BorderRadius.circular(14)),
              child: const Text(
                'START SHOPPING',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                    letterSpacing: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Items list ──────────────────────────────────────────────
  Widget _buildItemsList(BuildContext context, bool isDark) {
    final items = shopState.cartItems;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(width: 20, height: 2, color: _gold),
            const SizedBox(width: 10),
            Text(
              'CART ITEMS',
              style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 3,
                  color: _gold),
            ),
            const SizedBox(width: 8),
            Text(
              '(${items.length})',
              style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.white38 : Colors.black38),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ...items.map((p) => _buildItem(context, p, isDark)),
      ],
    );
  }

  Widget _buildItem(BuildContext context, Product product, bool isDark) {
    final qty = shopState.getProductQuantity(product.id);
    final lineTotal = product.priceValue * qty;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? _darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
              blurRadius: 16,
              offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              product.image,
              width: 88,
              height: 88,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                width: 88,
                height: 88,
                color: isDark
                    ? const Color(0xFF2A2A2C)
                    : const Color(0xFFF5F3EE),
                child: const Icon(Icons.image_not_supported_outlined,
                    color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 14),
          // Product details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.category.toUpperCase(),
                            style: const TextStyle(
                                color: _gold,
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            product.name,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              letterSpacing: -0.3,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF1A1A1A),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Remove all button
                    GestureDetector(
                      onTap: () => shopState.removeAllFromCart(product.id),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.07)
                              : Colors.black.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.close_rounded,
                            size: 15,
                            color: isDark ? Colors.white54 : Colors.black45),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    // Quantity control
                    Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.07)
                            : Colors.black.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _qtyBtn(
                              Icons.remove_rounded,
                              () => shopState.removeFromCart(product),
                              isDark),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              '$qty',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 14,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF1A1A1A),
                              ),
                            ),
                          ),
                          _qtyBtn(Icons.add_rounded,
                              () => shopState.addToCart(product), isDark),
                        ],
                      ),
                    ),
                    const Spacer(),
                    // Line total
                    Text(
                      '₹${lineTotal.round()}',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap, bool isDark) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Icon(icon,
            size: 14,
            color: isDark ? Colors.white70 : const Color(0xFF1A1A1A)),
      ),
    );
  }

  // ── Order Summary ───────────────────────────────────────────
  Widget _buildSummary(BuildContext context, bool isDark) {
    final subtotal = shopState.totalPrice;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0E0E10),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 30,
              offset: const Offset(0, 10))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 18, height: 2, color: _gold),
              const SizedBox(width: 10),
              const Text('ORDER SUMMARY',
                  style: TextStyle(
                      color: _gold,
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 3)),
            ],
          ),
          const SizedBox(height: 24),
          _summaryRow('Subtotal', '₹${subtotal.round()}'),
          const SizedBox(height: 10),
          _summaryRow('Shipping', 'FREE'),
          const SizedBox(height: 10),
          _summaryRow('Tax (18%)', '₹${(subtotal * 0.18).round()}'),
          Container(
              margin: const EdgeInsets.symmetric(vertical: 18),
              height: 1,
              color: Colors.white.withValues(alpha: 0.1)),
          _summaryRow(
              'Total',
              '₹${(subtotal * 1.18).round()}',
              isTotal: true),
          const SizedBox(height: 28),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 17),
              decoration: BoxDecoration(
                  color: _gold, borderRadius: BorderRadius.circular(14)),
              child: const Text(
                'CHECKOUT',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                    letterSpacing: 2.5),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_outline_rounded,
                  size: 12, color: Colors.white38),
              const SizedBox(width: 6),
              const Text('Secure checkout · SSL encrypted',
                  style: TextStyle(color: Colors.white38, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                color: isTotal ? Colors.white : Colors.white60,
                fontSize: isTotal ? 16 : 13,
                fontWeight:
                    isTotal ? FontWeight.w800 : FontWeight.w400)),
        Text(value,
            style: TextStyle(
                color: isTotal ? _gold : Colors.white,
                fontSize: isTotal ? 18 : 13,
                fontWeight: FontWeight.w900)),
      ],
    );
  }
}

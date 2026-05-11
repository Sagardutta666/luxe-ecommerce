import 'package:flutter/material.dart';
import '../models/product.dart';
import '../state/shop_state.dart';
import '../screens/product_detail_screen.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  static const Color _gold = Color(0xFFC8962A);

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 1024;

    return ListenableBuilder(
      listenable: shopState,
      builder: (context, _) {
        final inWishlist = shopState.isInWishlist(product.id);
        final quantity = shopState.getProductQuantity(product.id);

        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductDetailScreen(product: product),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.30 : 0.07),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Image ──────────────────────────────────────
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20)),
                        child: Image.network(
                          product.image,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(
                            color: isDark
                                ? const Color(0xFF2A2A2C)
                                : const Color(0xFFF0EDE8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image_outlined,
                                  size: 36,
                                  color:
                                      isDark ? Colors.white24 : Colors.black26,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'No Image',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isDark
                                        ? Colors.white24
                                        : Colors.black26,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Wishlist button
                      Positioned(
                        top: 10,
                        right: 10,
                        child: GestureDetector(
                          onTap: () => shopState.toggleWishlist(product),
                          child: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.black.withValues(alpha: 0.60)
                                  : Colors.white.withValues(alpha: 0.92),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.12),
                                    blurRadius: 8)
                              ],
                            ),
                            child: Icon(
                              inWishlist
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              size: 15,
                              color:
                                  inWishlist ? Colors.redAccent : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // ── Info ───────────────────────────────────────
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      12, 10, 12, isDesktop ? 14 : 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.category.toUpperCase(),
                        style: const TextStyle(
                          color: _gold,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: isDesktop ? 15 : 14,
                          letterSpacing: -0.3,
                          color:
                              isDark ? Colors.white : const Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        product.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? Colors.white38 : Colors.black38,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              product.price,
                              style: TextStyle(
                                fontSize: isDesktop ? 17 : 15,
                                fontWeight: FontWeight.w900,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF1A1A1A),
                              ),
                            ),
                          ),
                          _buildCartControl(quantity, isDark, isDesktop),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCartControl(int quantity, bool isDark, bool isDesktop) {
    if (quantity == 0) {
      return GestureDetector(
        onTap: () => shopState.addToCart(product),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 16 : 12,
            vertical: isDesktop ? 10 : 7,
          ),
          decoration: BoxDecoration(
            color: _gold,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            'ADD',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: isDesktop ? 12 : 10,
              letterSpacing: 1.2,
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.black.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _qtyIcon(Icons.remove_rounded,
              () => shopState.removeFromCart(product), isDark, isDesktop),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '$quantity',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: isDesktop ? 14 : 13,
                color: isDark ? Colors.white : const Color(0xFF1A1A1A),
              ),
            ),
          ),
          _qtyIcon(Icons.add_rounded, () => shopState.addToCart(product),
              isDark, isDesktop),
        ],
      ),
    );
  }

  Widget _qtyIcon(
      IconData icon, VoidCallback onTap, bool isDark, bool isDesktop) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(isDesktop ? 10 : 8),
        child: Icon(icon,
            size: isDesktop ? 15 : 13,
            color: isDark ? Colors.white70 : const Color(0xFF1A1A1A)),
      ),
    );
  }
}

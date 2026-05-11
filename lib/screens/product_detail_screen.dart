import 'package:flutter/material.dart';
import '../models/product.dart';
import '../state/shop_state.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with TickerProviderStateMixin {
  static const Color _gold = Color(0xFFC8962A);
  static const Color _darkBg = Color(0xFF0C0C0E);
  static const Color _darkSurface = Color(0xFF161618);

  // Button press: quick scale-down + slow spring back
  late final AnimationController _btnCtrl;
  late final Animation<double> _btnScale;

  // Qty control slide-in from left
  late final AnimationController _qtyCtrl;

  bool _showSuccess = false;
  int _prevQty = 0;

  bool _isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  @override
  void initState() {
    super.initState();

    _btnCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 90),
      reverseDuration: const Duration(milliseconds: 260),
    );
    _btnScale = Tween<double>(begin: 1.0, end: 0.93).animate(
      CurvedAnimation(parent: _btnCtrl, curve: Curves.easeOut),
    );

    _qtyCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      reverseDuration: const Duration(milliseconds: 280),
    );

    _prevQty = shopState.getProductQuantity(widget.product.id);
    if (_prevQty > 0) _qtyCtrl.value = 1.0;

    shopState.addListener(_onShopChange);
  }

  void _onShopChange() {
    if (!mounted) return;
    final newQty = shopState.getProductQuantity(widget.product.id);
    if (_prevQty == 0 && newQty > 0) {
      _qtyCtrl.forward();
    } else if (_prevQty > 0 && newQty == 0) {
      _qtyCtrl.reverse();
    }
    _prevQty = newQty;
  }

  @override
  void dispose() {
    shopState.removeListener(_onShopChange);
    _btnCtrl.dispose();
    _qtyCtrl.dispose();
    super.dispose();
  }

  Future<void> _onAddToCart() async {
    if (_showSuccess) return;
    // Tap down
    await _btnCtrl.forward();
    if (!mounted) return;
    shopState.addToCart(widget.product);
    // Spring back + show success
    _btnCtrl.reverse();
    setState(() => _showSuccess = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _showSuccess = false);
  }

  // ── Animated qty control widget ─────────────────────────────
  // AnimatedSize handles the layout width change.
  // FadeTransition + SlideTransition handle the visual reveal.
  Widget _animatedQtySlot(bool isDark, {double spacing = 14}) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      child: AnimatedBuilder(
        animation: _qtyCtrl,
        builder: (context, _) {
          if (_qtyCtrl.isDismissed) return const SizedBox.shrink();
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(-0.45, 0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                    parent: _qtyCtrl, curve: Curves.easeOutCubic)),
                child: FadeTransition(
                  opacity: CurvedAnimation(
                      parent: _qtyCtrl, curve: Curves.easeOut),
                  child: _qtyControl(isDark),
                ),
              ),
              SizedBox(width: spacing),
            ],
          );
        },
      ),
    );
  }

  // ── ADD TO BAG button ────────────────────────────────────────
  Widget _addToBagButton({double verticalPad = 17}) {
    return ScaleTransition(
      scale: _btnScale,
      child: GestureDetector(
        onTap: _onAddToCart,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: verticalPad),
          decoration: BoxDecoration(
            color: _showSuccess ? const Color(0xFF2E7D32) : _gold,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: (_showSuccess ? const Color(0xFF2E7D32) : _gold)
                    .withValues(alpha: 0.35),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              transitionBuilder: (child, anim) => ScaleTransition(
                scale: anim,
                child: FadeTransition(opacity: anim, child: child),
              ),
              child: _showSuccess
                  ? const Row(
                      key: ValueKey('success'),
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_rounded, color: Colors.white, size: 16),
                        SizedBox(width: 8),
                        Text(
                          'ADDED!',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 13,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    )
                  : const Text(
                      'ADD TO BAG',
                      key: ValueKey('add'),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                        letterSpacing: 2,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = _isDark(context);
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: isDark ? _darkBg : const Color(0xFFFAFAF8),
      appBar: _buildAppBar(context, isDark),
      body: isDesktop
          ? _buildDesktopBody(context, isDark)
          : _buildMobileBody(context, isDark),
      bottomNavigationBar:
          !isDesktop ? _buildStickyBar(context, isDark) : null,
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isDark) {
    return AppBar(
      backgroundColor: isDark ? _darkSurface : Colors.white,
      foregroundColor: isDark ? Colors.white : const Color(0xFF1A1A1A),
      elevation: 0,
      scrolledUnderElevation: 0,
      actions: [
        ListenableBuilder(
          listenable: shopState,
          builder: (context, _) => IconButton(
            icon: Icon(
              shopState.isInWishlist(widget.product.id)
                  ? Icons.favorite_rounded
                  : Icons.favorite_outline_rounded,
              color: shopState.isInWishlist(widget.product.id)
                  ? Colors.redAccent
                  : (isDark ? Colors.white60 : Colors.black45),
            ),
            onPressed: () => shopState.toggleWishlist(widget.product),
          ),
        ),
        const SizedBox(width: 8),
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

  // ── Desktop layout ──────────────────────────────────────────
  Widget _buildDesktopBody(BuildContext context, bool isDark) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.08,
          vertical: 48),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.network(
                widget.product.image,
                height: 520,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  height: 520,
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1C1C1E)
                        : const Color(0xFFF5F3EE),
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 60),
          Expanded(
            child: _buildProductInfo(context, isDark, desktop: true),
          ),
        ],
      ),
    );
  }

  // ── Mobile layout ───────────────────────────────────────────
  Widget _buildMobileBody(BuildContext context, bool isDark) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            widget.product.image,
            width: double.infinity,
            height: 380,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(
              height: 380,
              color: isDark
                  ? const Color(0xFF1C1C1E)
                  : const Color(0xFFF5F3EE),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: _buildProductInfo(context, isDark, desktop: false),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  // ── Shared product info ─────────────────────────────────────
  Widget _buildProductInfo(BuildContext context, bool isDark,
      {required bool desktop}) {
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final subColor = isDark ? Colors.white54 : Colors.black45;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(width: 20, height: 2, color: _gold),
            const SizedBox(width: 10),
            Text(
              widget.product.category.toUpperCase(),
              style: const TextStyle(
                  color: _gold,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 3),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          widget.product.name,
          style: TextStyle(
            fontSize: desktop ? 40 : 28,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
            height: 1.1,
            color: textColor,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            ...List.generate(
                5,
                (i) => Icon(
                      i < widget.product.rating.floor()
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      size: 14,
                      color: _gold,
                    )),
            const SizedBox(width: 8),
            Text(
              '${widget.product.rating}',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: subColor),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          widget.product.price,
          style: TextStyle(
              fontSize: desktop ? 34 : 26,
              fontWeight: FontWeight.w300,
              color: textColor),
        ),
        const SizedBox(height: 32),
        _sectionLabel('SOLD BY'),
        const SizedBox(height: 10),
        Row(
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.07)
                    : Colors.black.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(widget.product.dealerName,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: textColor)),
            ),
          ],
        ),
        const SizedBox(height: 28),
        _sectionLabel('DESCRIPTION'),
        const SizedBox(height: 10),
        Text(widget.product.description,
            style: TextStyle(fontSize: 14, height: 1.7, color: subColor)),
        const SizedBox(height: 28),
        _sectionLabel('SPECIFICATIONS'),
        const SizedBox(height: 14),
        ...widget.product.specifications
            .map((spec) => _specItem(spec, isDark)),
        if (desktop) ...[
          const SizedBox(height: 40),
          _buildDesktopActions(isDark),
        ],
      ],
    );
  }

  Widget _sectionLabel(String text) {
    return Row(
      children: [
        Container(width: 18, height: 2, color: _gold),
        const SizedBox(width: 10),
        Text(text,
            style: const TextStyle(
                color: _gold,
                fontSize: 9,
                fontWeight: FontWeight.w900,
                letterSpacing: 3)),
      ],
    );
  }

  Widget _specItem(String spec, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
                color: _gold.withValues(alpha: 0.15), shape: BoxShape.circle),
            child: const Icon(Icons.check_rounded, size: 10, color: _gold),
          ),
          const SizedBox(width: 12),
          Text(spec,
              style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white70 : Colors.black54)),
        ],
      ),
    );
  }

  // ── Desktop add-to-cart actions ─────────────────────────────
  Widget _buildDesktopActions(bool isDark) {
    return Row(
      children: [
        _animatedQtySlot(isDark, spacing: 24),
        Expanded(child: _addToBagButton(verticalPad: 20)),
      ],
    );
  }

  Widget _qtyControl(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.07)
            : Colors.black.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _iconBtn(Icons.remove_rounded,
              () => shopState.removeFromCart(widget.product), isDark),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListenableBuilder(
              listenable: shopState,
              builder: (context, _) => Text(
                '${shopState.getProductQuantity(widget.product.id)}',
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                    color:
                        isDark ? Colors.white : const Color(0xFF1A1A1A)),
              ),
            ),
          ),
          _iconBtn(Icons.add_rounded,
              () => shopState.addToCart(widget.product), isDark),
        ],
      ),
    );
  }

  Widget _iconBtn(IconData icon, VoidCallback onTap, bool isDark) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Icon(icon,
            size: 18,
            color: isDark ? Colors.white70 : const Color(0xFF1A1A1A)),
      ),
    );
  }

  // ── Mobile sticky bottom bar ────────────────────────────────
  Widget _buildStickyBar(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: BoxDecoration(
        color: isDark ? _darkSurface : Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, -4))
        ],
      ),
      child: Row(
        children: [
          _animatedQtySlot(isDark),
          Expanded(child: _addToBagButton()),
        ],
      ),
    );
  }
}

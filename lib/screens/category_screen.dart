import 'package:flutter/material.dart';
import '../models/category_data.dart';
import '../widgets/luxe_logo.dart';
import '../widgets/product_card.dart';
import '../widgets/theme_reveal.dart';
import '../state/shop_state.dart';

class CategoryScreen extends StatefulWidget {
  final String initialCategory;
  const CategoryScreen({super.key, this.initialCategory = 'Mobiles'});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late String _selected;
  final GlobalKey _themeToggleKey = GlobalKey();

  static const Color _gold = Color(0xFFC8962A);
  static const Color _darkBg = Color(0xFF0C0C0E);
  static const Color _darkSurface = Color(0xFF161618);

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialCategory;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 1024;
    final products =
        bulkProducts.where((p) => p.category == _selected).toList();

    return Scaffold(
      backgroundColor: _isDark ? _darkBg : const Color(0xFFFAFAF8),
      appBar: _buildAppBar(),
      body: isDesktop
          ? Row(
              children: [
                _buildSidebar(),
                Container(
                    width: 1,
                    color: _isDark
                        ? Colors.white.withValues(alpha: 0.06)
                        : Colors.black.withValues(alpha: 0.06)),
                Expanded(child: _buildGrid(products, 4)),
              ],
            )
          : Column(
              children: [
                _buildChipBar(),
                Expanded(child: _buildGrid(products, 2)),
              ],
            ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final bg = _isDark ? _darkSurface : Colors.white;
    final fg = _isDark ? Colors.white : const Color(0xFF1A1A1A);

    return AppBar(
      backgroundColor: bg,
      foregroundColor: fg,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      title: LuxeLogo(
        size: 18,
        textColor: fg,
      ),
      actions: [
        KeyedSubtree(
          key: _themeToggleKey,
          child: ListenableBuilder(
            listenable: shopState,
            builder: (context, _) => IconButton(
              icon: Icon(
                shopState.isDarkMode
                    ? Icons.light_mode_rounded
                    : Icons.dark_mode_rounded,
                size: 20,
              ),
              onPressed: () {
                final box = _themeToggleKey.currentContext
                    ?.findRenderObject() as RenderBox?;
                final pos = box?.localToGlobal(Offset.zero) ?? Offset.zero;
                final center = box != null
                    ? pos + Offset(box.size.width / 2, box.size.height / 2)
                    : Offset.zero;
                animatedThemeToggle(context, center);
              },
            ),
          ),
        ),
        const SizedBox(width: 8),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: _isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.black.withValues(alpha: 0.06),
        ),
      ),
    );
  }

  // ── Desktop sidebar ─────────────────────────────────────────
  Widget _buildSidebar() {
    return Container(
      width: 230,
      color: _isDark ? _darkSurface : Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 26, 22, 14),
            child: Row(
              children: [
                Container(width: 20, height: 2, color: _gold),
                const SizedBox(width: 10),
                const Text('CATEGORIES',
                    style: TextStyle(
                        color: _gold,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 3)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              itemCount: CategoryData.categories.length,
              itemBuilder: (_, i) {
                final cat = CategoryData.categories[i];
                final isActive = _selected == cat;
                return GestureDetector(
                  onTap: () => setState(() => _selected = cat),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.only(bottom: 4),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 13),
                    decoration: BoxDecoration(
                      color: isActive
                          ? _gold.withValues(alpha: 0.12)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: isActive
                          ? Border.all(
                              color: _gold.withValues(alpha: 0.28), width: 1)
                          : null,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            cat,
                            style: TextStyle(
                              fontWeight: isActive
                                  ? FontWeight.w800
                                  : FontWeight.w500,
                              fontSize: 13,
                              letterSpacing: 0.2,
                              color: isActive
                                  ? _gold
                                  : (_isDark
                                      ? Colors.white60
                                      : Colors.black54),
                            ),
                          ),
                        ),
                        if (isActive)
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                                color: _gold, shape: BoxShape.circle),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ── Mobile chip bar ─────────────────────────────────────────
  Widget _buildChipBar() {
    return Container(
      height: 62,
      color: _isDark ? _darkSurface : Colors.white,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        itemCount: CategoryData.categories.length,
        itemBuilder: (_, i) {
          final cat = CategoryData.categories[i];
          final isActive = _selected == cat;
          return GestureDetector(
            onTap: () => setState(() => _selected = cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.only(right: 10),
              padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
              decoration: BoxDecoration(
                color: isActive
                    ? _gold
                    : (_isDark
                        ? Colors.white.withValues(alpha: 0.07)
                        : Colors.black.withValues(alpha: 0.05)),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  cat,
                  style: TextStyle(
                    color: isActive
                        ? Colors.white
                        : (_isDark ? Colors.white60 : Colors.black54),
                    fontWeight:
                        isActive ? FontWeight.w800 : FontWeight.w500,
                    fontSize: 12,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Product grid ────────────────────────────────────────────
  Widget _buildGrid(List products, int columns) {
    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined,
                size: 60,
                color:
                    _isDark ? Colors.white24 : Colors.black26),
            const SizedBox(height: 16),
            Text(
              'No products found',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: _isDark ? Colors.white38 : Colors.black38),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(18),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        childAspectRatio: 0.68,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      itemCount: products.length,
      itemBuilder: (_, i) => ProductCard(product: products[i]),
    );
  }
}

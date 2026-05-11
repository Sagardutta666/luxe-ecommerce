import 'package:flutter/material.dart';
import '../state/shop_state.dart';
import '../widgets/luxe_logo.dart';
import '../widgets/theme_reveal.dart';
import 'category_screen.dart';

class CollectionsScreen extends StatelessWidget {
  const CollectionsScreen({super.key});

  static const Color _gold = Color(0xFFC8962A);
  static const Color _darkBg = Color(0xFF0C0C0E);
  static const Color _darkSurface = Color(0xFF161618);

  static final List<Map<String, dynamic>> _collections = [
    {
      'title': 'Audio & Sound',
      'subtitle': '48 premium products',
      'category': 'Electronics',
      'img': 'https://images.unsplash.com/photo-1546435770-a3e426bf472b?w=800',
      'tag': 'EDITOR\'S PICK',
    },
    {
      'title': 'Smart Wearables',
      'subtitle': '32 curated items',
      'category': 'Electronics',
      'img': 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800',
      'tag': 'TRENDING',
    },
    {
      'title': 'Flagship Mobiles',
      'subtitle': '50 handpicked models',
      'category': 'Mobiles',
      'img': 'https://images.unsplash.com/photo-1616348436168-de43ad0db179?w=800',
      'tag': 'BEST SELLERS',
    },
    {
      'title': 'Beauty & Skincare',
      'subtitle': '61 beauty essentials',
      'category': 'Beauty',
      'img': 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?w=800',
      'tag': 'NEW DROPS',
    },
    {
      'title': 'Fashion Forward',
      'subtitle': '80+ seasonal styles',
      'category': 'Fashion',
      'img': 'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=800',
      'tag': 'SEASON DROP',
    },
    {
      'title': 'Home & Living',
      'subtitle': '35 home essentials',
      'category': 'Home',
      'img': 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=800',
      'tag': 'LIFESTYLE',
    },
  ];

  bool _isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  @override
  Widget build(BuildContext context) {
    final isDark = _isDark(context);
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 1024;
    final isTablet = width > 600 && width <= 1024;
    final columns = isDesktop ? 3 : (isTablet ? 2 : 1);
    final themeKey = GlobalKey();

    return Scaffold(
      backgroundColor: isDark ? _darkBg : const Color(0xFFFAFAF8),
      appBar: AppBar(
        backgroundColor: isDark ? _darkSurface : Colors.white,
        foregroundColor: isDark ? Colors.white : const Color(0xFF1A1A1A),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: LuxeLogo(
          size: 18,
          textColor: isDark ? Colors.white : const Color(0xFF1A1A1A),
        ),
        actions: [
          KeyedSubtree(
            key: themeKey,
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
                  final box = themeKey.currentContext?.findRenderObject()
                      as RenderBox?;
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
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : Colors.black.withValues(alpha: 0.06),
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  isDesktop ? 80 : 24, 40, isDesktop ? 80 : 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(width: 22, height: 2, color: _gold),
                      const SizedBox(width: 10),
                      const Text('BROWSE',
                          style: TextStyle(
                              color: _gold,
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 3)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Our Collections',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: isDesktop ? 40 : 26,
                      letterSpacing: -1,
                      color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Curated categories, handpicked for you.',
                    style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white54 : Colors.black45),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 80 : 24, vertical: 16),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, i) => _collectionCard(context, _collections[i], isDark),
                childCount: _collections.length,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                childAspectRatio: isDesktop ? 1.45 : (isTablet ? 1.2 : 1.6),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget _collectionCard(BuildContext context, Map<String, dynamic> col,
      bool isDark) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              CategoryScreen(initialCategory: col['category'] as String),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(col['img'] as String,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) =>
                    Container(color: const Color(0xFF1C1C1E))),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withValues(alpha: 0.80)],
                ),
              ),
            ),
            Positioned(
              bottom: 22,
              left: 22,
              right: 22,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _gold.withValues(alpha: 0.22),
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                          color: _gold.withValues(alpha: 0.45), width: 1),
                    ),
                    child: Text(col['tag'] as String,
                        style: const TextStyle(
                            color: _gold,
                            fontSize: 8,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2)),
                  ),
                  const SizedBox(height: 8),
                  Text(col['title'] as String,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(col['subtitle'] as String,
                          style: const TextStyle(
                              color: Colors.white60, fontSize: 11)),
                      const Spacer(),
                      const Icon(Icons.arrow_forward_rounded,
                          color: _gold, size: 16),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

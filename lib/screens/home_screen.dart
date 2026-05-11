import 'dart:async';
import 'package:flutter/material.dart';
import '../models/category_data.dart';
import '../widgets/luxe_logo.dart';
import '../widgets/product_card.dart';
import '../widgets/theme_reveal.dart';
import '../state/shop_state.dart';
import 'cart_screen.dart';
import 'category_screen.dart';
import 'collections_screen.dart';
import 'wishlist_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final PageController _headerController = PageController();
  int _currentHeaderPage = 0;
  bool _isScrolled = false;
  late Timer _headerTimer;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey _themeToggleKey = GlobalKey();
  final ScrollController _trendingScrollController = ScrollController();
  int _bottomNavIndex = 0;

  // ── Premium Palette ─────────────────────────────────────────
  static const Color _gold = Color(0xFFC8962A);
  static const Color _darkBg = Color(0xFF0C0C0E);
  static const Color _darkSurface = Color(0xFF161618);

  final List<Map<String, String>> _heroContent = [
    {
      'title': 'Next-Gen\nMobiles',
      'subtitle': 'FLAGSHIP SERIES 2026',
      'image':
          'https://images.unsplash.com/photo-1616348436168-de43ad0db179?w=1400',
      'tag': 'JUST LAUNCHED',
      'cta': 'SHOP MOBILES',
    },
    {
      'title': 'Time\nReimagined',
      'subtitle': 'SMART SERIES 9 TITANIUM',
      'image':
          'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=1400',
      'tag': 'BEST SELLER',
      'cta': 'SHOP WATCHES',
    },
    {
      'title': 'Pure\nSound',
      'subtitle': 'ULTRA NOISE CANCELING 2.0',
      'image':
          'https://images.unsplash.com/photo-1546435770-a3e426bf472b?w=1400',
      'tag': 'NEW RELEASE',
      'cta': 'SHOP AUDIO',
    },
  ];

  final List<Map<String, dynamic>> _categories = [
    {
      'name': 'Audio',
      'label': 'SOUND',
      'img':
          'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=700',
      'count': '48 products',
    },
    {
      'name': 'Watches',
      'label': 'TIME',
      'img':
          'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=700',
      'count': '32 products',
    },
    {
      'name': 'Laptops',
      'label': 'WORK',
      'img':
          'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=700',
      'count': '25 products',
    },
    {
      'name': 'Bags',
      'label': 'CARRY',
      'img': 'https://images.unsplash.com/photo-1547949003-9792a18a2601?w=700',
      'count': '61 products',
    },
  ];

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _headerTimer = Timer.periodic(const Duration(seconds: 6), (timer) {
      if (_headerController.hasClients) {
        final next = (_currentHeaderPage + 1) % _heroContent.length;
        _headerController.animateToPage(
          next,
          duration: const Duration(milliseconds: 1200),
          curve: Curves.easeInOutQuart,
        );
      }
    });
  }

  void _onScroll() {
    final scrolled = _scrollController.offset > 60;
    if (scrolled != _isScrolled) setState(() => _isScrolled = scrolled);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _trendingScrollController.dispose();
    _headerController.dispose();
    _headerTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 1024;
    final isTablet = width > 600 && width <= 1024;
    final isMobile = width <= 600;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: _isDark ? _darkBg : const Color(0xFFFAFAF8),
      extendBodyBehindAppBar: true,
      drawer: isMobile ? _buildMobileDrawer() : null,
      appBar: _buildAppBar(isDesktop, isMobile),
      body: isMobile
          ? AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.04),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                      parent: animation, curve: Curves.easeOutCubic)),
                  child: child,
                ),
              ),
              child: KeyedSubtree(
                key: ValueKey(_bottomNavIndex == 1 ? 'search' : 'home'),
                child: _bottomNavIndex == 1
                    ? _buildSearchTab()
                    : _buildHomeScrollView(isDesktop, isTablet, width),
              ),
            )
          : _buildHomeScrollView(isDesktop, isTablet, width),
      bottomNavigationBar: isMobile ? _buildBottomNav() : null,
    );
  }

  // ── AppBar ──────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar(bool isDesktop, bool isMobile) {
    final iconColor = _isScrolled
        ? (_isDark ? Colors.white : const Color(0xFF1A1A1A))
        : Colors.white;

    return PreferredSize(
      preferredSize: Size.fromHeight(isDesktop ? 76 : 62),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        decoration: BoxDecoration(
          color: _isScrolled
              ? (_isDark
                    ? _darkBg.withOpacity(0.96)
                    : Colors.white.withOpacity(0.96))
              : Colors.transparent,
          boxShadow: _isScrolled
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    blurRadius: 24,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isDesktop ? 60 : 20),
            child: Row(
              children: [
                if (isMobile)
                  IconButton(
                    icon: Icon(Icons.menu_rounded, color: iconColor, size: 24),
                    onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                  ),
                if (!isMobile) ...[
                  _logoWidget(iconColor, isDesktop ? 21 : 17),
                  const Spacer(),
                  _navLink('HOME', iconColor, () {}),
                  _navLink(
                    'SHOP',
                    iconColor,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CategoryScreen()),
                    ),
                  ),
                  _navLink(
                    'COLLECTIONS',
                    iconColor,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CollectionsScreen(),
                      ),
                    ),
                  ),
                  _navLink('ABOUT', iconColor, () {}),
                  const Spacer(),
                ] else ...[
                  const Spacer(),
                  _logoWidget(iconColor, 18),
                  const Spacer(),
                ],
                _appBarActions(iconColor, isDesktop),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _logoWidget(Color color, double size) {
    return LuxeLogo(
      size: size,
      textColor: color,
    );
  }

  Widget _navLink(String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w700,
            fontSize: 11,
            letterSpacing: 2.5,
          ),
        ),
      ),
    );
  }

  Widget _appBarActions(Color iconColor, bool isDesktop) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.search_rounded, color: iconColor, size: 20),
          onPressed: () => _showSearch(context),
        ),
        ListenableBuilder(
          listenable: shopState,
          builder: (context, _) => Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: Icon(
                  Icons.shopping_bag_outlined,
                  color: iconColor,
                  size: 20,
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartScreen()),
                ),
              ),
              if (shopState.cartCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                      color: _gold,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${shopState.cartCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        KeyedSubtree(
          key: _themeToggleKey,
          child: IconButton(
            icon: Icon(
              shopState.isDarkMode
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded,
              color: iconColor,
              size: 20,
            ),
            onPressed: () {
              final box =
                  _themeToggleKey.currentContext?.findRenderObject()
                      as RenderBox?;
              final pos = box?.localToGlobal(Offset.zero) ?? Offset.zero;
              final center = box != null
                  ? pos + Offset(box.size.width / 2, box.size.height / 2)
                  : Offset.zero;
              animatedThemeToggle(context, center);
            },
          ),
        ),
        if (isDesktop)
          IconButton(
            icon: Icon(
              Icons.person_outline_rounded,
              color: iconColor,
              size: 20,
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
          ),
      ],
    );
  }

  // ── Hero Section ────────────────────────────────────────────
  Widget _buildHeroSection(bool isDesktop, bool isTablet, double width) {
    return SizedBox(
      height: isDesktop ? 780 : (isTablet ? 580 : 520),
      width: width,
      child: Stack(
        children: [
          PageView.builder(
            controller: _headerController,
            onPageChanged: (i) => setState(() => _currentHeaderPage = i),
            itemCount: _heroContent.length,
            itemBuilder: (_, i) => _buildHeroSlide(i, isDesktop, isTablet),
          ),
          // Bottom fade into background
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 110,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    (_isDark ? _darkBg : const Color(0xFFFAFAF8)).withOpacity(
                      0.88,
                    ),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Slide indicators
          Positioned(
            bottom: 28,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_heroContent.length, (i) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 3,
                  width: _currentHeaderPage == i ? 44 : 14,
                  decoration: BoxDecoration(
                    color: _currentHeaderPage == i ? _gold : Colors.white38,
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              }),
            ),
          ),
          if (isDesktop)
            Positioned(
              right: 60,
              bottom: 36,
              child: Text(
                '0${_currentHeaderPage + 1} / 0${_heroContent.length}',
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 10,
                  letterSpacing: 3,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeroSlide(int index, bool isDesktop, bool isTablet) {
    final item = _heroContent[index];
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          item['image']!,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(color: Colors.grey[900]),
        ),
        // Side gradient
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.black.withOpacity(0.72),
                Colors.black.withOpacity(0.08),
              ],
            ),
          ),
        ),
        // Top nav gradient
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black.withOpacity(0.55), Colors.transparent],
              stops: const [0.0, 0.38],
            ),
          ),
        ),
        // Content
        Padding(
          padding: EdgeInsets.only(
            left: isDesktop ? 80 : (isTablet ? 48 : 28),
            right: isDesktop ? 80 : (isTablet ? 48 : 28),
            top: 80,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: _gold,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Text(
                  item['tag']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 10,
                    letterSpacing: 2.5,
                  ),
                ),
              ),
              SizedBox(height: isDesktop ? 28 : 16),
              Text(
                item['title']!,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isDesktop ? 88 : (isTablet ? 62 : 46),
                  fontWeight: FontWeight.w900,
                  height: 1.0,
                  letterSpacing: -2,
                ),
              ),
              SizedBox(height: isDesktop ? 16 : 10),
              Row(
                children: [
                  Container(width: 28, height: 2, color: _gold),
                  const SizedBox(width: 12),
                  Text(
                    item['subtitle']!,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: isDesktop ? 13 : 11,
                      letterSpacing: 3.5,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              SizedBox(height: isDesktop ? 50 : 32),
              Wrap(
                spacing: 14,
                runSpacing: 12,
                children: [
                  _heroPrimaryBtn(
                    item['cta']!,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CategoryScreen()),
                    ),
                  ),
                  _heroOutlineBtn('LEARN MORE', () {}),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _heroPrimaryBtn(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 17),
        decoration: BoxDecoration(
          color: _gold,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: _gold.withOpacity(0.38),
              blurRadius: 22,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 11,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }

  Widget _heroOutlineBtn(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white54, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 11,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }

  // ── Stats Strip ─────────────────────────────────────────────
  Widget _buildStatsStrip(bool isDesktop) {
    final stats = [
      {
        'icon': Icons.local_shipping_outlined,
        'value': 'FREE',
        'label': 'Express Shipping',
      },
      {
        'icon': Icons.verified_outlined,
        'value': '100%',
        'label': 'Authentic Products',
      },
      {
        'icon': Icons.refresh_outlined,
        'value': '30-Day',
        'label': 'Free Returns',
      },
      {
        'icon': Icons.support_agent_outlined,
        'value': '24/7',
        'label': 'Premium Support',
      },
    ];

    return Container(
      color: _isDark ? _darkSurface : Colors.white,
      padding: EdgeInsets.symmetric(
        vertical: 26,
        horizontal: isDesktop ? 80 : 20,
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceEvenly,
        runSpacing: 20,
        children: stats.map(_buildStatItem).toList(),
      ),
    );
  }

  Widget _buildStatItem(Map<String, dynamic> s) {
    return SizedBox(
      width: 180,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _gold.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(s['icon'] as IconData, color: _gold, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                s['value'] as String,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                  color: _isDark ? Colors.white : const Color(0xFF1A1A1A),
                ),
              ),
              Text(
                s['label'] as String,
                style: TextStyle(
                  fontSize: 11,
                  color: _isDark ? Colors.white54 : Colors.black45,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Category Section ────────────────────────────────────────
  Widget _buildCategorySection(bool isDesktop, bool isTablet) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 70,
        horizontal: isDesktop ? 80 : (isTablet ? 48 : 24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('EXPLORE'),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  'Shop by\nCategory',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: isDesktop ? 40 : 28,
                    height: 1.15,
                    letterSpacing: -1,
                    color: _isDark ? Colors.white : const Color(0xFF1A1A1A),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CategoryScreen()),
                ),
                child: Row(
                  children: [
                    Text(
                      'View All',
                      style: TextStyle(
                        color: _gold,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      color: _gold,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 38),
          if (isDesktop || isTablet)
            _buildCategoryGrid(isDesktop)
          else
            _buildCategoryScroll(),
        ],
      ),
    );
  }

  Widget _buildCategoryGrid(bool isDesktop) {
    return SizedBox(
      height: isDesktop ? 420 : 300,
      child: Row(
        children: [
          Expanded(flex: 5, child: _categoryCard(_categories[0], large: true)),
          const SizedBox(width: 14),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Expanded(child: _categoryCard(_categories[1], large: false)),
                const SizedBox(height: 14),
                Expanded(child: _categoryCard(_categories[2], large: false)),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(flex: 3, child: _categoryCard(_categories[3], large: true)),
        ],
      ),
    );
  }

  Widget _buildCategoryScroll() {
    return SizedBox(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (_, i) => SizedBox(
          width: 160,
          child: _categoryCard(_categories[i], large: false),
        ),
      ),
    );
  }

  Widget _categoryCard(Map<String, dynamic> cat, {required bool large}) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CategoryScreen()),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              cat['img'] as String,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: Colors.grey[800]),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.78)],
                ),
              ),
            ),
            Positioned(
              bottom: 18,
              left: 18,
              right: 18,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cat['label'] as String,
                    style: const TextStyle(
                      color: _gold,
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    cat['name'] as String,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: large ? 21 : 16,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    cat['count'] as String,
                    style: const TextStyle(color: Colors.white54, fontSize: 10),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Trending Products ───────────────────────────────────────
  Widget _buildTrendingSection(bool isDesktop, bool isTablet) {
    return Container(
      color: _isDark ? _darkSurface : const Color(0xFFF5F3EE),
      padding: const EdgeInsets.symmetric(vertical: 70),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 80 : (isTablet ? 48 : 24),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionLabel('CURATED FOR YOU'),
                      const SizedBox(height: 8),
                      Text(
                        'Trending Now',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: isDesktop ? 36 : 24,
                          letterSpacing: -1,
                          color:
                              _isDark ? Colors.white : const Color(0xFF1A1A1A),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    _circleIconBtn(Icons.arrow_back_rounded, () {
                      _trendingScrollController.animateTo(
                        (_trendingScrollController.offset - 300).clamp(
                          0.0,
                          _trendingScrollController.position.maxScrollExtent,
                        ),
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOut,
                      );
                    }),
                    const SizedBox(width: 10),
                    _circleIconBtn(Icons.arrow_forward_rounded, () {
                      _trendingScrollController.animateTo(
                        (_trendingScrollController.offset + 300).clamp(
                          0.0,
                          _trendingScrollController.position.maxScrollExtent,
                        ),
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOut,
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 35),
          SizedBox(
            height: isDesktop ? 400 : 320,
            child: ListView.builder(
              controller: _trendingScrollController,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: isDesktop ? 80 : 24),
              itemCount: 8,
              itemBuilder: (_, i) => Container(
                width: isDesktop ? 280 : 218,
                margin: const EdgeInsets.only(right: 18),
                child: ProductCard(product: bulkProducts[i % bulkProducts.length]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleIconBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          border: Border.all(
            color: _isDark
                ? Colors.white24
                : Colors.black.withValues(alpha: 0.15),
            width: 1.5,
          ),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 18,
          color: _isDark ? Colors.white60 : Colors.black54,
        ),
      ),
    );
  }

  // ── Promo Banner ────────────────────────────────────────────
  Widget _buildPromoBanner(bool isDesktop) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 24,
        vertical: 28,
      ),
      height: isDesktop ? 340 : 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF0F3460)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A1A2E).withOpacity(0.45),
            blurRadius: 45,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          // Decorative rings
          Positioned(
            right: -50,
            top: -50,
            child: Container(
              width: 230,
              height: 230,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: _gold.withOpacity(0.14), width: 44),
              ),
            ),
          ),
          Positioned(
            right: 70,
            bottom: -65,
            child: Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: _gold.withOpacity(0.08), width: 32),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 60 : 28,
              vertical: isDesktop ? 36 : 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _gold.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: _gold.withValues(alpha: 0.38)),
                  ),
                  child: const Text(
                    'LIMITED OFFER',
                    style: TextStyle(
                      color: _gold,
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.5,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Up to 40% Off\nPremium Audio',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isDesktop ? 36 : 24,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Ends in 2 days · Free Shipping Included',
                  style: TextStyle(color: Colors.white54, fontSize: 11),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CategoryScreen()),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: _gold,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'CLAIM OFFER',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 11,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── New Arrivals Grid ───────────────────────────────────────
  Widget _buildNewArrivalsSection(bool isDesktop, bool isTablet) {
    final columns = isDesktop ? 4 : (isTablet ? 3 : 2);
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 70,
        horizontal: isDesktop ? 80 : (isTablet ? 48 : 24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionLabel('JUST ARRIVED'),
                    const SizedBox(height: 8),
                    Text(
                      'New Arrivals',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: isDesktop ? 36 : 24,
                        letterSpacing: -1,
                        color:
                            _isDark ? Colors.white : const Color(0xFF1A1A1A),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CategoryScreen()),
                ),
                child: Row(
                  children: [
                    Text(
                      'See All',
                      style: TextStyle(
                        color: _gold,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      color: _gold,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 38),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              childAspectRatio: 0.68,
              mainAxisSpacing: 18,
              crossAxisSpacing: 18,
            ),
            itemCount: columns * 2,
            itemBuilder: (_, i) =>
                ProductCard(product: bulkProducts[i % bulkProducts.length]),
          ),
        ],
      ),
    );
  }

  // ── Newsletter ──────────────────────────────────────────────
  Widget _buildNewsletterSection(bool isDesktop) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 24,
        vertical: 28,
      ),
      padding: EdgeInsets.symmetric(
        vertical: isDesktop ? 80 : 52,
        horizontal: isDesktop ? 80 : 28,
      ),
      decoration: BoxDecoration(
        color: _isDark ? _darkSurface : const Color(0xFFF2EEE8),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        children: [
          _sectionLabel('EXCLUSIVE BENEFITS'),
          const SizedBox(height: 12),
          Text(
            'Join 50,000+ Members',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: isDesktop ? 38 : 24,
              letterSpacing: -1,
              color: _isDark ? Colors.white : const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Early access to new drops, exclusive deals,\nand members-only privileges.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              height: 1.65,
              color: _isDark ? Colors.white54 : Colors.black45,
            ),
          ),
          const SizedBox(height: 34),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: _isDark ? const Color(0xFF222224) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    blurRadius: 28,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  const Icon(
                    Icons.mail_outline_rounded,
                    size: 18,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      style: TextStyle(
                        fontSize: 14,
                        color: _isDark ? Colors.white : Colors.black87,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter your email address',
                        hintStyle: TextStyle(
                          color: _isDark ? Colors.white38 : Colors.black38,
                          fontSize: 13,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: _gold,
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: const Text(
                        'SUBSCRIBE',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 11,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'No spam, ever. Unsubscribe anytime.',
            style: TextStyle(
              fontSize: 11,
              color: _isDark ? Colors.white30 : Colors.black38,
            ),
          ),
        ],
      ),
    );
  }

  // ── Footer ──────────────────────────────────────────────────
  Widget _buildFooter(bool isDesktop, double width) {
    return Container(
      color: const Color(0xFF0E0E10),
      width: width,
      padding: EdgeInsets.symmetric(
        vertical: isDesktop ? 80 : 50,
        horizontal: isDesktop ? 80 : 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: _footerBrand()),
                Expanded(
                  flex: 2,
                  child: _footerLinkGroup('SHOP', [
                    'Audio & Headphones',
                    'Watches',
                    'Laptops',
                    'Bags & Accessories',
                  ]),
                ),
                Expanded(
                  flex: 2,
                  child: _footerLinkGroup('COMPANY', [
                    'About Us',
                    'Careers',
                    'Press',
                    'Blog',
                  ]),
                ),
                Expanded(
                  flex: 2,
                  child: _footerLinkGroup('SUPPORT', [
                    'Help Center',
                    'Track Order',
                    'Returns',
                    'Contact Us',
                  ]),
                ),
              ],
            )
          else ...[
            _footerBrand(),
            const SizedBox(height: 40),
            Wrap(
              spacing: 40,
              runSpacing: 30,
              children: [
                _footerLinkGroup('SHOP', [
                  'Audio',
                  'Watches',
                  'Laptops',
                  'Bags',
                ]),
                _footerLinkGroup('COMPANY', ['About', 'Careers', 'Blog']),
                _footerLinkGroup('SUPPORT', ['Help', 'Track', 'Returns']),
              ],
            ),
          ],
          const SizedBox(height: 56),
          Container(height: 1, color: Colors.white.withOpacity(0.08)),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Flexible(
                child: Text(
                  '© 2026 LUXE. ALL RIGHTS RESERVED.',
                  style: TextStyle(
                    color: Colors.white24,
                    fontSize: 10,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              if (isDesktop)
                Row(
                  children: [
                    _footerSocialIcon(Icons.telegram),
                    _footerSocialIcon(Icons.facebook_outlined),
                    _footerSocialIcon(Icons.link_rounded),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _footerBrand() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'LU',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 28,
                  letterSpacing: 4,
                ),
              ),
              TextSpan(
                text: 'XE',
                style: TextStyle(
                  color: _gold,
                  fontWeight: FontWeight.w900,
                  fontSize: 28,
                  letterSpacing: 4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          'Premium e-commerce for the\ndiscerning buyer. Quality over\nquantity, always.',
          style: TextStyle(color: Colors.white38, fontSize: 13, height: 1.75),
        ),
      ],
    );
  }

  Widget _footerLinkGroup(String heading, List<String> links) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 10,
            letterSpacing: 2.5,
          ),
        ),
        const SizedBox(height: 18),
        ...links.map(
          (l) => Padding(
            padding: const EdgeInsets.only(bottom: 11),
            child: Text(
              l,
              style: const TextStyle(color: Colors.white38, fontSize: 13),
            ),
          ),
        ),
      ],
    );
  }

  Widget _footerSocialIcon(IconData icon) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.only(left: 10),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withValues(alpha: 0.20)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.white54, size: 16),
      ),
    );
  }

  // ── Shared Helpers ──────────────────────────────────────────
  Widget _sectionLabel(String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 22, height: 2, color: _gold),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(
            color: _gold,
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 3,
          ),
        ),
      ],
    );
  }

  // ── Mobile Drawer ───────────────────────────────────────────
  Widget _buildMobileDrawer() {
    final textColor = _isDark ? Colors.white : const Color(0xFF1A1A1A);
    return Drawer(
      backgroundColor: _isDark ? _darkBg : const Color(0xFFFAFAF8),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(26)),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(26, 26, 26, 14),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'LU',
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w900,
                        fontSize: 24,
                        letterSpacing: 4,
                      ),
                    ),
                    const TextSpan(
                      text: 'XE',
                      style: TextStyle(
                        color: _gold,
                        fontWeight: FontWeight.w900,
                        fontSize: 24,
                        letterSpacing: 4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              color: _isDark
                  ? Colors.white12
                  : Colors.black.withValues(alpha: 0.08),
            ),
            const SizedBox(height: 12),
            _drawerTile(Icons.home_outlined, 'HOME', () {}),
            _drawerTile(
              Icons.grid_view_rounded,
              'SHOP ALL',
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CategoryScreen()),
              ),
            ),
            _drawerTile(
              Icons.collections_outlined,
              'COLLECTIONS',
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CollectionsScreen()),
              ),
            ),
            _drawerTile(
              Icons.favorite_outline_rounded,
              'WISHLIST',
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WishlistScreen()),
              ),
            ),
            _drawerTile(
              Icons.shopping_bag_outlined,
              'CART',
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartScreen()),
              ),
            ),
            const Spacer(),
            Divider(
              color: _isDark
                  ? Colors.white12
                  : Colors.black.withValues(alpha: 0.08),
            ),
            Padding(
              padding: const EdgeInsets.all(26),
              child: Row(
                children: const [
                  Icon(Icons.logout_rounded, color: Colors.redAccent, size: 18),
                  SizedBox(width: 10),
                  Text(
                    'SIGN OUT',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(
        icon,
        size: 20,
        color: _isDark ? Colors.white54 : Colors.black45,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 12,
          letterSpacing: 2,
          color: _isDark ? Colors.white : const Color(0xFF1A1A1A),
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 26, vertical: 3),
    );
  }

  // ── Bottom Navigation ───────────────────────────────────────
  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: _isDark ? _darkSurface : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 20,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(
                0,
                Icons.home_filled,
                Icons.home_outlined,
                'Home',
                () {},
              ),
              _navItem(
                1,
                Icons.search_rounded,
                Icons.search_outlined,
                'Search',
                () {},
              ),
              _navItem(
                2,
                Icons.favorite_rounded,
                Icons.favorite_outline_rounded,
                'Wishlist',
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const WishlistScreen()),
                ).then((_) => setState(() => _bottomNavIndex = 0)),
              ),
              _navItem(
                3,
                Icons.person_rounded,
                Icons.person_outline_rounded,
                'Profile',
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                ).then((_) => setState(() => _bottomNavIndex = 0)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(
    int index,
    IconData active,
    IconData inactive,
    String label,
    VoidCallback onTap,
  ) {
    final isActive = _bottomNavIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() => _bottomNavIndex = index);
        onTap();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(
              horizontal: isActive ? 20 : 0,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: isActive ? _gold.withOpacity(0.14) : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              isActive ? active : inactive,
              color: isActive
                  ? _gold
                  : (_isDark ? Colors.white38 : Colors.black38),
              size: 22,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isActive
                  ? _gold
                  : (_isDark ? Colors.white38 : Colors.black38),
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ── Home Scroll View ────────────────────────────────────────
  Widget _buildHomeScrollView(bool isDesktop, bool isTablet, double width) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeroSection(isDesktop, isTablet, width),
          _buildStatsStrip(isDesktop),
          _buildCategorySection(isDesktop, isTablet),
          _buildTrendingSection(isDesktop, isTablet),
          _buildAdSection(isDesktop, isTablet),
          _buildPromoBanner(isDesktop),
          _buildNewArrivalsSection(isDesktop, isTablet),
          _buildNewsletterSection(isDesktop),
          _buildFooter(isDesktop, width),
        ],
      ),
    );
  }

  // ── Search Tab (mobile inline) ───────────────────────────────
  Widget _buildSearchTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 96, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Search',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 28,
                letterSpacing: -1,
                color: _isDark ? Colors.white : const Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: _isDark
                    ? const Color(0xFF222224)
                    : const Color(0xFFF5F3EE),
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextField(
                style: TextStyle(
                    color: _isDark ? Colors.white : Colors.black87),
                decoration: InputDecoration(
                  hintText: 'Search products, brands...',
                  hintStyle: TextStyle(
                    color: _isDark ? Colors.white38 : Colors.black38,
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  icon: const Icon(Icons.search_rounded, color: _gold, size: 22),
                ),
              ),
            ),
            const SizedBox(height: 28),
            _sectionLabel('TRENDING SEARCHES'),
            const SizedBox(height: 14),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                'Headphones', 'Apple Watch', 'MacBook',
                'Leather Bag', 'Makeup', 'Groceries', 'Sports'
              ].map((t) => GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: _isDark
                            ? Colors.white.withValues(alpha: 0.07)
                            : Colors.black.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        t,
                        style: TextStyle(
                          fontSize: 13,
                          color: _isDark
                              ? Colors.white70
                              : Colors.black.withValues(alpha: 0.70),
                        ),
                      ),
                    ),
                  )).toList(),
            ),
            const SizedBox(height: 32),
            _sectionLabel('BROWSE CATEGORIES'),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.1,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemCount: CategoryData.categories.length,
              itemBuilder: (_, i) {
                final cat = CategoryData.categories[i];
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          CategoryScreen(initialCategory: cat),
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: _isDark
                          ? Colors.white.withValues(alpha: 0.05)
                          : Colors.black.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _isDark
                            ? Colors.white.withValues(alpha: 0.08)
                            : Colors.black.withValues(alpha: 0.06),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(_categoryIcon(cat), color: _gold, size: 24),
                        const SizedBox(height: 6),
                        Text(
                          cat,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: _isDark
                                ? Colors.white70
                                : Colors.black.withValues(alpha: 0.70),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  IconData _categoryIcon(String cat) {
    switch (cat) {
      case 'Mobiles':     return Icons.smartphone_outlined;
      case 'Electronics': return Icons.headphones_outlined;
      case 'Beauty':      return Icons.spa_outlined;
      case 'Makeup':      return Icons.brush_outlined;
      case 'Fashion':     return Icons.checkroom_outlined;
      case 'Home':        return Icons.home_outlined;
      case 'Appliances':  return Icons.kitchen_outlined;
      case 'Grocery':     return Icons.shopping_basket_outlined;
      case 'Vegetables':  return Icons.eco_outlined;
      case 'Sports':      return Icons.sports_basketball_outlined;
      default:            return Icons.category_outlined;
    }
  }

  // ── Ad Section (new categories) ─────────────────────────────
  Widget _buildAdSection(bool isDesktop, bool isTablet) {
    final ads = [
      {
        'category': 'Makeup',
        'title': 'Glow Up\nSeason',
        'tag': 'NEW DROPS',
        'img': 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=800',
        'color': const Color(0xFF2D1B3D),
      },
      {
        'category': 'Grocery',
        'title': 'Fresh\nDelivered',
        'tag': 'SAME DAY',
        'img': 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=800',
        'color': const Color(0xFF1B3D2D),
      },
      {
        'category': 'Vegetables',
        'title': 'Farm to\nDoor',
        'tag': 'ORGANIC',
        'img': 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800',
        'color': const Color(0xFF1B3A1B),
      },
      {
        'category': 'Sports',
        'title': 'Train\nHarder',
        'tag': 'NEW GEAR',
        'img': 'https://images.unsplash.com/photo-1517649763962-0c623066013b?w=800',
        'color': const Color(0xFF1A1A2E),
      },
    ];

    return Container(
      color: _isDark ? _darkBg : const Color(0xFFFAFAF8),
      padding: EdgeInsets.symmetric(
        vertical: 60,
        horizontal: isDesktop ? 80 : (isTablet ? 48 : 24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('DISCOVER MORE'),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  'New Categories',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: isDesktop ? 36 : 24,
                    letterSpacing: -1,
                    color:
                        _isDark ? Colors.white : const Color(0xFF1A1A1A),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const CollectionsScreen()),
                ),
                child: Row(
                  children: [
                    Text(
                      'See All',
                      style: TextStyle(
                          color: _gold,
                          fontWeight: FontWeight.w700,
                          fontSize: 13),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.arrow_forward_rounded,
                        color: _gold, size: 16),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          if (isDesktop)
            Row(
              children: ads.asMap().entries.map((e) => Expanded(
                child: Padding(
                  padding:
                      EdgeInsets.only(right: e.key < ads.length - 1 ? 14 : 0),
                  child: _adCard(e.value, 220),
                ),
              )).toList(),
            )
          else
            SizedBox(
              height: 200,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: ads.length,
                separatorBuilder: (_, _) => const SizedBox(width: 14),
                itemBuilder: (_, i) => SizedBox(
                  width: isTablet ? 300 : 230,
                  child: _adCard(ads[i], 200),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _adCard(Map<String, dynamic> ad, double height) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              CategoryScreen(initialCategory: ad['category'] as String),
        ),
      ),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: ad['color'] as Color,
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              ad['img'] as String,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    (ad['color'] as Color).withValues(alpha: 0.85),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            Positioned(
              top: 18,
              left: 18,
              right: 18,
              bottom: 18,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _gold.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                          color: _gold.withValues(alpha: 0.50)),
                    ),
                    child: Text(
                      ad['tag'] as String,
                      style: const TextStyle(
                        color: _gold,
                        fontSize: 8,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    ad['title'] as String,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    children: [
                      Text(
                        'Shop Now',
                        style: TextStyle(
                          color: _gold,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(Icons.arrow_forward_rounded,
                          color: _gold, size: 14),
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

  // ── Search Modal ────────────────────────────────────────────
  void _showSearch(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(ctx).size.height * 0.8,
        decoration: BoxDecoration(
          color: _isDark ? _darkSurface : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
        ),
        padding: const EdgeInsets.all(26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Search',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                    color: _isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(ctx),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _isDark
                          ? Colors.white.withOpacity(0.08)
                          : Colors.black.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      size: 18,
                      color: _isDark ? Colors.white60 : Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: _isDark
                    ? const Color(0xFF222224)
                    : const Color(0xFFF5F3EE),
                borderRadius: BorderRadius.circular(14),
              ),
              child: TextField(
                autofocus: true,
                style: TextStyle(
                  color: _isDark ? Colors.white : Colors.black87,
                ),
                decoration: InputDecoration(
                  hintText: 'Search products, brands...',
                  hintStyle: TextStyle(
                    color: _isDark ? Colors.white38 : Colors.black38,
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  icon: const Icon(
                    Icons.search_rounded,
                    color: _gold,
                    size: 22,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'TRENDING SEARCHES',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w900,
                letterSpacing: 2.5,
                color: _isDark ? Colors.white38 : Colors.black38,
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children:
                  [
                        'Headphones',
                        'Apple Watch',
                        'MacBook',
                        'Leather Bag',
                        'Sunglasses',
                      ]
                      .map(
                        (t) => GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: _isDark
                                  ? Colors.white.withOpacity(0.07)
                                  : Colors.black.withOpacity(0.06),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              t,
                              style: TextStyle(
                                fontSize: 13,
                                color: _isDark
                                    ? Colors.white70
                                    : Colors.black.withValues(alpha: 0.70),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

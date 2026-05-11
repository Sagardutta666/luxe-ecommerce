import 'package:flutter/material.dart';
import '../widgets/luxe_logo.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  static const Color _gold = Color(0xFFC8962A);
  static const Color _darkBg = Color(0xFF0C0C0E);
  static const Color _darkCard = Color(0xFF111114);

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _nameFocus = FocusNode();

  bool _obscure = true;
  bool _isSignUp = false;
  bool _loading = false;

  late final AnimationController _bgCtrl;
  late final AnimationController _entryCtrl;
  late final AnimationController _btnCtrl;

  // 7 staggered entry animations (indices 0–6)
  late final List<Animation<double>> _fadeAnims;
  late final List<Animation<double>> _slideAnims;

  @override
  void initState() {
    super.initState();

    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3400),
    )..repeat(reverse: true);

    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _btnCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _fadeAnims = List.generate(7, (i) {
      final start = (i * 0.10).clamp(0.0, 0.6);
      final end = (start + 0.40).clamp(0.0, 1.0);
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _entryCtrl,
          curve: Interval(start, end, curve: Curves.easeOut),
        ),
      );
    });

    _slideAnims = List.generate(7, (i) {
      final start = (i * 0.10).clamp(0.0, 0.6);
      final end = (start + 0.40).clamp(0.0, 1.0);
      return Tween<double>(begin: 24, end: 0).animate(
        CurvedAnimation(
          parent: _entryCtrl,
          curve: Interval(start, end, curve: Curves.easeOutCubic),
        ),
      );
    });

    _emailFocus.addListener(() => setState(() {}));
    _passwordFocus.addListener(() => setState(() {}));
    _nameFocus.addListener(() => setState(() {}));

    _entryCtrl.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _nameFocus.dispose();
    _bgCtrl.dispose();
    _entryCtrl.dispose();
    _btnCtrl.dispose();
    super.dispose();
  }

  Widget _anim(int i, Widget child) => AnimatedBuilder(
        animation: _entryCtrl,
        builder: (context, _) => Opacity(
          opacity: _fadeAnims[i].value,
          child: Transform.translate(
            offset: Offset(0, _slideAnims[i].value),
            child: child,
          ),
        ),
      );

  void _submit() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, animation, _) => const HomeScreen(),
        transitionDuration: const Duration(milliseconds: 600),
        transitionsBuilder: (_, animation, _, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  void _skipAsGuest() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, animation, _) => const HomeScreen(),
        transitionDuration: const Duration(milliseconds: 600),
        transitionsBuilder: (_, animation, _, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  void _toggleMode() {
    setState(() => _isSignUp = !_isSignUp);
    _entryCtrl
      ..reset()
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;

    return Scaffold(
      backgroundColor: _darkBg,
      body: Stack(
        children: [
          Positioned.fill(child: _buildBackground()),
          SafeArea(
            child: isDesktop
                ? _buildDesktopLayout()
                : _buildMobileLayout(size),
          ),
        ],
      ),
    );
  }

  // ── Background ───────────────────────────────────────────────
  Widget _buildBackground() {
    return AnimatedBuilder(
      animation: _bgCtrl,
      builder: (context, _) => Stack(
        children: [
          Positioned(
            top: -200,
            right: -150,
            child: Container(
              width: 580,
              height: 580,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    _gold.withValues(alpha: 0.08 + _bgCtrl.value * 0.06),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -200,
            left: -130,
            child: Container(
              width: 520,
              height: 520,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF1E0A38)
                        .withValues(alpha: 0.55 + _bgCtrl.value * 0.25),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: CustomPaint(painter: _DiagonalLinePainter()),
          ),
        ],
      ),
    );
  }

  // ── Desktop split layout ─────────────────────────────────────
  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Left: branding panel
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF16100A), Color(0xFF0C0C0E), Color(0xFF0A0A14)],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _anim(0, _buildLogoMark(large: true)),
                  const SizedBox(height: 52),
                  _anim(1, Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'The Future\nof Luxury.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -2.5,
                          height: 1.0,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Curated collections. Authenticated products.\nPremium experience, delivered.',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.35),
                          fontSize: 14,
                          height: 1.75,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  )),
                  const SizedBox(height: 50),
                  _anim(2, _buildFeatureList()),
                ],
              ),
            ),
          ),
        ),
        // Vertical gold gradient divider
        Container(
          width: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                _gold.withValues(alpha: 0.14),
                Colors.transparent,
              ],
            ),
          ),
        ),
        // Right: form panel
        Expanded(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 52, vertical: 40),
                child: _buildFormContent(desktop: true),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Mobile layout ─────────────────────────────────────────────
  Widget _buildMobileLayout(Size size) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: size.height * 0.07),
          _anim(0, _buildLogoMark(large: false)),
          const SizedBox(height: 36),
          _buildFormContent(desktop: false),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // ── Logo mark ─────────────────────────────────────────────────
  Widget _buildLogoMark({required bool large}) {
    return LuxeLogo(
      size: large ? 44.0 : 38.0,
      showTagline: true,
    );
  }

  // ── Feature list (desktop left panel) ────────────────────────
  Widget _buildFeatureList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _featureRow(Icons.diamond_outlined, 'Authenticated Luxury Goods'),
        const SizedBox(height: 16),
        _featureRow(Icons.local_shipping_outlined, 'Same-Day Express Delivery'),
        const SizedBox(height: 16),
        _featureRow(Icons.security_outlined, 'Bank-Grade Secure Payments'),
        const SizedBox(height: 16),
        _featureRow(Icons.verified_outlined, 'Exclusive Member Rewards'),
      ],
    );
  }

  Widget _featureRow(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: _gold.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(9),
            border: Border.all(color: _gold.withValues(alpha: 0.18)),
          ),
          child: Icon(icon, size: 14, color: _gold),
        ),
        const SizedBox(width: 14),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.50),
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  // ── Form content (shared mobile + desktop right panel) ────────
  Widget _buildFormContent({required bool desktop}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header
        _anim(1, Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _isSignUp ? 'Create Account' : 'Welcome Back',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w900,
                letterSpacing: -1.2,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _isSignUp
                  ? 'Join 50,000+ premium members worldwide'
                  : 'Sign in to access your Luxe account',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.32),
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ],
        )),
        const SizedBox(height: 28),

        // Form card
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: _darkCard,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: _gold.withValues(alpha: 0.10)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.55),
                blurRadius: 48,
                offset: const Offset(0, 22),
              ),
              BoxShadow(
                color: _gold.withValues(alpha: 0.04),
                blurRadius: 60,
                spreadRadius: -8,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_isSignUp) ...[
                _anim(2, _inputField(
                  label: 'FULL NAME',
                  hint: 'Alex Luxe',
                  icon: Icons.person_outline_rounded,
                  controller: _nameController,
                  focusNode: _nameFocus,
                )),
                const SizedBox(height: 16),
              ],
              _anim(3, _inputField(
                label: 'EMAIL ADDRESS',
                hint: 'you@example.com',
                icon: Icons.alternate_email_rounded,
                controller: _emailController,
                focusNode: _emailFocus,
                keyboardType: TextInputType.emailAddress,
              )),
              const SizedBox(height: 16),
              _anim(4, _inputField(
                label: 'PASSWORD',
                hint: '••••••••',
                icon: Icons.lock_outline_rounded,
                controller: _passwordController,
                focusNode: _passwordFocus,
                obscure: _obscure,
                suffix: GestureDetector(
                  onTap: () => setState(() => _obscure = !_obscure),
                  child: Icon(
                    _obscure
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 17,
                    color: Colors.white.withValues(alpha: 0.28),
                  ),
                ),
              )),
              if (!_isSignUp) ...[
                const SizedBox(height: 10),
                _anim(4, Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {},
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(
                        color: _gold,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                )),
              ],
            ],
          ),
        ),
        const SizedBox(height: 22),

        // CTA button
        _anim(5, _buildCTAButton()),
        const SizedBox(height: 22),

        // Divider
        _anim(5, Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'OR CONTINUE WITH',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.18),
                  fontSize: 8,
                  letterSpacing: 2.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 1,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ],
        )),
        const SizedBox(height: 20),

        // Social buttons row
        _anim(6, Row(
          children: [
            Expanded(child: _socialBtn('G', const Color(0xFF4285F4))),
            const SizedBox(width: 10),
            Expanded(child: _socialBtn('A', Colors.white)),
            const SizedBox(width: 10),
            Expanded(child: _guestBtn()),
          ],
        )),
        const SizedBox(height: 26),

        // Toggle sign in / sign up
        _anim(6, Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _isSignUp ? 'Already a member? ' : 'New to Luxe? ',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.33),
                fontSize: 13,
              ),
            ),
            GestureDetector(
              onTap: _toggleMode,
              child: Text(
                _isSignUp ? 'Sign In' : 'Sign Up',
                style: const TextStyle(
                  color: _gold,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ],
        )),
      ],
    );
  }

  // ── CTA Button with pulsing glow ──────────────────────────────
  Widget _buildCTAButton() {
    return GestureDetector(
      onTap: _loading ? null : _submit,
      child: AnimatedBuilder(
        animation: _btnCtrl,
        builder: (context, _) {
          final glow = _btnCtrl.value;
          return Container(
            width: double.infinity,
            height: 54,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFD6A030), Color(0xFFC8962A), Color(0xFFAF7C18)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: _gold.withValues(alpha: 0.22 + glow * 0.24),
                  blurRadius: 14 + glow * 24,
                  spreadRadius: glow * 2,
                  offset: Offset(0, 6 + glow * 4),
                ),
              ],
            ),
            child: Center(
              child: _loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _isSignUp ? 'CREATE ACCOUNT' : 'SIGN IN',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                            letterSpacing: 2.5,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 15,
                        ),
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }

  // ── Social placeholder buttons ────────────────────────────────
  Widget _socialBtn(String letter, Color color) {
    return GestureDetector(
      onTap: _skipAsGuest,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Center(
          child: Text(
            letter,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w900,
              fontSize: 17,
              fontFamily: 'Inter',
            ),
          ),
        ),
      ),
    );
  }

  Widget _guestBtn() {
    return GestureDetector(
      onTap: _skipAsGuest,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Center(
          child: Icon(
            Icons.person_outline_rounded,
            size: 19,
            color: Colors.white.withValues(alpha: 0.40),
          ),
        ),
      ),
    );
  }

  // ── Input field ───────────────────────────────────────────────
  Widget _inputField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    required FocusNode focusNode,
    TextInputType keyboardType = TextInputType.text,
    bool obscure = false,
    Widget? suffix,
  }) {
    final isFocused = focusNode.hasFocus;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isFocused ? _gold : Colors.white.withValues(alpha: 0.28),
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.2,
          ),
        ),
        const SizedBox(height: 8),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isFocused
                ? Colors.white.withValues(alpha: 0.06)
                : Colors.white.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: isFocused
                  ? _gold.withValues(alpha: 0.52)
                  : Colors.white.withValues(alpha: 0.07),
              width: isFocused ? 1.4 : 1,
            ),
            boxShadow: isFocused
                ? [BoxShadow(color: _gold.withValues(alpha: 0.09), blurRadius: 14)]
                : [],
          ),
          child: Row(
            children: [
              const SizedBox(width: 14),
              Icon(
                icon,
                size: 15,
                color: isFocused
                    ? _gold.withValues(alpha: 0.80)
                    : Colors.white.withValues(alpha: 0.22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  obscureText: obscure,
                  keyboardType: keyboardType,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.15),
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
              if (suffix != null) ...[
                suffix,
                const SizedBox(width: 14),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

// ── Background painter ────────────────────────────────────────
class _DiagonalLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.014)
      ..strokeWidth = 1;

    const spacing = 64.0;
    final lineCount = (size.width / spacing).ceil() + (size.height / spacing).ceil() + 4;

    for (int i = -lineCount ~/ 2; i < lineCount; i++) {
      final x = i * spacing;
      canvas.drawLine(
        Offset(x.toDouble(), 0),
        Offset(x + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_DiagonalLinePainter oldDelegate) => false;
}

import 'package:flutter/material.dart';
import '../widgets/luxe_logo.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  static const Color _gold = Color(0xFFC8962A);
  static const Color _darkBg = Color(0xFF0C0C0E);

  late final AnimationController _masterCtrl;
  late final AnimationController _pulseCtrl;
  late final AnimationController _exitCtrl;

  late final Animation<double> _logoFade;
  late final Animation<double> _logoScale;
  late final Animation<double> _ringScale;
  late final Animation<double> _ringFade;
  late final Animation<double> _ring2Scale;
  late final Animation<double> _ring2Fade;
  late final Animation<double> _lineWidth;
  late final Animation<double> _tagFade;
  late final Animation<double> _tagSlide;
  late final Animation<double> _exitFade;

  @override
  void initState() {
    super.initState();

    _masterCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat(reverse: true);

    _exitCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );

    _logoFade = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _masterCtrl,
      curve: const Interval(0.05, 0.38, curve: Curves.easeOut),
    ));
    _logoScale = Tween<double>(begin: 0.55, end: 1.0).animate(CurvedAnimation(
      parent: _masterCtrl,
      curve: const Interval(0.0, 0.42, curve: Curves.elasticOut),
    ));

    _ringScale = Tween<double>(begin: 0.3, end: 2.2).animate(CurvedAnimation(
      parent: _masterCtrl,
      curve: const Interval(0.04, 0.55, curve: Curves.easeOut),
    ));
    _ringFade = Tween<double>(begin: 0.7, end: 0).animate(CurvedAnimation(
      parent: _masterCtrl,
      curve: const Interval(0.04, 0.55, curve: Curves.easeOut),
    ));

    _ring2Scale = Tween<double>(begin: 0.3, end: 2.8).animate(CurvedAnimation(
      parent: _masterCtrl,
      curve: const Interval(0.10, 0.68, curve: Curves.easeOut),
    ));
    _ring2Fade = Tween<double>(begin: 0.35, end: 0).animate(CurvedAnimation(
      parent: _masterCtrl,
      curve: const Interval(0.10, 0.68, curve: Curves.easeOut),
    ));

    _lineWidth = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _masterCtrl,
      curve: const Interval(0.36, 0.60, curve: Curves.easeOut),
    ));

    _tagFade = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _masterCtrl,
      curve: const Interval(0.58, 0.82, curve: Curves.easeOut),
    ));
    _tagSlide = Tween<double>(begin: 16, end: 0).animate(CurvedAnimation(
      parent: _masterCtrl,
      curve: const Interval(0.58, 0.82, curve: Curves.easeOutCubic),
    ));

    _exitFade = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: _exitCtrl, curve: Curves.easeIn),
    );

    _masterCtrl.forward().then((_) async {
      if (!mounted) return;
      await Future.delayed(const Duration(milliseconds: 750));
      if (!mounted) return;
      await _exitCtrl.forward();
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, _, _) => const LoginScreen(),
          transitionDuration: Duration.zero,
        ),
      );
    });
  }

  @override
  void dispose() {
    _masterCtrl.dispose();
    _pulseCtrl.dispose();
    _exitCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _exitFade,
      builder: (context, child) => Opacity(opacity: _exitFade.value, child: child!),
      child: Scaffold(
        backgroundColor: _darkBg,
        body: Stack(
          children: [
            // Background
            Positioned.fill(child: _buildBackground()),
            // Center content
            Center(
              child: AnimatedBuilder(
                animation: _masterCtrl,
                builder: (context, _) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Second outer ring
                        Transform.scale(
                          scale: _ring2Scale.value,
                          child: Opacity(
                            opacity: _ring2Fade.value,
                            child: Container(
                              width: 180,
                              height: 180,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: _gold.withValues(alpha: 0.5),
                                  width: 0.8,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // First inner ring
                        Transform.scale(
                          scale: _ringScale.value,
                          child: Opacity(
                            opacity: _ringFade.value,
                            child: Container(
                              width: 180,
                              height: 180,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: _gold, width: 1.5),
                              ),
                            ),
                          ),
                        ),
                        // Logo
                        Opacity(
                          opacity: _logoFade.value,
                          child: Transform.scale(
                            scale: _logoScale.value,
                            child: _buildLogo(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 36),
                    // Draw-in gold line
                    ClipRect(
                      child: Align(
                        widthFactor: _lineWidth.value,
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: 90,
                          height: 1,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                _gold.withValues(alpha: 0.8),
                                _gold.withValues(alpha: 0.2),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Tagline
                    Opacity(
                      opacity: _tagFade.value,
                      child: Transform.translate(
                        offset: Offset(0, _tagSlide.value),
                        child: const Text(
                          'PREMIUM SHOPPING, REDEFINED',
                          style: TextStyle(
                            color: Colors.white38,
                            fontSize: 9,
                            letterSpacing: 4.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Bottom version tag
            Positioned(
              bottom: 48,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _tagFade,
                builder: (context, _) => Opacity(
                  opacity: _tagFade.value * 0.4,
                  child: const Text(
                    'v1.0.0',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white24,
                      fontSize: 10,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return AnimatedBuilder(
      animation: _pulseCtrl,
      builder: (context, _) => Stack(
        children: [
          // Top-right gold orb
          Positioned(
            top: -180,
            right: -140,
            child: Container(
              width: 540,
              height: 540,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    _gold.withValues(alpha: 0.11 + _pulseCtrl.value * 0.07),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Bottom-left deep purple orb
          Positioned(
            bottom: -160,
            left: -100,
            child: Container(
              width: 460,
              height: 460,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF1A0830)
                        .withValues(alpha: 0.65 + _pulseCtrl.value * 0.25),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Dot grid
          Positioned.fill(
            child: CustomPaint(painter: _DotGridPainter()),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return const LuxeLogo(
      size: 54,
      axis: Axis.vertical,
    );
  }
}

class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.028)
      ..style = PaintingStyle.fill;
    const spacing = 44.0;
    for (double x = spacing; x < size.width; x += spacing) {
      for (double y = spacing; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 0.9, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DotGridPainter oldDelegate) => false;
}

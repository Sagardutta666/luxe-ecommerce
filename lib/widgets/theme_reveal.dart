import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../state/shop_state.dart';

// Attach this key to the RepaintBoundary that wraps the app content.
final GlobalKey themeRevealBoundaryKey = GlobalKey();

bool _isAnimating = false;

/// Call this instead of shopState.toggleTheme() to get the Telegram-style
/// circular reveal. [origin] is the global position of the toggle tap.
Future<void> animatedThemeToggle(BuildContext context, Offset origin) async {
  if (_isAnimating) return;
  _isAnimating = true;

  try {
    final boundary = themeRevealBoundaryKey.currentContext
        ?.findRenderObject() as RenderRepaintBoundary?;

    if (boundary == null || !context.mounted) {
      shopState.toggleTheme();
      _isAnimating = false;
      return;
    }

    // 1 — Capture the current (old-theme) frame as a raw image.
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;
    final ui.Image snapshot = await boundary.toImage(pixelRatio: pixelRatio);

    // 2 — Switch to the new theme.  The underlying tree repaints immediately.
    shopState.toggleTheme();

    if (!context.mounted) {
      snapshot.dispose();
      _isAnimating = false;
      return;
    }

    // 3 — Overlay the old-theme snapshot on top with an expanding circular
    //     hole that reveals the new theme beneath (exactly like Telegram).
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _RevealOverlay(
        snapshot: snapshot,
        origin: origin,
        onDone: () {
          entry.remove();
          snapshot.dispose();
          _isAnimating = false;
        },
      ),
    );

    Overlay.of(context).insert(entry);
  } catch (_) {
    shopState.toggleTheme();
    _isAnimating = false;
  }
}

// ── Internal widgets ──────────────────────────────────────────

class _RevealOverlay extends StatefulWidget {
  final ui.Image snapshot;
  final Offset origin;
  final VoidCallback onDone;

  const _RevealOverlay({
    required this.snapshot,
    required this.origin,
    required this.onDone,
  });

  @override
  State<_RevealOverlay> createState() => _RevealOverlayState();
}

class _RevealOverlayState extends State<_RevealOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 480),
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOutCubic);
    _ctrl.addStatusListener((s) {
      if (s == AnimationStatus.completed) widget.onDone();
    });
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  double _maxRadius(Size size) {
    final dx = max(widget.origin.dx, size.width - widget.origin.dx);
    final dy = max(widget.origin.dy, size.height - widget.origin.dy);
    return sqrt(dx * dx + dy * dy);
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _anim,
        builder: (ctx, _) {
          final size = MediaQuery.of(ctx).size;
          final holeRadius = _maxRadius(size) * _anim.value;

          return ClipPath(
            clipper: _HoleClipper(
              center: widget.origin,
              holeRadius: holeRadius,
            ),
            child: SizedBox.expand(
              child: CustomPaint(
                painter: _SnapshotPainter(snapshot: widget.snapshot),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Clips the full screen EXCEPT a growing circle — revealing the new theme.
class _HoleClipper extends CustomClipper<Path> {
  final Offset center;
  final double holeRadius;

  const _HoleClipper({required this.center, required this.holeRadius});

  @override
  Path getClip(Size size) {
    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    if (holeRadius > 0) {
      path
        ..addOval(Rect.fromCircle(center: center, radius: holeRadius))
        ..fillType = PathFillType.evenOdd;
    }
    return path;
  }

  @override
  bool shouldReclip(_HoleClipper old) =>
      old.holeRadius != holeRadius || old.center != center;
}

/// Paints the captured snapshot scaled to fill the widget.
class _SnapshotPainter extends CustomPainter {
  final ui.Image snapshot;

  const _SnapshotPainter({required this.snapshot});

  @override
  void paint(Canvas canvas, Size size) {
    final src = Rect.fromLTWH(
        0, 0, snapshot.width.toDouble(), snapshot.height.toDouble());
    final dst = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawImageRect(
        snapshot, src, dst, Paint()..filterQuality = FilterQuality.low);
  }

  @override
  bool shouldRepaint(_SnapshotPainter old) => old.snapshot != snapshot;
}

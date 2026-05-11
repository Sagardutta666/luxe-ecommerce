import 'package:flutter/material.dart';

/// Reusable LUXE brand logo.
///
/// [size]        — base font size; all proportions scale from it.
/// [textColor]   — the "LU" portion color (defaults to white; pass theme color for light bars).
/// [showMark]    — show the custom gem mark beside / above the wordmark.
/// [showTagline] — show "PREMIUM COMMERCE" subtitle.
/// [axis]        — [Axis.horizontal] (mark left, text right) or [Axis.vertical] (mark above, text below).
class LuxeLogo extends StatelessWidget {
  final double size;
  final Color? textColor;
  final bool showMark;
  final bool showTagline;
  final Axis axis;

  const LuxeLogo({
    super.key,
    this.size = 32,
    this.textColor,
    this.showMark = false,
    this.showTagline = false,
    this.axis = Axis.horizontal,
  });

  static const Color _gold = Color(0xFFC8962A);

  @override
  Widget build(BuildContext context) {
    final tColor = textColor ?? Colors.white;
    return axis == Axis.vertical
        ? _buildVertical(tColor)
        : _buildHorizontal(tColor);
  }

  // ── Horizontal: [gem] LUXE ────────────────────────────────────
  Widget _buildHorizontal(Color tColor) {
    // Gem at minimum 20 × 28 so it stays legible in AppBars
    final gemH = (size * 0.70).clamp(20.0, double.infinity);
    final gemW = gemH * 0.68;
    final stroke = (size * 0.055).clamp(1.2, 3.0);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (showMark) ...[
          SizedBox(
            width: gemW,
            height: gemH,
            child: CustomPaint(
              painter: _GemPainter(color: _gold, stroke: stroke),
            ),
          ),
          SizedBox(width: size * 0.22),
        ],
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _wordmark(tColor),
            if (showTagline) ...[
              const SizedBox(height: 4),
              _tagline(),
            ],
          ],
        ),
      ],
    );
  }

  // ── Vertical: gem above, LUXE below ──────────────────────────
  Widget _buildVertical(Color tColor) {
    final gemW = size * 0.60;
    final gemH = size * 0.86;
    final stroke = (size * 0.055).clamp(1.5, 3.5);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (showMark) ...[
          SizedBox(
            width: gemW,
            height: gemH,
            child: CustomPaint(
              painter: _GemPainter(color: _gold, stroke: stroke),
            ),
          ),
          SizedBox(height: size * 0.26),
        ],
        _wordmark(tColor),
        if (showTagline) ...[
          const SizedBox(height: 5),
          _tagline(),
        ],
      ],
    );
  }

  Widget _wordmark(Color tColor) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'LU',
            style: TextStyle(
              color: tColor,
              fontWeight: FontWeight.w900,
              fontSize: size,
              letterSpacing: size * 0.10,
              fontFamily: 'Inter',
              height: 1,
            ),
          ),
          TextSpan(
            text: 'XE',
            style: TextStyle(
              color: _gold,
              fontWeight: FontWeight.w900,
              fontSize: size,
              letterSpacing: size * 0.10,
              fontFamily: 'Inter',
              height: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tagline() {
    return Text(
      'PREMIUM COMMERCE',
      style: TextStyle(
        color: _gold.withValues(alpha: 0.55),
        fontSize: 8,
        letterSpacing: 4.5,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

// ── Gem / diamond mark painter ────────────────────────────────
//
// Draws a classic princess-cut gem profile:
//   • flat "table" across the top
//   • angled "crown" facets to the widest "girdle" at ~36% height
//   • tapers from the girdle to a sharp "culet" point at the bottom
//   • internal facet lines showing the cut
class _GemPainter extends CustomPainter {
  final Color color;
  final double stroke;

  const _GemPainter({required this.color, required this.stroke});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Key vertices
    final tl  = Offset(w * 0.18, 0);         // table – top-left
    final tr  = Offset(w * 0.82, 0);         // table – top-right
    final cl  = Offset(0,         h * 0.36); // girdle – left
    final cr  = Offset(w,         h * 0.36); // girdle – right
    final bot = Offset(w * 0.50,  h);        // culet  – bottom point

    // ── Outer silhouette ──────────────────────────────────────
    final outerPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(
      Path()
        ..moveTo(tl.dx, tl.dy)
        ..lineTo(tr.dx, tr.dy)
        ..lineTo(cr.dx, cr.dy)
        ..lineTo(bot.dx, bot.dy)
        ..lineTo(cl.dx, cl.dy)
        ..close(),
      outerPaint,
    );

    // ── Internal facet lines ───────────────────────────────────
    final facetPaint = Paint()
      ..color = color.withValues(alpha: 0.52)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke * 0.58
      ..strokeCap = StrokeCap.round;

    // "Star" — the central junction where crown facets converge
    final star = Offset(w * 0.50, h * 0.36);

    // Crown: table corners → star
    canvas.drawLine(tl,   star, facetPaint);
    canvas.drawLine(tr,   star, facetPaint);

    // Girdle: side extremes → star
    canvas.drawLine(cl,   star, facetPaint);
    canvas.drawLine(cr,   star, facetPaint);

    // Pavilion: star → culet
    canvas.drawLine(star, bot,  facetPaint);

    // Horizontal girdle divider
    canvas.drawLine(cl,   cr,   facetPaint);
  }

  @override
  bool shouldRepaint(_GemPainter old) =>
      old.color != color || old.stroke != stroke;
}

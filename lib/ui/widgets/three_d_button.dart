import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThreeDButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final Color color;

  const ThreeDButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.color = const Color(0xFF00BFFF),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: IntrinsicWidth(
        child: CustomPaint(
          painter: _ThreeDButtonPainter(color: color),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            child: Center(
              child: Text(
                label,
                style: GoogleFonts.pressStart2p(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 2,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ThreeDButtonPainter extends CustomPainter {
  final Color color;

  _ThreeDButtonPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(12),
    );

    final basePaint = Paint()..color = color;
    canvas.drawRRect(rrect, basePaint);

    final highlightPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.white.withOpacity(0.4), Colors.transparent],
      ).createShader(Offset.zero & size);
    canvas.drawRRect(rrect, highlightPaint);

    final shadowPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.transparent, Colors.black.withOpacity(0.3)],
      ).createShader(Offset.zero & size);
    canvas.drawRRect(rrect, shadowPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

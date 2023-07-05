import 'package:flutter/material.dart';
import 'dart:math';

class CircleProgress extends StatelessWidget {
  final double currentProgress;
  final double radius;
  final bool showPercentual;
  final double arcWidth;
  final Color progressColor;
  final Color outerColor;
  final Color contentColor;

  const CircleProgress({
    this.currentProgress = 0,
    this.radius = 30,
    this.showPercentual = false,
    this.arcWidth = 3,
    required this.progressColor,
    required this.outerColor,
    this.contentColor = Colors.black,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CirclePainter(
        currentProgress,
        color: progressColor,
        arcWidth: arcWidth,
        outerCircleColor: outerColor,
      ),
      child: SizedBox(
        width: radius * 2,
        height: radius * 2,
        child: showPercentual
            ? Center(
                child: Text(
                  "${currentProgress.toInt()}%",
                  style: TextStyle(
                    color: contentColor,
                    fontSize: 16,
                  ),
                ),
              )
            : Container(),
      ),
    );
  }
}

class _CirclePainter extends CustomPainter {
  final double currentProgress;
  final double arcWidth;
  final Color color;
  final Color outerCircleColor;

  _CirclePainter(this.currentProgress,
      {required this.arcWidth,
      required this.color,
      required this.outerCircleColor});

  @override
  void paint(Canvas canvas, Size size) {
    final outerCircle = Paint()
      ..strokeWidth = 1
      ..color = outerCircleColor
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = center.dx;
    final radiusOuter = radius - 3;

    final rect = Rect.fromCircle(center: center, radius: radiusOuter);
    final angle = 2 * pi * currentProgress / 100;

    final percentArc = Paint()
      ..strokeWidth = arcWidth
      ..color = color
      ..style = PaintingStyle.stroke
      ..shader = SweepGradient(
        transform: const GradientRotation(-pi / 2),
        colors: [Colors.white, color],
        stops: const [0, 0.7],
        startAngle: -pi / 2,
      ).createShader(rect);

    canvas.drawCircle(center, radiusOuter, outerCircle);
    canvas.drawArc(rect, -pi / 2, angle, false, percentArc);
  }

  @override
  bool shouldRepaint(covariant _CirclePainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.currentProgress != currentProgress;
}

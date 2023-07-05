import 'dart:math' as math;

import 'package:flutter/material.dart';

class CustomLoading extends StatefulWidget {
  final Color color;
  final Duration duration;
  final double size;

  const CustomLoading({
    Key? key,
    this.color = Colors.black,
    this.duration = const Duration(milliseconds: 1500),
    required this.size,
  }) : super(key: key);

  @override
  State<CustomLoading> createState() => _CustomLoadingState();
}

class _CustomLoadingState extends State<CustomLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController animation;

  @override
  void initState() {
    super.initState();
    animation = AnimationController(
      duration: widget.duration,
      vsync: this,
      lowerBound: 0,
      upperBound: 10,
    )..repeat();
  }

  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, child) => CustomPaint(
        size: Size(widget.size, widget.size),
        painter: _LoadingPainter(
          n: 10,
          initial: animation.value.floor(),
          color: widget.color,
        ),
      ),
    );
  }
}

class _LoadingPainter extends CustomPainter {
  final int n;
  final int initial;
  final Color color;

  const _LoadingPainter({this.n = 10, this.initial = 0, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final dtheta = 2 * math.pi / n;
    final radius = math.min(size.width, size.height) / 2;

    final pen = Paint()
      ..strokeWidth = 3
      ..color = color
      ..style = PaintingStyle.stroke;

    canvas.translate(size.width / 2, size.height / 2);
    for (int i = initial; i < n + initial; i++) {
      final angle = dtheta * i;
      final position = Offset(math.sin(angle), -math.cos(angle));

      canvas.drawLine(
        position * radius / 1.75,
        position * radius,
        pen.withOpacity(opacityFunction(i - initial)),
      );
    }
  }

  double opacityFunction(int x) => .05 + (2 / (1 + math.exp(0.5 * x))) * 0.95;

  @override
  bool shouldRepaint(_LoadingPainter oldDelegate) =>
      oldDelegate.initial != initial || oldDelegate.n != n;
}

extension _MyPaint on Paint {
  Paint withOpacity(double opacity) {
    return Paint()
      ..strokeWidth = strokeWidth
      ..style = style
      ..color = color.withOpacity(opacity);
  }
}

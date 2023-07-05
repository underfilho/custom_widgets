import 'package:custom_widgets/painted_widgets/circle_progress.dart';
import 'package:flutter/material.dart';

class AnimatedProgress extends StatefulWidget {
  final double maxProgress;

  const AnimatedProgress({Key? key, this.maxProgress = 50}) : super(key: key);

  @override
  State<AnimatedProgress> createState() => _AnimatedProgressState();
}

class _AnimatedProgressState extends State<AnimatedProgress>
    with SingleTickerProviderStateMixin {
  late final AnimationController animation;
  late final CurvedAnimation curved;

  @override
  void initState() {
    super.initState();
    animation = AnimationController(
      duration: const Duration(milliseconds: 1700),
      vsync: this,
    )..repeat();
    curved = CurvedAnimation(parent: animation, curve: Curves.decelerate);
  }

  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: curved,
      builder: (_, child) => CircleProgress(
        progressColor: Colors.red,
        outerColor: Colors.grey,
        showPercentual: true,
        radius: 50,
        currentProgress: widget.maxProgress * curved.value,
      ),
    );
  }
}

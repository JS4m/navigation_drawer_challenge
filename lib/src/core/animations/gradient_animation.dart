import 'package:flutter/material.dart';

import 'package:navigation_drawer_challenge/src/core/constants/constants.dart';

class GradientAnimation extends AnimatedWidget {
  const GradientAnimation({
    Key? key,
    required Animation<double> animation,
    required this.child,
  }) : super(key: key, listenable: animation);

  final Widget child;

  Animation<double> get progress => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: progress.value > 0 ? 0.7 + progress.value : 1,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              Colors.transparent,
              progress.value > 0 ? kAccentColor : Colors.transparent,
            ],
            stops: const [1, 1],
            radius: progress.value,
          ),
        ),
        child: child,
      ),
    );
  }
}

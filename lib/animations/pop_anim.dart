import 'package:flutter/material.dart';

class PopAnimation extends StatelessWidget {
  final Animation<double>? sizeAnim;
  final Animation<double>? opacityAnim;
  final Widget child;
  final Listenable animation;

  const PopAnimation({
    Key? key,
    this.sizeAnim,
    this.opacityAnim,
    required this.child,
    required this.animation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, -40 + ((sizeAnim?.value ?? 0) * 40)),
        child: Transform.scale(
          scale: sizeAnim?.value ?? 0,
          child: Opacity(
            opacity: opacityAnim?.value ?? 0,
            child: child,
          ),
        ),
      ),
      child: child,
    );
  }
}

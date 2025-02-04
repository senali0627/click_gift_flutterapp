import 'package:flutter/material.dart';

class AnimatedGradientText extends StatefulWidget {
  @override
  _AnimatedGradientTextState createState() => _AnimatedGradientTextState();
}

class _AnimatedGradientTextState extends State<AnimatedGradientText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<LinearGradient> _gradientAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _gradientAnimation = _controller.drive(
      GradientTween(
        begin: LinearGradient(
          colors: [Colors.purple.shade600, Colors.blue.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        end: LinearGradient(
          colors: [Colors.teal.shade400, Colors.pink.shade300],
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _gradientAnimation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return _gradientAnimation.value.createShader(
              Rect.fromLTWH(0, 0, bounds.width, bounds.height),
            );
          },
          child: Text(
            "Click Gift",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
              color: Colors.white,
              shadows: [
                Shadow(
                  offset: Offset(2, 2),
                  blurRadius: 5,
                  color: Colors.black45,
                ),
                Shadow(
                  offset: Offset(-2, -2),
                  blurRadius: 5,
                  color: Colors.black26,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class GradientTween extends Tween<LinearGradient> {
  GradientTween({required LinearGradient begin, required LinearGradient end})
      : super(begin: begin, end: end);

  @override
  LinearGradient lerp(double t) {
    return LinearGradient(
      colors: List.generate(begin!.colors.length, (index) {
        return Color.lerp(begin!.colors[index], end!.colors[index], t)!;
      }),
      begin: AlignmentGeometry.lerp(begin!.begin, end!.begin, t)!,
      end: AlignmentGeometry.lerp(begin!.end, end!.end, t)!,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class BreathingBackground extends StatelessWidget {
  const BreathingBackground({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xff0d1117) : const Color(0xFFF0F2F5), // Light mode background
            ),
          ),
        ),
        Positioned.fill(child: _buildAnimatedGradient(context, isDarkMode)),
        child,
      ],
    );
  }

  Widget _buildAnimatedGradient(BuildContext context, bool isDarkMode) {
    final tween = isDarkMode
        ? (MovieTween()
          ..tween('color1', ColorTween(begin: const Color(0xff1f2a47), end: const Color(0xff17213a)), duration: const Duration(seconds: 10))
          ..tween('color2', ColorTween(begin: const Color(0xff2d3b5b), end: const Color(0xff3a4c70)), duration: const Duration(seconds: 10)))
        : (MovieTween()
          ..tween('color1', ColorTween(begin: const Color(0xFF607D8B), end: const Color(0xFF455A64)), duration: const Duration(seconds: 15)) // Blue Grey
          ..tween('color2', ColorTween(begin: const Color(0xFF546E7A), end: const Color(0xFF78909C)), duration: const Duration(seconds: 15))); // Darker Blue Grey

    return LoopAnimationBuilder<Movie>(
      tween: tween,
      duration: tween.duration,
      builder: (context, value, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.5,
              colors: isDarkMode
                  ? [value.get('color1'), value.get('color2'), const Color(0xff0d1117)]
                  : [value.get('color1'), value.get('color2'), const Color(0xFF37474F)], // Base color for new light theme
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }
} 
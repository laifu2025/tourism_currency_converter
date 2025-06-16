import 'dart:ui';
import 'package:flutter/material.dart';

class GlassmorphicCard extends StatelessWidget {
  const GlassmorphicCard({
    Key? key,
    required this.child,
    this.width,
    this.height,
  }) : super(key: key);

  final Widget child;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final baseColor = isDarkMode ? Colors.black : Colors.grey.shade800;
    final iconColor = Colors.white70;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: baseColor.withOpacity(isDarkMode ? 0.15 : 0.4),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDarkMode
                  ? Colors.white.withOpacity(0.2)
                  : Colors.white.withOpacity(0.15),
              width: 1.5,
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                baseColor.withOpacity(isDarkMode ? 0.25 : 0.5),
                baseColor.withOpacity(isDarkMode ? 0.05 : 0.3),
              ],
              stops: const [0.1, 0.9],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDarkMode ? 0.1 : 0.05),
                spreadRadius: 1,
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: DefaultTextStyle(
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
            child: IconTheme(
              data: IconThemeData(
                color: iconColor,
                size: 24,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
} 
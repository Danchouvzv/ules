import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../core/theme.dart';

class GroupProgressBar extends StatelessWidget {
  const GroupProgressBar({
    required this.current,
    required this.target,
    this.height = 10,
    super.key,
  });

  final int current;
  final int target;
  final double height;

  @override
  Widget build(BuildContext context) {
    final value = (current / target).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: value),
            duration: 600.ms,
            curve: Curves.easeInOutCubic,
            builder: (context, animatedValue, _) {
              return Stack(
                children: [
                  Container(height: height, color: Colors.white.withOpacity(.1)),
                  FractionallySizedBox(
                    widthFactor: animatedValue,
                    child: Container(
                      height: height,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(colors: [UlesColors.danger, UlesColors.lime, UlesColors.green]),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '$current из $target собрано',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

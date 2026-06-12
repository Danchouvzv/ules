import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../core/theme.dart';
import 'formatters.dart';

class PriceDrop extends StatelessWidget {
  const PriceDrop({
    required this.retailPrice,
    required this.groupPrice,
    this.large = false,
    super.key,
  });

  final int retailPrice;
  final int groupPrice;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final saving = retailPrice - groupPrice;
    final style = Theme.of(context).textTheme;
    final parentColor = DefaultTextStyle.of(context).style.color;
    final inverted = parentColor == Colors.white;
    final mainColor = inverted ? Colors.white : UlesColors.ink;
    final mutedColor =
        inverted ? Colors.white.withOpacity(.5) : UlesColors.muted;
    final successColor = inverted ? UlesColors.green : const Color(0xFF078C3B);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          kzt(retailPrice),
          style: style.titleMedium?.copyWith(
            color: mutedColor,
            decoration: TextDecoration.lineThrough,
            decorationColor: mutedColor,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        AnimatedSwitcher(
          duration: 550.ms,
          switchInCurve: Curves.easeOutCubic,
          transitionBuilder: (child, animation) {
            return SlideTransition(
              position: Tween(begin: const Offset(0, .35), end: Offset.zero)
                  .animate(animation),
              child: FadeTransition(opacity: animation, child: child),
            );
          },
          child: Text(
            kzt(groupPrice),
            key: ValueKey(groupPrice),
            style: (large ? style.displaySmall : style.headlineSmall)?.copyWith(
              color: mainColor,
              fontWeight: FontWeight.w900,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ),
        if (large)
          Text(
            'Экономия ${kzt(saving)} · ${((saving / retailPrice) * 100).round()}%',
            style: style.titleMedium?.copyWith(
              color: successColor,
              fontWeight: FontWeight.w900,
            ),
          ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../core/theme.dart';
import '../models/product.dart';
import 'formatters.dart';

class RecommendationBadge extends StatelessWidget {
  const RecommendationBadge(
      {required this.score, this.expanded = false, super.key});

  final RecommendationScore score;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    if (!expanded) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: UlesColors.hairline),
        ),
        child: Row(
          children: [
            Icon(PhosphorIcons.sparkle(), size: 16, color: UlesColors.primary),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                score.reason,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w800, color: UlesColors.ink),
              ),
            ),
          ],
        ),
      );
    }

    final rows = [
      ('Интересы', score.interestMatch),
      ('Бюджет', score.budgetFit),
      ('Популярность в городе', score.cityPopularity),
      ('Близость группы к закрытию', score.groupCloseness),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Объяснение рекомендации',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.w900)),
        const SizedBox(height: 12),
        for (final row in rows) ...[
          Row(
            children: [
              Expanded(
                  child: Text(row.$1,
                      style: const TextStyle(fontWeight: FontWeight.w800))),
              Text(percent(row.$2),
                  style: const TextStyle(fontWeight: FontWeight.w900)),
            ],
          ),
          const SizedBox(height: 7),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: row.$2,
              minHeight: 8,
              backgroundColor: UlesColors.hairline,
              color: row.$2 > .8 ? UlesColors.green : UlesColors.ink,
            ),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

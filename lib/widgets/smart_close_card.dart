import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../core/theme.dart';
import '../models/product.dart';
import 'formatters.dart';

class SmartCloseCard extends StatelessWidget {
  const SmartCloseCard({
    required this.product,
    required this.participants,
    required this.waitForMore,
    required this.onToggle,
    this.compact = false,
    super.key,
  });

  final Product product;
  final int participants;
  final bool waitForMore;
  final VoidCallback onToggle;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final currentPrice = product.priceForParticipants(participants);
    final nextTarget = product.minParticipants * 2;
    final nextPrice = (product.wholesalePrice * .82).round();
    final extraSaving =
        (currentPrice - nextPrice).clamp(0, currentPrice).toInt();
    final voteShare = waitForMore ? 68 : 57;

    return Glass(
      radius: 24,
      padding: const EdgeInsets.all(18),
      opacity: .98,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color:
                      waitForMore ? UlesColors.softGreen : UlesColors.softBlue,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: waitForMore
                        ? UlesColors.green.withOpacity(.18)
                        : UlesColors.primary.withOpacity(.12),
                  ),
                ),
                child: Icon(
                    waitForMore
                        ? PhosphorIcons.hourglassHigh()
                        : PhosphorIcons.lockKey(),
                    color: waitForMore ? UlesColors.green : UlesColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Smart Close',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w900)),
                    Text(
                      waitForMore
                          ? 'группа ждёт следующую ценовую ступень'
                          : 'группа готова закрыться по текущей цене',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: UlesColors.muted, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              Switch(
                  value: waitForMore,
                  activeColor: UlesColors.green,
                  onChanged: (_) => onToggle()),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                  child: _SmartMetric(
                      label: 'закрыть сейчас', value: kzt(currentPrice))),
              const SizedBox(width: 10),
              Expanded(
                  child: _SmartMetric(
                      label: '$nextTarget участников', value: kzt(nextPrice))),
            ],
          ),
          if (!compact) ...[
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: (participants / nextTarget).clamp(0, 1).toDouble(),
                minHeight: 10,
                color: UlesColors.green,
                backgroundColor: UlesColors.hairline.withOpacity(.72),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              extraSaving > 0
                  ? '$voteShare% участников выбирают подождать ради ещё ${kzt(extraSaving)} экономии.'
                  : '$voteShare% участников готовы закрыть группу сейчас.',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
          ],
        ],
      ),
    );
  }
}

class _SmartMetric extends StatelessWidget {
  const _SmartMetric({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: UlesColors.hairline)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900, color: UlesColors.green)),
          Text(label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: UlesColors.muted, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

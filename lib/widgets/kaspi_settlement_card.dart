import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../core/theme.dart';
import 'formatters.dart';

class KaspiSettlementCard extends StatelessWidget {
  const KaspiSettlementCard({
    required this.heldAmount,
    required this.finalAmount,
    this.compact = false,
    super.key,
  });

  final int heldAmount;
  final int finalAmount;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final refund = (heldAmount - finalAmount).clamp(0, heldAmount).toInt();
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
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: const Color(0xFFE42235).withOpacity(.18)),
                ),
                child: const Center(
                  child: Text('K',
                      style: TextStyle(
                          color: Color(0xFFE42235),
                          fontWeight: FontWeight.w900,
                          fontSize: 24)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Kaspi Settlement',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w900)),
                    Text('холд розницы, списание только финальной цены',
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(
                                color: UlesColors.muted,
                                fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                  child: _MoneyTile(
                      label: 'заморожено',
                      value: kzt(heldAmount),
                      icon: PhosphorIcons.lockKey())),
              const SizedBox(width: 10),
              Expanded(
                  child: _MoneyTile(
                      label: 'спишется',
                      value: kzt(finalAmount),
                      icon: PhosphorIcons.checkCircle())),
            ],
          ),
          if (!compact) ...[
            const SizedBox(height: 10),
            _RefundBar(refund: refund, heldAmount: heldAmount),
          ],
        ],
      ),
    );
  }
}

class _MoneyTile extends StatelessWidget {
  const _MoneyTile(
      {required this.label, required this.value, required this.icon});

  final String label;
  final String value;
  final IconData icon;

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
          Icon(icon, color: UlesColors.primary, size: 19),
          const SizedBox(height: 8),
          Text(value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w900)),
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

class _RefundBar extends StatelessWidget {
  const _RefundBar({required this.refund, required this.heldAmount});

  final int refund;
  final int heldAmount;

  @override
  Widget build(BuildContext context) {
    final value =
        heldAmount == 0 ? 0.0 : (refund / heldAmount).clamp(0, 1).toDouble();
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: UlesColors.softGreen,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: UlesColors.green.withOpacity(.16))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(PhosphorIcons.arrowCounterClockwise(),
                  color: const Color(0xFF047857), size: 18),
              const SizedBox(width: 8),
              Expanded(
                  child: Text('возврат разницы',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF047857)))),
              Text(kzt(refund),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF047857))),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
                value: value,
                minHeight: 8,
                color: UlesColors.green,
                backgroundColor: Colors.white.withOpacity(.8)),
          ),
        ],
      ),
    );
  }
}

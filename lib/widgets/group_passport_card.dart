import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../core/theme.dart';
import '../models/product.dart';
import 'formatters.dart';

class GroupPassportCard extends StatelessWidget {
  const GroupPassportCard({
    required this.product,
    required this.participants,
    this.compact = false,
    super.key,
  });

  final Product product;
  final int participants;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final groupPrice = product.priceForParticipants(participants);
    final delivery = (groupPrice * .08).round();
    final ulesFee = (groupPrice * .05).round();
    final sourcePrice =
        (groupPrice - delivery - ulesFee).clamp(0, groupPrice).toInt();
    final demand = ((product.cityPopularity['Алматы'] ?? .7) * 100).round();
    final spotsLeft = (product.minParticipants - participants)
        .clamp(0, product.minParticipants);

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
                  color: UlesColors.softBlue,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: UlesColors.primary.withOpacity(.1)),
                ),
                child:
                    Icon(PhosphorIcons.fileLock(), color: UlesColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Паспорт группы',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w900)),
                    Text('прозрачная экономика и защита сделки',
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
                  child: _PassportMetric(
                      value: '$participants/${product.minParticipants}',
                      label: 'eSIM мест')),
              const SizedBox(width: 10),
              Expanded(
                  child: _PassportMetric(
                      value: '$demand%', label: 'спрос Алматы')),
              const SizedBox(width: 10),
              Expanded(
                  child: _PassportMetric(
                      value: spotsLeft == 0 ? 'OK' : '$spotsLeft',
                      label: 'осталось')),
            ],
          ),
          if (!compact) ...[
            const SizedBox(height: 16),
            _BreakdownRow(label: 'Цена поставщика', value: kzt(sourcePrice)),
            _BreakdownRow(label: 'Логистика до KZ', value: kzt(delivery)),
            _BreakdownRow(label: 'Комиссия Ules', value: kzt(ulesFee)),
            const Divider(height: 22),
            _BreakdownRow(
                label: 'Фиксируемая цена группы',
                value: kzt(groupPrice),
                strong: true),
            const SizedBox(height: 14),
            _PolicyStrip(product: product),
          ],
        ],
      ),
    );
  }
}

class _PassportMetric extends StatelessWidget {
  const _PassportMetric({required this.value, required this.label});
  final String value;
  final String label;

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
                  fontWeight: FontWeight.w900, color: UlesColors.primary)),
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

class _BreakdownRow extends StatelessWidget {
  const _BreakdownRow(
      {required this.label, required this.value, this.strong = false});
  final String label;
  final String value;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
              child: Text(label,
                  style: TextStyle(
                      fontWeight: strong ? FontWeight.w900 : FontWeight.w700,
                      color: strong ? UlesColors.ink : UlesColors.muted))),
          Text(value,
              style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: strong ? UlesColors.green : UlesColors.ink)),
        ],
      ),
    );
  }
}

class _PolicyStrip extends StatelessWidget {
  const _PolicyStrip({required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _PolicyChip(
            icon: PhosphorIcons.clockCountdown(), text: '48ч refund SLA'),
        _PolicyChip(
            icon: PhosphorIcons.shieldCheck(), text: '1 device = 1 seat'),
        _PolicyChip(
            icon: PhosphorIcons.storefront(), text: product.marketplace.label),
      ],
    );
  }
}

class _PolicyChip extends StatelessWidget {
  const _PolicyChip({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: UlesColors.softGreen,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: UlesColors.green.withOpacity(.16)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFF047857), size: 15),
          const SizedBox(width: 6),
          Text(text,
              style: const TextStyle(
                  color: Color(0xFF047857),
                  fontWeight: FontWeight.w900,
                  fontSize: 12)),
        ],
      ),
    );
  }
}

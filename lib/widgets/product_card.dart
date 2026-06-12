import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../app/state.dart';
import '../core/theme.dart';
import '../models/product.dart';
import 'avatar_stack.dart';
import 'group_progress_bar.dart';
import 'price_drop.dart';
import 'recommendation_badge.dart';

class ProductCard extends ConsumerWidget {
  const ProductCard({required this.item, super.key});

  final RecommendedProduct item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = item.product;
    final isFavorite =
        ref.watch(favoriteProductIdsProvider).contains(product.id);
    final spotsLeft = product.minParticipants - product.currentParticipants;
    final groupPrice =
        product.priceForParticipants(product.currentParticipants);
    final savingPercent =
        ((1 - groupPrice / product.retailPrice) * 100).round();
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () => context.go('/product/${product.id}'),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: UlesColors.hairline),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.055),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Hero(
                    tag: 'product-${product.id}',
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(22)),
                      child: AspectRatio(
                        aspectRatio: 1.5,
                        child: Image.network(
                          product.imageUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return Container(
                              color: UlesColors.primary.withOpacity(.12),
                              child: Center(
                                  child: Icon(PhosphorIcons.image(),
                                      color: Colors.white.withOpacity(.35),
                                      size: 42)),
                            )
                                .animate(onPlay: (c) => c.repeat())
                                .shimmer(duration: 1200.ms);
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: UlesColors.primary.withOpacity(.16),
                              child: Center(
                                  child: Icon(PhosphorIcons.package(),
                                      color: UlesColors.green, size: 48)),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 12,
                    top: 12,
                    child: _Badge(text: product.marketplace.label),
                  ),
                  Positioned(
                    right: 12,
                    top: 12,
                    child: Row(
                      children: [
                        _SavingBadge(text: '-$savingPercent%'),
                        const SizedBox(width: 8),
                        _FavoriteButton(
                          selected: isFavorite,
                          onTap: () => ref
                              .read(sessionProvider.notifier)
                              .toggleFavorite(product.id),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w900, height: 1.05),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: PriceDrop(
                              retailPrice: product.retailPrice,
                              groupPrice: groupPrice),
                        ),
                        _ClosingBadge(spotsLeft: spotsLeft),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                            child: GroupProgressBar(
                                current: product.currentParticipants,
                                target: product.minParticipants)),
                        const SizedBox(width: 12),
                        _ScorePill(score: item.score.total),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        AvatarStack(count: product.currentParticipants),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '${product.currentParticipants} участников уже внутри',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                  color: UlesColors.muted,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    RecommendationBadge(score: item.score),
                  ],
                ),
              ),
            ],
          ),
        ),
      ).animate().fadeIn(duration: 300.ms).slideY(begin: .03, duration: 300.ms),
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton({required this.selected, required this.onTap});
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(
            PhosphorIcons.heart(selected
                ? PhosphorIconsStyle.fill
                : PhosphorIconsStyle.regular),
            color: selected ? UlesColors.danger : UlesColors.ink,
            size: 18,
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: UlesColors.hairline),
          borderRadius: BorderRadius.circular(999)),
      child: Text(text,
          style: const TextStyle(
              color: UlesColors.ink,
              fontWeight: FontWeight.w900,
              fontSize: 12)),
    );
  }
}

class _SavingBadge extends StatelessWidget {
  const _SavingBadge({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
          color: UlesColors.ink,
          border: Border.all(color: UlesColors.ink),
          borderRadius: BorderRadius.circular(999)),
      child: Text(text,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w900, fontSize: 12)),
    );
  }
}

class _ClosingBadge extends StatelessWidget {
  const _ClosingBadge({required this.spotsLeft});
  final int spotsLeft;

  @override
  Widget build(BuildContext context) {
    final text =
        spotsLeft <= 0 ? 'группа закрыта' : 'осталось $spotsLeft места';
    return Container(
      constraints: const BoxConstraints(maxWidth: 180),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
          color: UlesColors.softGreen,
          border: Border.all(color: UlesColors.green.withOpacity(.18)),
          borderRadius: BorderRadius.circular(999)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(PhosphorIcons.usersThree(),
              color: const Color(0xFF078C3B), size: 15),
          const SizedBox(width: 6),
          Flexible(
              child: Text(text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: Color(0xFF078C3B),
                      fontWeight: FontWeight.w900,
                      fontSize: 12))),
        ],
      ),
    );
  }
}

class _ScorePill extends StatelessWidget {
  const _ScorePill({required this.score});
  final double score;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          border: Border.all(color: UlesColors.hairline),
          borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text('${(score * 100).round()}',
              style: const TextStyle(
                  fontWeight: FontWeight.w900, color: UlesColors.ink)),
          Text('score',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: UlesColors.muted, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

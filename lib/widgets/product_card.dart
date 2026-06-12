import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../core/theme.dart';
import '../models/product.dart';
import 'avatar_stack.dart';
import 'group_progress_bar.dart';
import 'price_drop.dart';
import 'recommendation_badge.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({required this.item, super.key});

  final RecommendedProduct item;

  @override
  Widget build(BuildContext context) {
    final product = item.product;
    return GestureDetector(
      onTap: () => context.go('/product/${product.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(.18), blurRadius: 24, offset: const Offset(0, 12)),
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
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    child: AspectRatio(
                      aspectRatio: 1.45,
                      child: Image.network(product.imageUrl, fit: BoxFit.cover),
                    ),
                  ),
                ),
                Positioned(
                  left: 14,
                  top: 14,
                  child: _Badge(text: product.marketplace.label),
                ),
                Positioned(
                  right: 14,
                  bottom: 14,
                  child: AvatarStack(count: product.currentParticipants),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900, height: 1.05),
                  ),
                  const SizedBox(height: 12),
                  PriceDrop(retailPrice: product.retailPrice, groupPrice: product.priceForParticipants(product.currentParticipants)),
                  const SizedBox(height: 14),
                  GroupProgressBar(current: product.currentParticipants, target: product.minParticipants),
                  const SizedBox(height: 12),
                  RecommendationBadge(score: item.score),
                ],
              ),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 450.ms).slideY(begin: .06, duration: 450.ms),
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
      decoration: BoxDecoration(color: Colors.black.withOpacity(.45), borderRadius: BorderRadius.circular(999)),
      child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12)),
    );
  }
}

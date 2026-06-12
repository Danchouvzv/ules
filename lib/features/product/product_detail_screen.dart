import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../app/state.dart';
import '../../core/theme.dart';
import '../../widgets/avatar_stack.dart';
import '../../widgets/formatters.dart';
import '../../widgets/group_progress_bar.dart';
import '../../widgets/price_drop.dart';
import '../../widgets/recommendation_badge.dart';

class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({required this.productId, super.key});

  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = ref.watch(recommendationProvider(productId));
    final product = item.product;
    final currentPrice = product.priceForParticipants(product.currentParticipants);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 360,
            pinned: true,
            actions: [IconButton(onPressed: () {}, icon: Icon(PhosphorIcons.heart()))],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'product-${product.id}',
                child: Image.network(product.imageUrl, fit: BoxFit.cover),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    _Marketplace(text: product.marketplace.label),
                    const Spacer(),
                    Icon(PhosphorIcons.star(PhosphorIconsStyle.fill), color: const Color(0xFFFFC857)),
                    Text(product.rating.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.w900)),
                  ]),
                  const SizedBox(height: 16),
                  Text(product.title, style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w900, height: 1.02)),
                  const SizedBox(height: 12),
                  Text(product.description, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant, height: 1.35)),
                  const SizedBox(height: 22),
                  PriceDrop(retailPrice: product.retailPrice, groupPrice: currentPrice, large: true),
                  const SizedBox(height: 22),
                  Row(children: [AvatarStack(count: product.currentParticipants), const SizedBox(width: 12), Expanded(child: GroupProgressBar(current: product.currentParticipants, target: product.minParticipants))]),
                  const SizedBox(height: 24),
                  _PriceLadder(retail: product.retailPrice, target: product.wholesalePrice),
                  const SizedBox(height: 24),
                  RecommendationBadge(score: item.score, expanded: true),
                  const SizedBox(height: 12),
                  Text('Характеристики', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
                  const SizedBox(height: 10),
                  ...product.specs.map((s) => ListTile(contentPadding: EdgeInsets.zero, leading: Icon(PhosphorIcons.checkCircle(), color: UlesColors.green), title: Text(s))),
                  const SizedBox(height: 12),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(PhosphorIcons.storefront(), color: UlesColors.primary),
                    title: Text(product.seller, style: const TextStyle(fontWeight: FontWeight.w900)),
                    subtitle: const Text('Проверенный продавец · доставка в Казахстан'),
                  ),
                  const SizedBox(height: 90),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(onPressed: () => context.go('/group/${product.id}'), child: const Text('Присоединиться к группе')),
        ),
      ),
    );
  }
}

class _Marketplace extends StatelessWidget {
  const _Marketplace({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: UlesColors.primary.withOpacity(.18), borderRadius: BorderRadius.circular(999)),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.w900)),
      );
}

class _PriceLadder extends StatelessWidget {
  const _PriceLadder({required this.retail, required this.target});
  final int retail;
  final int target;
  @override
  Widget build(BuildContext context) {
    final rows = [(5, ((retail + target) / 2).round()), (10, target), (20, (target * .82).round())];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(22)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Чем больше людей — тем дешевле', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          for (final row in rows)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Row(children: [
                Text('${row.$1} чел', style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(width: 12),
                Expanded(child: LinearProgressIndicator(value: row.$1 / 20, minHeight: 8, color: UlesColors.green, backgroundColor: Colors.white10)),
                const SizedBox(width: 12),
                Text(kzt(row.$2), style: const TextStyle(fontWeight: FontWeight.w900, color: UlesColors.green)),
              ]),
            ),
        ],
      ),
    );
  }
}

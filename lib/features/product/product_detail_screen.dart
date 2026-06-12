import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../app/state.dart';
import '../../core/theme.dart';
import '../../models/product.dart';
import '../../widgets/avatar_stack.dart';
import '../../widgets/formatters.dart';
import '../../widgets/group_progress_bar.dart';
import '../../widgets/group_passport_card.dart';
import '../../widgets/price_drop.dart';
import '../../widgets/recommendation_badge.dart';
import '../../widgets/smart_close_card.dart';

class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({required this.productId, super.key});

  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = ref.watch(recommendationProvider(productId));
    final product = item.product;
    final alreadyJoined =
        ref.watch(ordersProvider).any((order) => order.productId == product.id);
    final isFavorite =
        ref.watch(favoriteProductIdsProvider).contains(product.id);
    final waitForMore =
        ref.watch(smartCloseWaitIdsProvider).contains(product.id);
    final currentPrice =
        product.priceForParticipants(product.currentParticipants);
    final spotsLeft = product.minParticipants - product.currentParticipants;
    return Scaffold(
      backgroundColor: Colors.white,
      body: IosPageBackground(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 360,
              pinned: true,
              backgroundColor: Colors.white.withOpacity(.92),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: IconButton.filledTonal(
                    onPressed: () => ref
                        .read(sessionProvider.notifier)
                        .toggleFavorite(product.id),
                    icon: Icon(
                        PhosphorIcons.heart(isFavorite
                            ? PhosphorIconsStyle.fill
                            : PhosphorIconsStyle.regular),
                        color: isFavorite ? UlesColors.danger : UlesColors.ink),
                  ),
                )
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Hero(
                  tag: 'product-${product.id}',
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: UlesColors.softBlue,
                        child: Center(
                            child: Icon(PhosphorIcons.package(),
                                color: UlesColors.primary, size: 72)),
                      );
                    },
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      _Marketplace(text: product.marketplace.label),
                      const Spacer(),
                      Icon(PhosphorIcons.star(PhosphorIconsStyle.fill),
                          color: const Color(0xFFFFB020), size: 19),
                      const SizedBox(width: 4),
                      Text(product.rating.toStringAsFixed(1),
                          style: const TextStyle(fontWeight: FontWeight.w900)),
                    ]),
                    const SizedBox(height: 16),
                    Text(product.title,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                                fontWeight: FontWeight.w900, height: 1.04)),
                    const SizedBox(height: 10),
                    Text(product.description,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: UlesColors.muted,
                            height: 1.38,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 20),
                    Glass(
                      radius: 24,
                      opacity: 1,
                      padding: const EdgeInsets.all(16),
                      child: PriceDrop(
                          retailPrice: product.retailPrice,
                          groupPrice: currentPrice,
                          large: true),
                    ),
                    const SizedBox(height: 18),
                    _TrustBand(
                        spotsLeft: spotsLeft,
                        marketplace: product.marketplace.label),
                    const SizedBox(height: 20),
                    Glass(
                      radius: 22,
                      opacity: 1,
                      padding: const EdgeInsets.all(16),
                      child: Row(children: [
                        AvatarStack(count: product.currentParticipants),
                        const SizedBox(width: 12),
                        Expanded(
                            child: GroupProgressBar(
                                current: product.currentParticipants,
                                target: product.minParticipants))
                      ]),
                    ),
                    const SizedBox(height: 20),
                    _PriceLadder(
                        retail: product.retailPrice,
                        target: product.wholesalePrice),
                    const SizedBox(height: 20),
                    GroupPassportCard(
                      product: product,
                      participants: product.currentParticipants,
                    ),
                    const SizedBox(height: 20),
                    SmartCloseCard(
                      product: product,
                      participants: product.currentParticipants,
                      waitForMore: waitForMore,
                      onToggle: () => ref
                          .read(sessionProvider.notifier)
                          .toggleSmartCloseWait(product.id),
                    ),
                    const SizedBox(height: 20),
                    Glass(
                      radius: 24,
                      opacity: 1,
                      padding: const EdgeInsets.all(16),
                      child: RecommendationBadge(
                          score: item.score, expanded: true),
                    ),
                    const SizedBox(height: 20),
                    Text('Характеристики',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w900)),
                    const SizedBox(height: 10),
                    ...product.specs.map((s) => ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(PhosphorIcons.checkCircle(),
                            color: UlesColors.green),
                        title: Text(s,
                            style:
                                const TextStyle(fontWeight: FontWeight.w700)))),
                    const SizedBox(height: 12),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(PhosphorIcons.storefront(),
                          color: UlesColors.primary),
                      title: Text(product.seller,
                          style: const TextStyle(fontWeight: FontWeight.w900)),
                      subtitle: const Text(
                          'Проверенный продавец · доставка в Казахстан'),
                    ),
                    const SizedBox(height: 90),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: _JoinBottomBar(
          price: currentPrice,
          alreadyJoined: alreadyJoined,
          onPressed: () => context.go(
              alreadyJoined ? '/order/${product.id}' : '/group/${product.id}'),
        ),
      ),
    );
  }
}

class _JoinBottomBar extends StatelessWidget {
  const _JoinBottomBar({
    required this.price,
    required this.alreadyJoined,
    required this.onPressed,
  });

  final int price;
  final bool alreadyJoined;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Glass(
        radius: 22,
        padding: const EdgeInsets.all(12),
        opacity: 1,
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Цена сейчас',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: UlesColors.muted,
                          fontWeight: FontWeight.w800)),
                  Text(kzt(price),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: UlesColors.ink, fontWeight: FontWeight.w900)),
                ],
              ),
            ),
            FilledButton(
              onPressed: onPressed,
              style: FilledButton.styleFrom(minimumSize: const Size(172, 52)),
              child: Text(alreadyJoined ? 'Открыть заказ' : 'Войти в группу'),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrustBand extends StatelessWidget {
  const _TrustBand({required this.spotsLeft, required this.marketplace});

  final int spotsLeft;
  final String marketplace;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: _TrustTile(
                icon: PhosphorIcons.shieldCheck(),
                title: 'eSIM место',
                subtitle: '1 устройство')),
        const SizedBox(width: 10),
        Expanded(
            child: _TrustTile(
                icon: PhosphorIcons.creditCard(),
                title: 'Kaspi hold',
                subtitle: 'без списания')),
        const SizedBox(width: 10),
        Expanded(
            child: _TrustTile(
                icon: PhosphorIcons.storefront(),
                title: marketplace,
                subtitle: spotsLeft <= 0 ? 'закрыто' : '$spotsLeft места')),
      ],
    );
  }
}

class _TrustTile extends StatelessWidget {
  const _TrustTile(
      {required this.icon, required this.title, required this.subtitle});
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Glass(
      radius: 18,
      padding: const EdgeInsets.all(12),
      opacity: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: UlesColors.primary, size: 22),
          const SizedBox(height: 8),
          Text(title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w900)),
          Text(subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: UlesColors.muted, fontWeight: FontWeight.w700)),
        ],
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
        decoration: BoxDecoration(
            color: UlesColors.softBlue,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: UlesColors.primary.withOpacity(.12))),
        child: Text(text,
            style: const TextStyle(
                color: UlesColors.primary, fontWeight: FontWeight.w900)),
      );
}

class _PriceLadder extends StatelessWidget {
  const _PriceLadder({required this.retail, required this.target});
  final int retail;
  final int target;
  @override
  Widget build(BuildContext context) {
    final rows = [
      (5, ((retail + target) / 2).round()),
      (10, target),
      (20, (target * .82).round())
    ];
    return Glass(
      radius: 22,
      padding: const EdgeInsets.all(16),
      opacity: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Чем больше людей — тем дешевле',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          for (final row in rows)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Row(children: [
                Text('${row.$1} чел',
                    style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(width: 12),
                Expanded(
                    child: LinearProgressIndicator(
                        value: row.$1 / 20,
                        minHeight: 8,
                        color: UlesColors.ink,
                        backgroundColor: UlesColors.hairline)),
                const SizedBox(width: 12),
                Text(kzt(row.$2),
                    style: const TextStyle(
                        fontWeight: FontWeight.w900, color: UlesColors.ink)),
              ]),
            ),
        ],
      ),
    );
  }
}

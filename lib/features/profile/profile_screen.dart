import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../app/state.dart';
import '../../core/theme.dart';
import '../../models/product.dart';
import '../../widgets/app_bottom_nav.dart';
import '../../widgets/esim_card.dart';
import '../../widgets/formatters.dart';
import '../../widgets/group_progress_bar.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final settings = ref.watch(settingsProvider);
    final esim = ref.watch(esimProvider);
    final orders = ref.watch(ordersProvider);
    final totalSaved = orders.fold<int>(
        0, (sum, order) => sum + order.heldAmount - order.finalPrice);
    final activeOrders =
        orders.where((order) => order.status != OrderStatus.delivery).length;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Профиль')),
      bottomNavigationBar: const AppBottomNav(currentIndex: 2),
      body: IosPageBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 112),
          children: [
            Row(
              children: [
                Container(
                  width: 74,
                  height: 74,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                          colors: [UlesColors.primary, UlesColors.green])),
                  child: const Center(
                      child: Text('А',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 30))),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(profile.name,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w900)),
                      Text('${profile.city} · бюджет ${kzt(profile.budget)}'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                    child: _ProfileMetric(
                        value: '${orders.length}', label: 'заказов')),
                const SizedBox(width: 10),
                Expanded(
                    child: _ProfileMetric(
                        value: kzt(totalSaved), label: 'экономия')),
                const SizedBox(width: 10),
                Expanded(
                    child: _ProfileMetric(
                        value: '$activeOrders', label: 'активных')),
              ],
            ),
            const SizedBox(height: 18),
            EsimCard(esim: esim, compact: true),
            const SizedBox(height: 22),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Тёмная тема',
                  style: TextStyle(fontWeight: FontWeight.w800)),
              value: settings.themeMode == ThemeMode.dark,
              onChanged: (value) =>
                  ref.read(sessionProvider.notifier).toggleTheme(value),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(PhosphorIcons.translate()),
              title: const Text('Язык',
                  style: TextStyle(fontWeight: FontWeight.w800)),
              trailing: SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'ru', label: Text('RU')),
                  ButtonSegment(value: 'kk', label: Text('KZ'))
                ],
                selected: {settings.locale.languageCode},
                onSelectionChanged: (value) => ref
                    .read(sessionProvider.notifier)
                    .setLocale(Locale(value.first)),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.tonal(
                onPressed: () => context.go('/setup'),
                child: const Text('Управлять интересами')),
            const SizedBox(height: 24),
            Text('История групповых покупок',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 12),
            if (orders.isEmpty)
              const Glass(
                radius: 20,
                padding: EdgeInsets.all(18),
                child: Text(
                    'Пока нет заказов. Присоединитесь к группе, и заказ появится здесь.'),
              ),
            for (final order in orders) _OrderCard(order: order),
          ],
        ),
      ),
    );
  }
}

class _ProfileMetric extends StatelessWidget {
  const _ProfileMetric({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Glass(
      radius: 18,
      padding: const EdgeInsets.all(13),
      opacity: .72,
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
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});
  final GroupOrder order;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => context.go('/order/${order.productId}'),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Glass(
          radius: 22,
          padding: const EdgeInsets.all(14),
          opacity: .76,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  order.imageUrl,
                  width: 72,
                  height: 72,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                      width: 72,
                      height: 72,
                      color: UlesColors.primary.withOpacity(.14),
                      child: Icon(PhosphorIcons.package(),
                          color: UlesColors.green)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: Text(order.productTitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w900))),
                        const SizedBox(width: 8),
                        _StatusPill(status: order.status),
                      ],
                    ),
                    const SizedBox(height: 8),
                    GroupProgressBar(
                        current: order.participantsAtJoin,
                        target: order.targetParticipants,
                        height: 7),
                    const SizedBox(height: 6),
                    Text(
                        'Холд ${kzt(order.heldAmount)} · цена ${kzt(order.finalPrice)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});
  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final label = switch (status) {
      OrderStatus.paymentHeld => 'hold',
      OrderStatus.collecting => 'сбор',
      OrderStatus.groupClosed => 'закрыта',
      OrderStatus.sellerOrdered => 'заказан',
      OrderStatus.delivery => 'доставка',
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
          color: UlesColors.green.withOpacity(.14),
          borderRadius: BorderRadius.circular(999)),
      child: Text(label,
          style: const TextStyle(
              color: UlesColors.green,
              fontWeight: FontWeight.w900,
              fontSize: 11)),
    );
  }
}

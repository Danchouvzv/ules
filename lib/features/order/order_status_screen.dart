import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../app/state.dart';
import '../../core/theme.dart';
import '../../models/product.dart';
import '../../widgets/formatters.dart';
import '../../widgets/esim_card.dart';

class OrderStatusScreen extends ConsumerWidget {
  const OrderStatusScreen({required this.productId, super.key});
  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = ref.watch(productProvider(productId));
    final esim = ref.watch(esimProvider);
    final matchingOrders = ref.watch(ordersProvider).where((item) => item.productId == productId);
    final order = matchingOrders.isEmpty ? null : matchingOrders.first;
    final activeIndex = order?.status.index ?? 0;
    final steps = ['Оплата захолдирована', 'Группа собирается', 'Группа закрыта', 'Заказ оформлен у продавца', 'Доставка'];
    return Scaffold(
      appBar: AppBar(title: const Text('Статус заказа')),
      body: ListView(
        padding: const EdgeInsets.all(22),
        children: [
          Text(order?.productTitle ?? product.title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
          if (order != null) ...[
            const SizedBox(height: 10),
            Text('Kaspi hold: ${kzt(order.heldAmount)} · финальная цена: ${kzt(order.finalPrice)}', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: UlesColors.green, fontWeight: FontWeight.w900)),
            Text('Заказ ${order.id} · eSIM место ${order.esimId}', style: Theme.of(context).textTheme.bodySmall),
          ],
          const SizedBox(height: 22),
          for (var i = 0; i < steps.length; i++)
            _TimelineRow(title: steps[i], active: i <= activeIndex, last: i == steps.length - 1),
          const SizedBox(height: 18),
          EsimCard(esim: esim, compact: true),
          const SizedBox(height: 28),
          if (order != null && order.status != OrderStatus.delivery)
            FilledButton.tonal(
              onPressed: () => ref.read(sessionProvider.notifier).progressOrder(order.id),
              child: const Text('Обновить статус заказа'),
            ),
          const SizedBox(height: 10),
          FilledButton(onPressed: () => context.go('/feed'), child: const Text('Вернуться в ленту')),
        ],
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.title, required this.active, required this.last});
  final String title;
  final bool active;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            children: [
              Icon(active ? PhosphorIcons.checkCircle() : PhosphorIcons.circle(), color: active ? UlesColors.green : Colors.white38),
              if (!last) Expanded(child: Container(width: 2, color: active ? UlesColors.green.withOpacity(.45) : Colors.white12)),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
            ),
          ),
        ],
      ),
    );
  }
}

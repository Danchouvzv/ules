import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../app/state.dart';
import '../../core/theme.dart';
import '../../widgets/avatar_stack.dart';
import '../../widgets/esim_card.dart';
import '../../widgets/formatters.dart';
import '../../widgets/group_progress_bar.dart';
import '../../widgets/price_drop.dart';

class GroupJoinScreen extends ConsumerStatefulWidget {
  const GroupJoinScreen({required this.productId, super.key});
  final String productId;

  @override
  ConsumerState<GroupJoinScreen> createState() => _GroupJoinScreenState();
}

class _GroupJoinScreenState extends ConsumerState<GroupJoinScreen> {
  bool celebrated = false;

  @override
  Widget build(BuildContext context) {
    final product = ref.watch(productProvider(widget.productId));
    final esim = ref.watch(esimProvider);
    final asyncCount = ref.watch(participantStreamProvider(widget.productId));
    final count = asyncCount.value ?? product.currentParticipants;
    final complete = count >= product.minParticipants;
    final price = product.priceForParticipants(count);
    final alreadyJoined = ref.watch(ordersProvider).any((order) => order.productId == product.id);

    if (complete && !celebrated) {
      celebrated = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => HapticFeedback.heavyImpact());
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Групповая покупка')),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(22),
            children: [
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [UlesColors.primary.withOpacity(.32), UlesColors.green.withOpacity(.16)]),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  children: [
                    Text(product.title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
                    const SizedBox(height: 24),
                    AvatarStack(count: count, max: 8),
                    const SizedBox(height: 20),
                    Text('$count из ${product.minParticipants}', style: Theme.of(context).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.w900, fontFeatures: const [FontFeature.tabularFigures()])),
                    const SizedBox(height: 12),
                    GroupProgressBar(current: count, target: product.minParticipants, height: 12),
                    const SizedBox(height: 22),
                    PriceDrop(retailPrice: product.retailPrice, groupPrice: price, large: true),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(22)),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(color: const Color(0xFFE42235), borderRadius: BorderRadius.circular(14)),
                      child: const Center(child: Text('K', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 24))),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Kaspi Pay холдирование', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
                          const SizedBox(height: 4),
                          Text('Деньги спишутся только когда группа соберётся, иначе — автоматический возврат.', style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              EsimCard(esim: esim, compact: true),
              const SizedBox(height: 100),
            ],
          ),
          if (complete)
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  color: Colors.black.withOpacity(.18),
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.all(24),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(28)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(PhosphorIcons.confetti(), size: 74, color: UlesColors.green).animate(onPlay: (c) => c.repeat()).shake(duration: 1100.ms),
                          const SizedBox(height: 14),
                          Text('Группа собрана!', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
                          Text('Финальная цена зафиксирована: ${kzt(price)}', textAlign: TextAlign.center),
                        ],
                      ),
                    ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(
            onPressed: () {
              HapticFeedback.mediumImpact();
              if (!alreadyJoined) {
                ref.read(sessionProvider.notifier).joinGroup(product.id);
              }
              context.go('/order/${product.id}');
            },
            child: Text(alreadyJoined ? 'Открыть заказ' : 'Подтвердить участие'),
          ),
        ),
      ),
    );
  }
}

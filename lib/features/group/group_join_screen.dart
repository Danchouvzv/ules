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
import '../../widgets/group_passport_card.dart';
import '../../widgets/kaspi_settlement_card.dart';
import '../../widgets/price_drop.dart';
import '../../widgets/smart_close_card.dart';

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
    final alreadyJoined =
        ref.watch(ordersProvider).any((order) => order.productId == product.id);
    final waitForMore =
        ref.watch(smartCloseWaitIdsProvider).contains(product.id);

    if (complete && !celebrated) {
      celebrated = true;
      WidgetsBinding.instance
          .addPostFrameCallback((_) => HapticFeedback.heavyImpact());
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Групповая покупка')),
      backgroundColor: Colors.white,
      body: IosPageBackground(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.all(22),
              children: [
                Glass(
                  radius: 28,
                  padding: const EdgeInsets.all(22),
                  opacity: .98,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: UlesColors.softGreen,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                              color: UlesColors.green.withOpacity(.16)),
                        ),
                        child: Text(
                            complete
                                ? 'Финальная цена зафиксирована'
                                : 'Live: группа собирается',
                            style: const TextStyle(
                                color: Color(0xFF047857),
                                fontWeight: FontWeight.w900)),
                      ),
                      const SizedBox(height: 18),
                      Text(product.title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w900)),
                      const SizedBox(height: 24),
                      AvatarStack(count: count, max: 8),
                      const SizedBox(height: 20),
                      _LiveCounter(
                          count: count, target: product.minParticipants),
                      const SizedBox(height: 12),
                      GroupProgressBar(
                          current: count,
                          target: product.minParticipants,
                          height: 12),
                      const SizedBox(height: 22),
                      PriceDrop(
                          retailPrice: product.retailPrice,
                          groupPrice: price,
                          large: true),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                GroupPassportCard(
                    product: product, participants: count, compact: true),
                const SizedBox(height: 18),
                SmartCloseCard(
                  product: product,
                  participants: count,
                  waitForMore: waitForMore,
                  compact: true,
                  onToggle: () => ref
                      .read(sessionProvider.notifier)
                      .toggleSmartCloseWait(product.id),
                ),
                const SizedBox(height: 18),
                KaspiSettlementCard(
                    heldAmount: product.retailPrice, finalAmount: price),
                const SizedBox(height: 18),
                EsimCard(esim: esim, compact: true),
                const SizedBox(height: 100),
              ],
            ),
            if (complete)
              Positioned.fill(
                child: IgnorePointer(
                  child: Container(
                    color: UlesColors.primary.withOpacity(.08),
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.all(24),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: UlesColors.lightCard,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                                color: UlesColors.primary.withOpacity(.16),
                                blurRadius: 34,
                                offset: const Offset(0, 18))
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(PhosphorIcons.confetti(),
                                    size: 74, color: UlesColors.green)
                                .animate(onPlay: (c) => c.repeat())
                                .shake(duration: 1100.ms),
                            const SizedBox(height: 14),
                            Text('Группа собрана!',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(fontWeight: FontWeight.w900)),
                            Text('Финальная цена зафиксирована: ${kzt(price)}',
                                textAlign: TextAlign.center),
                          ],
                        ),
                      )
                          .animate()
                          .scale(duration: 500.ms, curve: Curves.easeOutBack),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Glass(
            radius: 22,
            padding: const EdgeInsets.all(12),
            opacity: .98,
            child: FilledButton(
              onPressed: () {
                HapticFeedback.mediumImpact();
                if (!alreadyJoined) {
                  ref.read(sessionProvider.notifier).joinGroup(product.id);
                }
                context.go('/order/${product.id}');
              },
              child:
                  Text(alreadyJoined ? 'Открыть заказ' : 'Подтвердить участие'),
            ),
          ),
        ),
      ),
    );
  }
}

class _LiveCounter extends StatelessWidget {
  const _LiveCounter({required this.count, required this.target});

  final int count;
  final int target;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: 520.ms,
      transitionBuilder: (child, animation) {
        return ScaleTransition(
            scale:
                CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
            child: FadeTransition(opacity: animation, child: child));
      },
      child: RichText(
        key: ValueKey(count),
        text: TextSpan(
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: UlesColors.ink,
              fontFeatures: const [FontFeature.tabularFigures()]),
          children: [
            TextSpan(text: '$count'),
            TextSpan(
                text: ' / $target',
                style: TextStyle(color: UlesColors.muted.withOpacity(.75))),
          ],
        ),
      ),
    );
  }
}

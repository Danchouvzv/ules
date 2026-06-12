import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../app/state.dart';
import '../../core/theme.dart';
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
    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      body: ListView(
        padding: const EdgeInsets.all(22),
        children: [
          Row(
            children: [
              Container(
                width: 74,
                height: 74,
                decoration: const BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [UlesColors.primary, UlesColors.green])),
                child: const Center(child: Text('А', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 30))),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(profile.name, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
                    Text('${profile.city} · бюджет ${kzt(profile.budget)}'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          EsimCard(esim: esim, compact: true),
          const SizedBox(height: 22),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Тёмная тема', style: TextStyle(fontWeight: FontWeight.w800)),
            value: settings.themeMode == ThemeMode.dark,
            onChanged: (value) => ref.read(sessionProvider.notifier).toggleTheme(value),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(PhosphorIcons.translate()),
            title: const Text('Язык', style: TextStyle(fontWeight: FontWeight.w800)),
            trailing: SegmentedButton<String>(
              segments: const [ButtonSegment(value: 'ru', label: Text('RU')), ButtonSegment(value: 'kk', label: Text('KZ'))],
              selected: {settings.locale.languageCode},
              onSelectionChanged: (value) => ref.read(sessionProvider.notifier).setLocale(Locale(value.first)),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.tonal(onPressed: () => context.go('/setup'), child: const Text('Управлять интересами')),
          const SizedBox(height: 24),
          Text('История групповых покупок', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          if (orders.isEmpty)
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(18)),
              child: const Text('Пока нет заказов. Присоединитесь к группе, и заказ появится здесь.'),
            ),
          for (final order in orders)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(18)),
              child: Row(
                children: [
                  ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(order.imageUrl, width: 62, height: 62, fit: BoxFit.cover)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(order.productTitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w900)),
                        const SizedBox(height: 8),
                        GroupProgressBar(current: order.participantsAtJoin, target: order.targetParticipants, height: 7),
                        const SizedBox(height: 6),
                        Text('Kaspi hold: ${kzt(order.heldAmount)} · финальная цена ${kzt(order.finalPrice)}'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

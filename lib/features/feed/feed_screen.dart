import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../app/state.dart';
import '../../core/theme.dart';
import '../../l10n/ules_localizations.dart';
import '../../models/product.dart';
import '../../widgets/app_bottom_nav.dart';
import '../../widgets/formatters.dart';
import '../../widgets/product_card.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = UlesLocalizations.of(context);
    final settings = ref.watch(settingsProvider);
    final profile = ref.watch(profileProvider);
    final products = ref.watch(recommendationsProvider);
    final orders = ref.watch(ordersProvider);
    final session = ref.watch(sessionProvider);
    final lang = Localizations.localeOf(context).languageCode;
    final saved = orders.fold<int>(
        0, (sum, order) => sum + order.heldAmount - order.finalPrice);

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
      body: IosPageBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 104),
            children: [
              _HomeHeader(
                title: l.t('feedTitle'),
                subtitle: '${l.t('hello')} · ${profile.city}',
                language: settings.locale.languageCode.toUpperCase(),
                onLanguageTap: () => ref
                    .read(sessionProvider.notifier)
                    .setLocale(Locale(
                        settings.locale.languageCode == 'ru' ? 'kk' : 'ru')),
                onProfileTap: () => context.go('/profile'),
              ),
              const SizedBox(height: 14),
              _SearchSurface(
                query: session.searchQuery,
                onChanged: ref.read(sessionProvider.notifier).setSearchQuery,
                onSubmitted: (value) {
                  final trimmed = value.trim();
                  if (trimmed.startsWith('http')) {
                    final product = ref
                        .read(sessionProvider.notifier)
                        .importProductFromLink(trimmed);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Товар добавлен: ${product.title}')));
                    context.go('/product/${product.id}');
                  }
                },
              ),
              const SizedBox(height: 14),
              _InsightsRow(
                closedGroups: orders.length + 124,
                savedAmount: saved + 8400000,
                hotGroups: products
                    .where((item) =>
                        item.product.minParticipants -
                            item.product.currentParticipants <=
                        2)
                    .length,
              ),
              const SizedBox(height: 14),
              const _ExplainableFeedCard(),
              const SizedBox(height: 14),
              SizedBox(
                height: 42,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, i) {
                    if (i == 0) {
                      return _CategoryChip(
                        label: 'Все',
                        selected: session.selectedCategory == null,
                        onTap: () => ref
                            .read(sessionProvider.notifier)
                            .setSelectedCategory(null),
                      );
                    }
                    final category = ProductCategory.values[i - 1];
                    final selected = session.selectedCategory == category;
                    return _CategoryChip(
                      label: category.label(lang),
                      selected: selected,
                      onTap: () => ref
                          .read(sessionProvider.notifier)
                          .setSelectedCategory(selected ? null : category),
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemCount: ProductCategory.values.length + 1,
                ),
              ),
              const SizedBox(height: 18),
              if (products.isEmpty)
                const _EmptyFeedState()
              else
                for (final item in products) ProductCard(item: item),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({
    required this.title,
    required this.subtitle,
    required this.language,
    required this.onLanguageTap,
    required this.onProfileTap,
  });

  final String title;
  final String subtitle;
  final String language;
  final VoidCallback onLanguageTap;
  final VoidCallback onProfileTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 14, 18),
      decoration: BoxDecoration(
        color: UlesColors.slate,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: UlesColors.slate.withOpacity(.18),
            blurRadius: 28,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subtitle,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Colors.white.withOpacity(.68),
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                Text(title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        height: 1.02)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(PhosphorIcons.lockKey(),
                        color: UlesColors.green, size: 16),
                    const SizedBox(width: 6),
                    Text('Kaspi hold · eSIM verified',
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(
                                color: Colors.white.withOpacity(.76),
                                fontWeight: FontWeight.w800)),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            children: [
              _RoundAction(
                  label: language, onTap: onLanguageTap, inverted: true),
              const SizedBox(height: 8),
              _RoundAction(
                  icon: PhosphorIcons.userCircle(),
                  onTap: onProfileTap,
                  inverted: true),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoundAction extends StatelessWidget {
  const _RoundAction(
      {this.icon, this.label, required this.onTap, this.inverted = false});

  final IconData? icon;
  final String? label;
  final VoidCallback onTap;
  final bool inverted;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: inverted ? Colors.white.withOpacity(.1) : Colors.white,
          border: Border.all(
              color: inverted
                  ? Colors.white.withOpacity(.16)
                  : UlesColors.hairline),
        ),
        child: SizedBox(
          width: 24,
          height: 24,
          child: Center(
            child: icon == null
                ? Text(label!,
                    style: TextStyle(
                        color: inverted ? Colors.white : UlesColors.ink,
                        fontWeight: FontWeight.w900,
                        fontSize: 12))
                : Icon(icon,
                    size: 22, color: inverted ? Colors.white : UlesColors.ink),
          ),
        ),
      ),
    );
  }
}

class _SearchSurface extends StatefulWidget {
  const _SearchSurface(
      {required this.query,
      required this.onChanged,
      required this.onSubmitted});

  final String query;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;

  @override
  State<_SearchSurface> createState() => _SearchSurfaceState();
}

class _SearchSurfaceState extends State<_SearchSurface> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.query);
  }

  @override
  void didUpdateWidget(covariant _SearchSurface oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.query != controller.text) {
      controller.text = widget.query;
      controller.selection =
          TextSelection.collapsed(offset: widget.query.length);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: UlesColors.hairline),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(.04),
              blurRadius: 18,
              offset: const Offset(0, 10)),
        ],
      ),
      child: Row(
        children: [
          Icon(PhosphorIcons.magnifyingGlass(),
              color: UlesColors.muted, size: 21),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: widget.onChanged,
              onSubmitted: widget.onSubmitted,
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                hintText: 'Поиск или ссылка на товар',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
                isDense: true,
                hintStyle: TextStyle(
                  color: UlesColors.muted,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
                color: UlesColors.softBlue,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: UlesColors.primary.withOpacity(.1))),
            child: const Text('URL',
                style: TextStyle(
                    color: UlesColors.primary,
                    fontWeight: FontWeight.w900,
                    fontSize: 12)),
          ),
        ],
      ),
    );
  }
}

class _InsightsRow extends StatelessWidget {
  const _InsightsRow(
      {required this.closedGroups,
      required this.savedAmount,
      required this.hotGroups});

  final int closedGroups;
  final int savedAmount;
  final int hotGroups;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _MetricCard(value: '$closedGroups', label: 'групп')),
        const SizedBox(width: 10),
        Expanded(
            child:
                _MetricCard(value: compactKzt(savedAmount), label: 'экономия')),
        const SizedBox(width: 10),
        Expanded(child: _MetricCard(value: '$hotGroups', label: 'горячие')),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Glass(
      radius: 20,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
      opacity: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900, color: UlesColors.primary)),
          const SizedBox(height: 2),
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

class _ExplainableFeedCard extends StatelessWidget {
  const _ExplainableFeedCard();

  @override
  Widget build(BuildContext context) {
    return Glass(
      radius: 24,
      padding: const EdgeInsets.all(16),
      opacity: 1,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
                color: UlesColors.softBlue,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: UlesColors.primary.withOpacity(.1))),
            child: Icon(PhosphorIcons.sparkle(), color: UlesColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Почему эти товары?',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text(
                    'Лента считает интересы, бюджет, спрос в городе и близость группы к закрытию.',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: UlesColors.muted,
                        fontWeight: FontWeight.w700,
                        height: 1.25)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip(
      {required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? UlesColors.ink : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
              color: selected ? UlesColors.ink : UlesColors.hairline),
        ),
        child: Text(label,
            style: TextStyle(
                color: selected ? Colors.white : UlesColors.ink,
                fontWeight: FontWeight.w900)),
      ),
    );
  }
}

class _EmptyFeedState extends StatelessWidget {
  const _EmptyFeedState();

  @override
  Widget build(BuildContext context) {
    return Glass(
      radius: 28,
      padding: const EdgeInsets.all(24),
      opacity: 1,
      child: Column(
        children: [
          Icon(PhosphorIcons.linkSimple(), color: UlesColors.primary, size: 44),
          const SizedBox(height: 12),
          Text('Вставьте ссылку на товар',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          Text(
              'Ules создаст группу, посчитает экономику и покажет честный Group Passport.',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: UlesColors.muted, height: 1.35)),
        ],
      ),
    );
  }
}

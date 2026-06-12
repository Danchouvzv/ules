import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../app/state.dart';
import '../../core/theme.dart';
import '../../l10n/ules_localizations.dart';
import '../../models/product.dart';
import '../../widgets/formatters.dart';

class SetupScreen extends ConsumerWidget {
  const SetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final l = UlesLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    return Scaffold(
      appBar: AppBar(title: Text(l.t('aboutYou'))),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(22),
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: UlesColors.lightCard,
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: UlesColors.primary.withOpacity(.08)),
                boxShadow: [
                  BoxShadow(
                      color: UlesColors.primary.withOpacity(.08),
                      blurRadius: 24,
                      offset: const Offset(0, 14))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Персональная лента',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w900)),
                  const SizedBox(height: 8),
                  Text(
                      'Эти данные реально влияют на скоринг товаров: бюджет, город и интересы меняют порядок ленты.',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: UlesColors.muted, height: 1.35)),
                  const SizedBox(height: 18),
                  TextFormField(
                    initialValue: profile.name,
                    decoration: _input(l.t('name')),
                    onChanged: (value) => ref
                        .read(sessionProvider.notifier)
                        .updateProfile(profile.copyWith(name: value)),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: profile.city,
                    decoration: _input(l.t('city')),
                    items: [
                      'Алматы',
                      'Астана',
                      'Шымкент',
                      'Караганда',
                      'Актобе'
                    ]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) => ref
                        .read(sessionProvider.notifier)
                        .updateProfile(profile.copyWith(city: value)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                  color: UlesColors.primary.withOpacity(.06),
                  borderRadius: BorderRadius.circular(24)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${l.t('budget')}: ${kzt(profile.budget)}',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w900)),
                  Slider(
                    value: profile.budget.toDouble(),
                    min: 0,
                    max: 500000,
                    divisions: 50,
                    activeColor: UlesColors.green,
                    onChanged: (value) => ref
                        .read(sessionProvider.notifier)
                        .updateProfile(profile.copyWith(budget: value.round())),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            Text(l.t('chooseInterests'),
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 14),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: ProductCategory.values.map((category) {
                final selected = profile.interests.contains(category);
                return ChoiceChip(
                  selected: selected,
                  selectedColor: UlesColors.green,
                  avatar: Icon(_icon(category),
                      size: 18, color: selected ? Colors.black : null),
                  label: Text(category.label(lang)),
                  labelStyle: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: selected ? Colors.black : null),
                  onSelected: (_) {
                    HapticFeedback.selectionClick();
                    ref.read(sessionProvider.notifier).toggleInterest(category);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 28),
            FilledButton(
              onPressed: () {
                ref.read(sessionProvider.notifier).finishOnboarding();
                context.go('/feed');
              },
              child: Text(l.t('save')),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _input(String label) => InputDecoration(
        filled: true,
        fillColor: UlesColors.primary.withOpacity(.045),
        labelText: label,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none),
      );

  IconData _icon(ProductCategory category) => switch (category) {
        ProductCategory.electronics => PhosphorIcons.deviceMobile(),
        ProductCategory.home => PhosphorIcons.house(),
        ProductCategory.beauty => PhosphorIcons.sparkle(),
        ProductCategory.sport => PhosphorIcons.barbell(),
        ProductCategory.kids => PhosphorIcons.baby(),
        ProductCategory.auto => PhosphorIcons.car(),
        ProductCategory.fashion => PhosphorIcons.tShirt(),
        ProductCategory.travel => PhosphorIcons.airplaneTilt(),
      };
}

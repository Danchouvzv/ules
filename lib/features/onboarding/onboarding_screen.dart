import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../core/theme.dart';
import '../../l10n/ules_localizations.dart';
import '../../widgets/formatters.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = PageController();
  int index = 0;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = UlesLocalizations.of(context);
    final slides = [
      _SlideData(
        icon: PhosphorIcons.usersThree(),
        title: l.t('buyTogether'),
        body: l.t('buyTogetherBody'),
        accent: UlesColors.green,
        priceBefore: 42000,
        priceAfter: 26900,
        participants: 8,
        reason: 'Группа почти закрыта · осталось 2 места',
      ),
      _SlideData(
        icon: PhosphorIcons.chartLineUp(),
        title: l.t('honestFeed'),
        body: l.t('honestFeedBody'),
        accent: UlesColors.primary,
        priceBefore: 89000,
        priceAfter: 57900,
        participants: 7,
        reason: 'Интересы 92% · бюджет 88% · Алматы 95%',
      ),
      _SlideData(
        icon: PhosphorIcons.shieldCheck(),
        title: l.t('esimShield'),
        body: l.t('esimShieldBody'),
        accent: UlesColors.lime,
        priceBefore: 36000,
        priceAfter: 21900,
        participants: 9,
        reason: 'Verified Device · Kaspi hold без списания',
      ),
    ];

    return Theme(
      data: UlesTheme.light(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          body: Stack(
            children: [
              const _OnboardingBackdrop(),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(22, 14, 22, 22),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const _BrandMark(),
                          const Spacer(),
                          TextButton(
                            onPressed: () => context.go('/register'),
                            child: const Text('Пропустить',
                                style: TextStyle(
                                    color: UlesColors.muted,
                                    fontWeight: FontWeight.w800)),
                          ),
                        ],
                      ),
                      Expanded(
                        child: PageView.builder(
                          controller: controller,
                          itemCount: slides.length,
                          onPageChanged: (value) {
                            HapticFeedback.selectionClick();
                            setState(() => index = value);
                          },
                          itemBuilder: (context, i) =>
                              _SlideView(data: slides[i]),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: _PageDots(
                                  count: slides.length, index: index)),
                          const SizedBox(width: 14),
                          SizedBox(
                            width: 168,
                            child: FilledButton(
                              onPressed: () {
                                HapticFeedback.selectionClick();
                                if (index == slides.length - 1) {
                                  context.go('/register');
                                } else {
                                  controller.nextPage(
                                      duration: 520.ms,
                                      curve: Curves.easeInOutCubic);
                                }
                              },
                              child: Text(index == slides.length - 1
                                  ? l.t('start')
                                  : l.t('next')),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SlideData {
  const _SlideData({
    required this.icon,
    required this.title,
    required this.body,
    required this.accent,
    required this.priceBefore,
    required this.priceAfter,
    required this.participants,
    required this.reason,
  });

  final IconData icon;
  final String title;
  final String body;
  final Color accent;
  final int priceBefore;
  final int priceAfter;
  final int participants;
  final String reason;
}

class _SlideView extends StatelessWidget {
  const _SlideView({required this.data});

  final _SlideData data;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxHeight < 650;
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _HeroProductCard(data: data, compact: compact),
            SizedBox(height: compact ? 24 : 34),
            Text(
              data.title,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .displaySmall
                  ?.copyWith(fontWeight: FontWeight.w900, height: 1.02),
            ),
            const SizedBox(height: 14),
            Text(
              data.body,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.35,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        );
      },
    );
  }
}

class _HeroProductCard extends StatelessWidget {
  const _HeroProductCard({required this.data, required this.compact});

  final _SlideData data;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final saving = data.priceBefore - data.priceAfter;
    return Container(
      constraints: BoxConstraints(maxHeight: compact ? 300 : 360),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: UlesColors.slate,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.white.withOpacity(.08)),
        boxShadow: [
          BoxShadow(
              color: UlesColors.slate.withOpacity(.2),
              blurRadius: 30,
              offset: const Offset(0, 18))
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(.12)),
                ),
                child: Icon(data.icon, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ules Trust Passport',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w900)),
                    Text(data.reason,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(
                                color: Colors.white.withOpacity(.64),
                                fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: compact ? 16 : 22),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(kzt(data.priceBefore),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                                color: Colors.white.withOpacity(.48),
                                decoration: TextDecoration.lineThrough,
                                decorationColor: Colors.white.withOpacity(.48),
                                fontWeight: FontWeight.w800)),
                    Text(kzt(data.priceAfter),
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
                            ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w900)),
                    Text('экономия ${kzt(saving)}',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: UlesColors.green,
                            fontWeight: FontWeight.w900)),
                  ],
                ),
              ),
              _SavingsRing(
                  value: data.participants / 10,
                  label: '${data.participants}/10'),
            ],
          ),
          SizedBox(height: compact ? 16 : 22),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: data.participants / 10,
              minHeight: 11,
              backgroundColor: Colors.white.withOpacity(.14),
              valueColor: const AlwaysStoppedAnimation(UlesColors.green),
            ),
          ),
          const SizedBox(height: 14),
          const Row(
            children: [
              _MiniTrust(icon: PhosphorIcons.shieldCheck, text: 'eSIM'),
              SizedBox(width: 8),
              _MiniTrust(icon: PhosphorIcons.creditCard, text: 'Kaspi'),
              SizedBox(width: 8),
              _MiniTrust(icon: PhosphorIcons.truck, text: 'KZ'),
            ],
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 420.ms)
        .slideY(begin: .05, duration: 520.ms, curve: Curves.easeOutCubic);
  }
}

class _SavingsRing extends StatelessWidget {
  const _SavingsRing({required this.value, required this.label});

  final double value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 82,
      height: 82,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
              value: value,
              strokeWidth: 8,
              color: UlesColors.green,
              backgroundColor: UlesColors.primary.withOpacity(.08)),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class _MiniTrust extends StatelessWidget {
  const _MiniTrust({required this.icon, required this.text});

  final IconData Function([PhosphorIconsStyle style]) icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: UlesColors.hairline),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon(), size: 16, color: UlesColors.green),
            const SizedBox(width: 6),
            Flexible(
                child: Text(text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.w900, fontSize: 12))),
          ],
        ),
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            gradient: const LinearGradient(
                colors: [UlesColors.primary, UlesColors.green]),
          ),
          child: const Center(
              child: Text('U',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 20))),
        ),
        const SizedBox(width: 10),
        Text('Ules',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.w900)),
      ],
    );
  }
}

class _PageDots extends StatelessWidget {
  const _PageDots({required this.count, required this.index});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(count, (i) {
        return AnimatedContainer(
          duration: 280.ms,
          margin: const EdgeInsets.only(right: 7),
          width: i == index ? 34 : 9,
          height: 9,
          decoration: BoxDecoration(
              color: i == index ? UlesColors.ink : UlesColors.hairline,
              borderRadius: BorderRadius.circular(99)),
        );
      }),
    );
  }
}

class _OnboardingBackdrop extends StatelessWidget {
  const _OnboardingBackdrop();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Color(0xFFF8FAFC)],
        ),
      ),
      child: SizedBox.expand(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../core/theme.dart';
import '../../l10n/ules_localizations.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = PageController();
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final l = UlesLocalizations.of(context);
    final slides = [
      (PhosphorIcons.usersThree(), l.t('buyTogether'), l.t('buyTogetherBody'), UlesColors.green),
      (PhosphorIcons.chartLineUp(), l.t('honestFeed'), l.t('honestFeedBody'), UlesColors.primary),
      (PhosphorIcons.shieldCheck(), l.t('esimShield'), l.t('esimShieldBody'), UlesColors.lime),
    ];
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: controller,
                  itemCount: slides.length,
                  onPageChanged: (value) => setState(() => index = value),
                  itemBuilder: (context, i) {
                    final slide = slides[i];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 210,
                          height: 210,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(colors: [slide.$4.withOpacity(.65), UlesColors.primary.withOpacity(.18)]),
                          ),
                          child: Icon(slide.$1, size: 104, color: Colors.white),
                        ).animate().scale(duration: 650.ms, curve: Curves.easeOutBack),
                        const SizedBox(height: 44),
                        Text(slide.$2, textAlign: TextAlign.center, style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w900)),
                        const SizedBox(height: 14),
                        Text(slide.$3, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant, height: 1.35)),
                      ],
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(slides.length, (i) {
                  return AnimatedContainer(
                    duration: 280.ms,
                    margin: const EdgeInsets.all(4),
                    width: i == index ? 28 : 8,
                    height: 8,
                    decoration: BoxDecoration(color: i == index ? UlesColors.green : Colors.white24, borderRadius: BorderRadius.circular(99)),
                  );
                }),
              ),
              const SizedBox(height: 22),
              FilledButton(
                onPressed: () {
                  HapticFeedback.selectionClick();
                  if (index == slides.length - 1) {
                    context.go('/register');
                  } else {
                    controller.nextPage(duration: 420.ms, curve: Curves.easeInOutCubic);
                  }
                },
                child: Text(index == slides.length - 1 ? l.t('start') : l.t('next')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../app/state.dart';
import '../../core/theme.dart';
import '../../l10n/ules_localizations.dart';

class EsimScreen extends ConsumerStatefulWidget {
  const EsimScreen({super.key});

  @override
  ConsumerState<EsimScreen> createState() => _EsimScreenState();
}

class _EsimScreenState extends ConsumerState<EsimScreen> {
  bool done = false;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(1700.ms, () {
      if (mounted) {
        HapticFeedback.mediumImpact();
        setState(() => done = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = UlesLocalizations.of(context);
    final esim = ref.watch(esimProvider);
    return Theme(
      data: UlesTheme.light(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: IosPageBackground(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(22, 18, 22, 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('Device Vault',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w900)),
                        const Spacer(),
                        _SecureChip(done: done),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Привязываем одно место в группе к вашему устройству. Это защищает цену от фейковых аккаунтов.',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: UlesColors.muted,
                          height: 1.32,
                          fontWeight: FontWeight.w600),
                    ),
                    const Spacer(),
                    Center(
                      child: AnimatedSwitcher(
                        duration: 520.ms,
                        child: done
                            ? _VerifiedVault(
                                operatorName: esim.operatorName,
                                simId: esim.simId)
                            : const _ScanningVault(),
                      ),
                    ),
                    const Spacer(),
                    _ProtectionSteps(done: done),
                    const SizedBox(height: 18),
                    FilledButton(
                      onPressed: done ? () => context.go('/setup') : null,
                      child: Text(
                          done ? l.t('continueText') : l.t('verifyDevice')),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SecureChip extends StatelessWidget {
  const _SecureChip({required this.done});
  final bool done;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
          color:
              (done ? UlesColors.green : UlesColors.primary).withOpacity(.12),
          borderRadius: BorderRadius.circular(999)),
      child: Row(
        children: [
          Icon(done ? PhosphorIcons.shieldCheck() : PhosphorIcons.fingerprint(),
              size: 16,
              color: done ? const Color(0xFF047857) : UlesColors.primary),
          const SizedBox(width: 6),
          Text(done ? 'Verified' : 'Scanning',
              style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: done ? const Color(0xFF047857) : UlesColors.primary)),
        ],
      ),
    );
  }
}

class _ScanningVault extends StatelessWidget {
  const _ScanningVault();

  @override
  Widget build(BuildContext context) {
    return Glass(
      key: const ValueKey('scan'),
      radius: 36,
      padding: const EdgeInsets.all(28),
      opacity: .74,
      child: SizedBox(
        width: 250,
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                    width: 164,
                    height: 164,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: UlesColors.primary.withOpacity(.14),
                            width: 18))),
                Container(
                    width: 132,
                    height: 132,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: UlesColors.primary.withOpacity(.08),
                        border: Border.all(
                            color: UlesColors.primary.withOpacity(.18)))),
                Icon(PhosphorIcons.fingerprint(),
                    size: 78, color: UlesColors.primary),
              ],
            ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1300.ms),
            const SizedBox(height: 22),
            Text('Сканируем eSIM профиль',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            Text('Проверяем оператора, устройство и уникальность места',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: UlesColors.muted)),
          ],
        ),
      ),
    );
  }
}

class _VerifiedVault extends StatelessWidget {
  const _VerifiedVault({required this.operatorName, required this.simId});

  final String operatorName;
  final String simId;

  @override
  Widget build(BuildContext context) {
    return Glass(
      key: const ValueKey('done'),
      radius: 36,
      padding: const EdgeInsets.all(24),
      opacity: .8,
      child: SizedBox(
        width: 292,
        child: Column(
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                      colors: [UlesColors.green, UlesColors.primary])),
              child: Icon(PhosphorIcons.shieldCheck(),
                  color: Colors.white, size: 52),
            ).animate().scale(curve: Curves.easeOutBack),
            const SizedBox(height: 18),
            Text(simId,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900, color: UlesColors.primary)),
            const SizedBox(height: 8),
            Text('Оператор: $operatorName',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: UlesColors.green.withOpacity(.1),
                  borderRadius: BorderRadius.circular(18)),
              child: const Text('1 eSIM ID = 1 честное место в группе',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0xFF047857), fontWeight: FontWeight.w900)),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProtectionSteps extends StatelessWidget {
  const _ProtectionSteps({required this.done});
  final bool done;

  @override
  Widget build(BuildContext context) {
    final steps = [
      ('Device attestation', 'устройство привязано'),
      ('Operator check', 'проверка оператора KZ'),
      ('Seat lock', 'место закреплено'),
    ];
    return Glass(
      radius: 24,
      padding: const EdgeInsets.all(16),
      opacity: .72,
      child: Column(
        children: [
          for (var i = 0; i < steps.length; i++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Row(
                children: [
                  Icon(
                      done || i == 0
                          ? PhosphorIcons.checkCircle()
                          : PhosphorIcons.circle(),
                      color:
                          done || i == 0 ? UlesColors.green : UlesColors.muted,
                      size: 21),
                  const SizedBox(width: 10),
                  Expanded(
                      child: Text(steps[i].$1,
                          style: const TextStyle(fontWeight: FontWeight.w900))),
                  Text(steps[i].$2,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: UlesColors.muted,
                          fontWeight: FontWeight.w700)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../app/state.dart';
import '../../core/theme.dart';
import '../../l10n/ules_localizations.dart';
import '../../widgets/esim_card.dart';

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
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
              const Spacer(),
              AnimatedSwitcher(
                duration: 450.ms,
                child: done
                    ? Column(
                        key: const ValueKey('done'),
                        children: [
                          Icon(PhosphorIcons.shieldCheck(), size: 110, color: UlesColors.green).animate().scale(curve: Curves.easeOutBack),
                          const SizedBox(height: 22),
                          EsimCard(esim: esim),
                        ],
                      )
                    : Column(
                        key: const ValueKey('scan'),
                        children: [
                          Container(
                            width: 190,
                            height: 190,
                            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: UlesColors.primary, width: 2)),
                            child: Icon(PhosphorIcons.fingerprint(), size: 92, color: UlesColors.primary),
                          ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1200.ms),
                          const SizedBox(height: 24),
                          Text(l.t('scanDevice'), style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                        ],
                      ),
              ),
              const Spacer(),
              FilledButton(
                onPressed: done ? () => context.go('/setup') : null,
                child: Text(done ? l.t('continueText') : l.t('verifyDevice')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

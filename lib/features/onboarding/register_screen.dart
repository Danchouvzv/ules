import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../core/theme.dart';
import '../../l10n/ules_localizations.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final controller = TextEditingController(text: '+7 ');
  bool kaspiReady = true;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = UlesLocalizations.of(context);
    return Theme(
      data: UlesTheme.light(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          body: Stack(
            children: [
              const _RegisterBackdrop(),
              SafeArea(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(22, 18, 22, 28),
                  children: [
                    Row(
                      children: [
                        IconButton.filledTonal(
                          onPressed: () => context.go('/onboarding'),
                          icon: Icon(PhosphorIcons.arrowLeft()),
                        ),
                        const Spacer(),
                        const _SecurePill(),
                      ],
                    ),
                    const SizedBox(height: 26),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: UlesColors.slate,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: UlesColors.slate.withOpacity(.18),
                            blurRadius: 28,
                            offset: const Offset(0, 16),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Войдите в Ules',
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall
                                ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    height: 1),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Один номер, одно eSIM-место, Kaspi hold и паспорт группы с прозрачной экономикой сделки.',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Colors.white.withOpacity(.72),
                                  height: 1.35,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(26),
                        border: Border.all(color: UlesColors.hairline),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(.06),
                              blurRadius: 26,
                              offset: const Offset(0, 14))
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Номер телефона',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w900)),
                          const SizedBox(height: 12),
                          TextField(
                            controller: controller,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9+ ]'))
                            ],
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w900),
                            decoration: InputDecoration(
                              hintText: '+7 777 000 00 00',
                              prefixIcon: Padding(
                                padding:
                                    const EdgeInsets.only(left: 14, right: 10),
                                child: Icon(PhosphorIcons.deviceMobile(),
                                    color: UlesColors.green),
                              ),
                              prefixIconConstraints:
                                  const BoxConstraints(minWidth: 48),
                              filled: true,
                              fillColor: UlesColors.canvas,
                              hintStyle: TextStyle(
                                  color: UlesColors.muted.withOpacity(.72),
                                  fontWeight: FontWeight.w700),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide.none),
                            ),
                          ),
                          const SizedBox(height: 14),
                          _InlineStatus(
                            icon: PhosphorIcons.checkCircle(),
                            title: 'Казахстанский номер',
                            body: 'Поддерживаем Kcell, Beeline, Tele2 и Altel',
                          ),
                          const SizedBox(height: 10),
                          _KaspiToggle(
                            value: kaspiReady,
                            onChanged: (value) {
                              HapticFeedback.selectionClick();
                              setState(() => kaspiReady = value);
                            },
                          ),
                          const SizedBox(height: 18),
                          FilledButton(
                            onPressed: () {
                              HapticFeedback.mediumImpact();
                              context.go('/esim');
                            },
                            child: Text(l.t('continueText')),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    const _TrustChecklist(),
                    const SizedBox(height: 22),
                    Text(
                      'Продолжая, вы соглашаетесь на device-bound verification. Деньги не списываются до закрытия группы.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          height: 1.35),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SecurePill extends StatelessWidget {
  const _SecurePill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
          color: UlesColors.green.withOpacity(.14),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: UlesColors.green.withOpacity(.16))),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(PhosphorIcons.lockKey(), color: UlesColors.green, size: 16),
          const SizedBox(width: 7),
          const Text('Secure',
              style: TextStyle(
                  color: UlesColors.green, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class _InlineStatus extends StatelessWidget {
  const _InlineStatus(
      {required this.icon, required this.title, required this.body});

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: UlesColors.green, size: 22),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
              Text(body,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
      ],
    );
  }
}

class _KaspiToggle extends StatelessWidget {
  const _KaspiToggle({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: UlesColors.canvas,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: UlesColors.hairline),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
                color: const Color(0xFFE42235),
                borderRadius: BorderRadius.circular(14)),
            child: const Center(
                child: Text('K',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 22))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Kaspi Pay hold',
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.w900)),
                Text('списание только после сбора группы',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
          Switch(
              value: value,
              activeColor: UlesColors.green,
              onChanged: onChanged),
        ],
      ),
    );
  }
}

class _TrustChecklist extends StatelessWidget {
  const _TrustChecklist();

  @override
  Widget build(BuildContext context) {
    final items = [
      (PhosphorIcons.shieldCheck(), 'eSIM защищает место в группе'),
      (
        PhosphorIcons.arrowCounterClockwise(),
        'автовозврат, если группа не соберётся'
      ),
      (PhosphorIcons.translate(), 'RU/KZ интерфейс и цены в тенге'),
    ];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: UlesColors.hairline),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(.045),
              blurRadius: 22,
              offset: const Offset(0, 12))
        ],
      ),
      child: Column(
        children: [
          for (final item in items)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Row(
                children: [
                  Icon(item.$1, color: UlesColors.green, size: 21),
                  const SizedBox(width: 10),
                  Expanded(
                      child: Text(item.$2,
                          style: const TextStyle(fontWeight: FontWeight.w800))),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _RegisterBackdrop extends StatelessWidget {
  const _RegisterBackdrop();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Color(0xFFF8FAFC),
            Colors.white,
          ],
          stops: [0, .52, 1],
        ),
      ),
      child: SizedBox.expand(),
    );
  }
}

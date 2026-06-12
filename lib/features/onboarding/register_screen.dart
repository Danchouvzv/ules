import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/ules_localizations.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = UlesLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Ules')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Text('Создайте аккаунт', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w900)),
              const SizedBox(height: 18),
              TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: l.t('phoneEmail'),
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 18),
              FilledButton(onPressed: () => context.go('/esim'), child: Text(l.t('continueText'))),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}

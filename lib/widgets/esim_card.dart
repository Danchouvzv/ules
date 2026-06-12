import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../core/theme.dart';
import '../models/product.dart';

class EsimCard extends StatelessWidget {
  const EsimCard({required this.esim, this.compact = false, super.key});
  final EsimProfile esim;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(compact ? 14 : 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [UlesColors.primary.withOpacity(.35), UlesColors.green.withOpacity(.18)]),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: UlesColors.green.withOpacity(.35)),
      ),
      child: Row(
        children: [
          Container(
            width: compact ? 42 : 54,
            height: compact ? 42 : 54,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: UlesColors.green),
            child: Icon(PhosphorIcons.shieldCheck(), color: Colors.black, size: compact ? 24 : 30),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Профиль защищён eSIM ID', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text('Оператор: ${esim.operatorName} · ${esim.simId}', style: Theme.of(context).textTheme.bodySmall),
                if (!compact) ...[
                  const SizedBox(height: 8),
                  Text('Это место в группе закреплено за этим устройством — никто не сможет его подделать', style: Theme.of(context).textTheme.bodySmall),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

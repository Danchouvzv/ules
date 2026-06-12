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
    return Glass(
      radius: 20,
      padding: EdgeInsets.all(compact ? 14 : 18),
      opacity: .98,
      child: Row(
        children: [
          Container(
            width: compact ? 42 : 54,
            height: compact ? 42 : 54,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: UlesColors.softGreen,
                border: Border.all(color: UlesColors.green.withOpacity(.18))),
            child: Icon(PhosphorIcons.shieldCheck(),
                color: UlesColors.green, size: compact ? 24 : 30),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Профиль защищён eSIM ID',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text('Оператор: ${esim.operatorName} · ${esim.simId}',
                    style: Theme.of(context).textTheme.bodySmall),
                if (!compact) ...[
                  const SizedBox(height: 8),
                  Text(
                      'Это место в группе закреплено за этим устройством — никто не сможет его подделать',
                      style: Theme.of(context).textTheme.bodySmall),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

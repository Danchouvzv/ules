import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AvatarStack extends StatelessWidget {
  const AvatarStack({required this.count, this.max = 5, super.key});

  final int count;
  final int max;

  @override
  Widget build(BuildContext context) {
    final visible = count.clamp(1, max);
    return SizedBox(
      height: 34,
      width: 24.0 * visible + 20,
      child: Stack(
        children: [
          for (var i = 0; i < visible; i++)
            Positioned(
              left: i * 22,
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Theme.of(context).scaffoldBackgroundColor, width: 2),
                  gradient: LinearGradient(
                    colors: [
                      Color.lerp(const Color(0xFF4F46E5), const Color(0xFF00E676), i / visible)!,
                      Color.lerp(const Color(0xFF00E676), const Color(0xFFFFB020), i / visible)!,
                    ],
                  ),
                ),
                child: Center(
                  child: Text(
                    ['А', 'Н', 'М', 'Е', 'S'][i % 5],
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12),
                  ),
                ),
              ).animate(key: ValueKey('$count-$i')).scale(begin: const Offset(.7, .7), duration: 360.ms),
            ),
        ],
      ),
    );
  }
}

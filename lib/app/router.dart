import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'state.dart';
import '../features/feed/feed_screen.dart';
import '../features/group/group_join_screen.dart';
import '../features/onboarding/esim_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/onboarding/register_screen.dart';
import '../features/order/order_status_screen.dart';
import '../features/product/product_detail_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/profile/setup_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const BootstrapScreen()),
      GoRoute(path: '/onboarding', builder: (context, state) => const OnboardingScreen()),
      GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
      GoRoute(path: '/esim', builder: (context, state) => const EsimScreen()),
      GoRoute(path: '/setup', builder: (context, state) => const SetupScreen()),
      GoRoute(path: '/feed', builder: (context, state) => const FeedScreen()),
      GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),
      GoRoute(
        path: '/product/:id',
        builder: (context, state) => ProductDetailScreen(productId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/group/:id',
        builder: (context, state) => GroupJoinScreen(productId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/order/:id',
        builder: (context, state) => OrderStatusScreen(productId: state.pathParameters['id']!),
      ),
    ],
  );
});

class BootstrapScreen extends ConsumerWidget {
  const BootstrapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    if (!session.isLoaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        context.go(session.didFinishOnboarding ? '/feed' : '/onboarding');
      }
    });
    return const Scaffold(body: SizedBox.shrink());
  }
}

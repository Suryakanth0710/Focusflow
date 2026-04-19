import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/premium_provider.dart';
import '../services/razorpay_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final premium = context.watch<PremiumProvider>();
    final user = auth.user!;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Profile', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                title: Text(user.displayName ?? 'FocusFlow User'),
                subtitle: Text(user.email ?? ''),
                leading: const CircleAvatar(child: Icon(Icons.person_outline_rounded)),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Subscription: ${premium.isPremium ? 'Premium' : 'Free'}'),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: premium.isPremium
                          ? null
                          : () => _buyPremium(context, user.uid, user.email ?? 'user@example.com'),
                      child: const Text('Go Premium'),
                    ),
                    const SizedBox(height: 8),
                    const Text('Premium unlocks unlimited tasks, analytics, and priority notifications.'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                title: const Text('Advanced Analytics (Premium)'),
                subtitle: const Text('Placeholder charts and productivity heatmaps for MVP.'),
                trailing: Icon(premium.isPremium ? Icons.lock_open : Icons.lock_outline),
              ),
            ),
            const Spacer(),
            OutlinedButton(onPressed: auth.signOut, child: const Text('Sign Out')),
          ],
        ),
      ),
    );
  }

  /// Handles Razorpay checkout and updates premium flag in Firestore.
  Future<void> _buyPremium(BuildContext context, String uid, String email) async {
    try {
      final ok = await RazorpayService.instance.openCheckout(email: email, contact: '9999999999');
      if (!context.mounted) return;
      if (ok) {
        await context.read<PremiumProvider>().setPremium(uid, true);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Premium activated')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payment failed')));
      }
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to launch payment. Check network/configuration.')),
      );
    }
  }
}

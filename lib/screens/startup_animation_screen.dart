import 'package:flutter/material.dart';
// import 'package:mintworth/theme.dart'; // Adjust import if needed

class StartupAnimationScreen extends StatefulWidget {
  final VoidCallback onAnimationComplete;
  const StartupAnimationScreen({Key? key, required this.onAnimationComplete}) : super(key: key);

  @override
  State<StartupAnimationScreen> createState() => _StartupAnimationScreenState();
}

class _StartupAnimationScreenState extends State<StartupAnimationScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 2), vsync: this)
      ..forward()
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Future.delayed(const Duration(milliseconds: 600), () {
            widget.onAnimationComplete();
          });
        }
      });
    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.primaryContainer,
      body: Center(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.savings, size: 90, color: theme.colorScheme.primary),
              const SizedBox(height: 24),
              Text(
                "Mint",
                style: theme.textTheme.displaySmall!.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              Text(
                "Financial Literacy",
                style: theme.textTheme.titleMedium!.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

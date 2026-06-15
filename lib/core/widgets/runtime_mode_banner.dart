import 'package:flutter/material.dart';

import 'package:stasisly/core/config/app_environment.dart';

/// Makes non-production runtime state visible without presenting demo as real.
class RuntimeModeBanner extends StatelessWidget {
  const RuntimeModeBanner({
    required this.environment,
    required this.child,
    super.key,
  });

  final AppEnvironment environment;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (environment.mode == AppRuntimeMode.production) return child;

    return Column(
      children: [
        Material(
          color: environment.isDemo
              ? const Color(0xFF7C3AED)
              : const Color(0xFFB45309),
          child: SafeArea(
            bottom: false,
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  environment.visibleLabel,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(child: child),
      ],
    );
  }
}

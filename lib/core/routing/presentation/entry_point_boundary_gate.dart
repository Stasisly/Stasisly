import 'package:flutter/material.dart';

import 'package:stasisly/core/routing/domain/boundary_decision.dart';

class EntryPointBoundaryGate extends StatelessWidget {
  const EntryPointBoundaryGate({
    required this.decision,
    required this.childBuilder,
    super.key,
  });

  final BoundaryDecision decision;
  final WidgetBuilder childBuilder;

  @override
  Widget build(BuildContext context) {
    if (decision.isAllowed) return childBuilder(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              _message(decision.safeUserMessageKey),
              key: const Key('entry-point-boundary-message'),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  String _message(BoundarySafeUserMessageKey key) {
    return switch (key) {
      BoundarySafeUserMessageKey.authenticationRequired =>
        'Autenticación requerida.',
      BoundarySafeUserMessageKey.environmentBlocked =>
        'Esta capacidad no está disponible en este entorno.',
      BoundarySafeUserMessageKey.legacyUnavailable =>
        'Esta capacidad heredada no está disponible.',
      BoundarySafeUserMessageKey.notAvailable =>
        'Esta página no está disponible.',
      BoundarySafeUserMessageKey.accessDenied => 'Acceso denegado.',
      BoundarySafeUserMessageKey.none => '',
    };
  }
}

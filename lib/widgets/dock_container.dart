import 'package:flutter/material.dart';

import '../constants/dock_constants.dart';

class DockContainer extends StatelessWidget {
  final Widget child;

  const DockContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(DockConstants.borderRadius),
          color: Colors.black.withOpacity(0.2),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 15,
              spreadRadius: 5,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        constraints: const BoxConstraints(
          minHeight: DockConstants.baseHeight + 16,
          maxHeight: DockConstants.baseHeight + 16,
        ),
        child: IntrinsicWidth(child: child),
      ),
    );
  }
}

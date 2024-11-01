import 'package:flutter/material.dart';

import '../constants/dock_constants.dart';

class DockPositionController {
  static Offset calculateOffset(
      int index, int? draggedIndex, int? targetIndex, bool isOutsideDock) {
    if (draggedIndex == null || targetIndex == null || isOutsideDock) {
      return Offset.zero;
    }

    if (draggedIndex < targetIndex) {
      if (index > draggedIndex && index <= targetIndex) {
        return const Offset(-1.0, 0.0);
      }
    } else if (draggedIndex > targetIndex) {
      if (index < draggedIndex && index >= targetIndex) {
        return const Offset(1.0, 0.0);
      }
    }
    return Offset.zero;
  }

  static void updateTargetIndex(
    Offset position,
    int? draggedIndex,
    int itemsLength,
    Function(int) onTargetIndexChanged,
  ) {
    if (draggedIndex == null) return;

    final double dx = position.dx;
    for (int i = 0; i < itemsLength; i++) {
      if (i == draggedIndex) continue;

      final double itemStart =
          i * (DockConstants.baseWidth + DockConstants.itemSpacing);
      final double itemCenter =
          itemStart + (DockConstants.baseWidth + DockConstants.itemSpacing) / 2;

      if (dx < itemCenter) {
        onTargetIndexChanged(i);
        return;
      }
    }

    onTargetIndexChanged(itemsLength - 1);
  }
}

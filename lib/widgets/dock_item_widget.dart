import 'package:flutter/material.dart';

import '../constants/dock_constants.dart';
import '../models/dock_item.dart';

class DockItemWidget extends StatelessWidget {
  final DockItem item;

  const DockItemWidget({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: DockConstants.baseWidth,
      height: DockConstants.baseHeight,
      margin: const EdgeInsets.symmetric(
        horizontal: DockConstants.itemSpacing / 2,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(DockConstants.itemBorderRadius),
        color: item.color ??
            Colors.primaries[item.icon.hashCode % Colors.primaries.length],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Center(
        child: Icon(
          item.icon,
          color: Colors.white,
          size: DockConstants.iconSize,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class DockItem {
  final IconData icon;
  final Color? color;
  final VoidCallback? onTap;

  const DockItem({
    required this.icon,
    this.color,
    this.onTap,
  });
}

import 'package:flutter/material.dart';

import '../constants/dock_constants.dart';
import '../models/dock_item.dart';
import 'dock_container.dart';
import 'dock_item_widget.dart';

class Dock extends StatefulWidget {
  final List<DockItem> items;

  const Dock({
    super.key,
    required this.items,
  });

  @override
  State<Dock> createState() => _DockState();
}

class _DockState extends State<Dock> {
  late final List<DockItem> _items = List.from(widget.items);
  int? _draggedIndex;
  int? _targetIndex;
  bool _isOutsideDock = false;

  @override
  Widget build(BuildContext context) {
    return DockContainer(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_items.length, (index) {
          return _buildAnimatedItem(index);
        }),
      ),
    );
  }

  Widget _buildAnimatedItem(int index) {
    return AnimatedSlide(
      duration: Duration(milliseconds: _targetIndex != null ? 200 : 0),
      offset: _calculateOffset(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: _shouldShrink(index) ? 0 : DockConstants.baseWidth,
        child: _buildDraggableItem(index),
      ),
    );
  }

  Widget _buildDraggableItem(int index) {
    return Draggable<int>(
      data: index,
      feedback: Material(
        color: Colors.transparent,
        child: DockItemWidget(item: _items[index]),
      ),
      childWhenDragging: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: DockConstants.itemSpacing / 2,
        ),
      ),
      onDragStarted: () => _handleDragStart(index),
      onDragEnd: _handleDragEnd,
      onDragUpdate: _handleDragUpdate,
      child: DragTarget<int>(
        onWillAcceptWithDetails: (details) => details.data != index,
        builder: (context, candidateData, rejectedData) {
          return DockItemWidget(item: _items[index]);
        },
      ),
    );
  }

  void _handleDragStart(int index) {
    setState(() {
      _draggedIndex = index;
      _targetIndex = index;
    });
  }

  void _handleDragEnd(DraggableDetails details) {
    setState(() {
      if (_targetIndex != null && !_isOutsideDock) {
        final item = _items.removeAt(_draggedIndex!);
        _items.insert(_targetIndex!, item);
      }
      _targetIndex = null;
      _draggedIndex = null;
      _isOutsideDock = false;
    });
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset localPosition = box.globalToLocal(details.globalPosition);
    final bool isOutside = !box.size.contains(localPosition);

    if (isOutside != _isOutsideDock) {
      setState(() {
        _isOutsideDock = isOutside;
      });
    }

    if (!isOutside) {
      _updateTargetIndex(localPosition);
    }
  }

// ... (previous code remains the same)

  bool _shouldShrink(int index) {
    return _draggedIndex == index && _isOutsideDock;
  }

  Offset _calculateOffset(int index) {
    if (_draggedIndex == null || _targetIndex == null || _isOutsideDock) {
      return Offset.zero;
    }

    if (_draggedIndex! < _targetIndex!) {
      if (index > _draggedIndex! && index <= _targetIndex!) {
        return const Offset(-1.0, 0.0);
      }
    } else if (_draggedIndex! > _targetIndex!) {
      if (index < _draggedIndex! && index >= _targetIndex!) {
        return const Offset(1.0, 0.0);
      }
    }
    return Offset.zero;
  }

  void _updateTargetIndex(Offset position) {
    if (_draggedIndex == null) return;

    final double dx = position.dx;
    for (int i = 0; i < _items.length; i++) {
      if (i == _draggedIndex) continue;

      final double itemStart =
          i * (DockConstants.baseWidth + DockConstants.itemSpacing);
      final double itemCenter =
          itemStart + (DockConstants.baseWidth + DockConstants.itemSpacing) / 2;

      if (dx < itemCenter) {
        if (_targetIndex != i) {
          setState(() {
            _targetIndex = i;
          });
        }
        return;
      }
    }

    if (_targetIndex != _items.length - 1) {
      setState(() {
        _targetIndex = _items.length - 1;
      });
    }
  }
}

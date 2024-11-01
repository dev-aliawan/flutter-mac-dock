import 'package:flutter/material.dart';

import '../constants/dock_constants.dart';
import '../controllers/dock_animation_controller.dart';
import '../controllers/dock_position_controller.dart';
import '../controllers/dock_state_controller.dart';
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

class _DockState extends State<Dock> with SingleTickerProviderStateMixin {
  late final DockAnimationController _animationController;
  late final DockStateController _stateController;

  @override
  void initState() {
    super.initState();
    _animationController = DockAnimationController(this);
    _stateController = DockStateController(List.from(widget.items));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DockContainer(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children:
            List.generate(_stateController.items.length, _buildAnimatedItem),
      ),
    );
  }

  Widget _buildAnimatedItem(int index) {
    return AnimatedSlide(
      duration: Duration(
          milliseconds: _stateController.targetIndex != null ? 200 : 0),
      offset: DockPositionController.calculateOffset(
        index,
        _stateController.draggedIndex,
        _stateController.targetIndex,
        _stateController.isOutsideDock,
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width:
            _stateController.shouldShrink(index) ? 0 : DockConstants.baseWidth,
        child: _buildDraggableItem(index),
      ),
    );
  }

  Widget _buildDraggableItem(int index) {
    return Draggable<int>(
      data: index,
      feedback: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: _animationController.scaleAnimation,
          child: DockItemWidget(item: _stateController.items[index]),
        ),
      ),
      childWhenDragging: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: DockConstants.itemSpacing / 2,
        ),
      ),
      onDragStarted: () {
        setState(() {
          _stateController.handleDragStart(index);
        });
        _animationController.forward();
      },
      onDragEnd: (details) {
        _animationController.reverse();
        setState(() {
          _stateController.handleDragEnd();
        });
      },
      onDragUpdate: _handleDragUpdate,
      child: _buildDragTarget(index),
    );
  }

  Widget _buildDragTarget(int index) {
    return DragTarget<int>(
      onWillAcceptWithDetails: (details) => details.data != index,
      onAcceptWithDetails: (details) {
        setState(() {
          _stateController.reorderItems(details.data, index);
        });
      },
      builder: (context, candidateData, rejectedData) {
        return AnimatedScale(
          duration: const Duration(milliseconds: 200),
          scale: _stateController.isDragging &&
                  _stateController.draggedIndex == index
              ? 0.0
              : 1.0,
          child: DockItemWidget(item: _stateController.items[index]),
        );
      },
    );
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset localPosition = box.globalToLocal(details.globalPosition);
    final bool isOutside = !box.size.contains(localPosition);

    if (isOutside != _stateController.isOutsideDock) {
      setState(() {
        _stateController.isOutsideDock = isOutside;
      });
    }

    if (!isOutside) {
      DockPositionController.updateTargetIndex(
        localPosition,
        _stateController.draggedIndex,
        _stateController.items.length,
        (index) {
          if (_stateController.targetIndex != index) {
            setState(() {
              _stateController.targetIndex = index;
            });
          }
        },
      );
    }
  }
}

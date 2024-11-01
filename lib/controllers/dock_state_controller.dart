import '../models/dock_item.dart';

class DockStateController {
  final List<DockItem> items;
  int? draggedIndex;
  int? targetIndex;
  bool isOutsideDock = false;
  bool isDragging = false;

  DockStateController(this.items);

  void handleDragStart(int index) {
    draggedIndex = index;
    targetIndex = index;
    isDragging = true;
  }

  void handleDragEnd() {
    if (targetIndex != null && !isOutsideDock) {
      final item = items.removeAt(draggedIndex!);
      items.insert(targetIndex!, item);
    }
    targetIndex = null;
    draggedIndex = null;
    isOutsideDock = false;
    isDragging = false;
  }

  bool shouldShrink(int index) {
    return draggedIndex == index && isOutsideDock && isDragging;
  }

  void reorderItems(int fromIndex, int toIndex) {
    if (fromIndex < toIndex) {
      toIndex -= 1;
    }
    final item = items.removeAt(fromIndex);
    items.insert(toIndex, item);
  }
}

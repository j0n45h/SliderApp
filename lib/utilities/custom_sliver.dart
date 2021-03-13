import 'package:flutter/material.dart';
import 'dart:math' as math;


class SliverFoldableBoxDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;

  final double maxHeight;
  final Widget child;
  SliverFoldableBoxDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  double get minExtent => minHeight;

  @override
  Widget build(BuildContext context,
      double shrinkOffset,
      bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(SliverFoldableBoxDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
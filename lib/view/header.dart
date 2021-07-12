

import 'package:flutter/material.dart';

class ViewHeaderDelegate extends SliverPersistentHeaderDelegate {
  ViewHeaderDelegate(
    this.builder,
    {
      this.minHeight:kToolbarHeight, 
      this.maxHeight:kToolbarHeight
    }
  );
  final double minHeight;
  final double maxHeight;
  final Function builder;

  @override
  bool shouldRebuild(ViewHeaderDelegate oldDelegate) => true;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => minHeight < maxHeight?maxHeight:minHeight;

  // @override
  // FloatingHeaderSnapConfiguration? get snapConfiguration => null;

  // @override
  // OverScrollHeaderStretchConfiguration get stretchConfiguration => OverScrollHeaderStretchConfiguration();

  double stretchDouble (double shrinkOffset) => (shrinkOffset/maxExtent).toDouble();
  double shrinkDouble (double stretch) => (1.0 - stretch).toDouble();

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent){
    // double padding = MediaQuery.of(context).padding.top;
    double stretch = stretchDouble(shrinkOffset);
    // double stretch = stretchDouble(shrinkOffset+padding,maxExtent+padding).clamp(0.0,1.0);
    double shrink = shrinkDouble(stretch);

    return new SizedBox.expand(
      child: this.builder(context,shrinkOffset,overlapsContent,shrink,stretch),
    );
  }
}

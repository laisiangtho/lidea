import 'package:flutter/material.dart';

class DemoSliverList extends StatelessWidget {
  const DemoSliverList({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Card(
            child: Text('SliverChildBuilderDelegate $index'),
          );
        },
        childCount: 1,
      ),
    );
    /*
    return SliverList(
      delegate: SliverChildListDelegate(
        <Widget>[],
      ),
    );
    */
  }
}

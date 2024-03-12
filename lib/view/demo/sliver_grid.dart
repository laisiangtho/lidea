import 'package:flutter/material.dart';

class DemoSliverGrid extends StatelessWidget {
  const DemoSliverGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 1.0,
        crossAxisSpacing: 1.0,
        crossAxisCount: 3,
        childAspectRatio: 1,
        // mainAxisExtent: 10,
      ),
      delegate: SliverChildListDelegate(
        [
          Container(color: Colors.red),
          Container(color: Colors.green),
          Container(color: Colors.blue),
          Container(color: Colors.red),
          Container(color: Colors.green),
          Container(color: Colors.blue),
        ],
      ),
    );

    // return SliverGrid.extent(
    //   maxCrossAxisExtent: 200,
    //   mainAxisSpacing: 10.0,
    //   crossAxisSpacing: 10.0,
    //   childAspectRatio: 4.0,
    //   children: [
    //     Container(color: Colors.pink),
    //     Container(color: Colors.indigo),
    //     Container(color: Colors.orange),
    //     Container(color: Colors.pink),
    //     Container(color: Colors.indigo),
    //     Container(color: Colors.orange),
    //   ],
    // );

    // return SliverGrid.count(
    //   crossAxisCount: 6,
    //   mainAxisSpacing: 10.0,
    //   crossAxisSpacing: 10.0,
    //   childAspectRatio: 4.0,
    //   children: [
    //     Container(color: Colors.red),
    //     Container(color: Colors.green),
    //     Container(color: Colors.blue),
    //     Container(color: Colors.red),
    //     Container(color: Colors.green),
    //     Container(color: Colors.blue),
    //   ],
    // );
  }
}

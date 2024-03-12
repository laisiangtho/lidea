// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

class DemoTextSize extends StatelessWidget {
  const DemoTextSize({
    Key? key,
    required this.headline,
    required this.subtitle,
    required this.text,
    required this.caption,
    required this.button,
    required this.overline,
  }) : super(key: key);
  final String headline;
  final String subtitle;
  final String text;
  final String caption;
  final String button;
  final String overline;

  @override
  Widget build(BuildContext context) {
    // final translate = AppLocalizations.of(context)!;
    return SliverPadding(
      padding: const EdgeInsets.only(top: 30, left: 10, bottom: 10),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          [
            const Padding(
              padding: EdgeInsets.only(top: 30, left: 10, bottom: 10),
              child: Text('Font size and color'),
            ),
            Text(
              '$headline 1',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            Text(
              '$headline 2',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            Text(
              '$headline 3',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            Text(
              '$headline 4',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              '$headline 5',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              '$headline 6',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              '$subtitle 1',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              '$subtitle 2',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Text(
              '$text 1',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              '$text 2',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              caption,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              button,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            Text(
              overline,
              style: Theme.of(context).textTheme.labelSmall,
            ),
            Text(
              'displayLarge',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            Text(
              'displayMedium',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            Text(
              'displaySmall',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            Text(
              'headlineLarge',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Text(
              'headlineMedium',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              'headlineSmall',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              'bodyLarge',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              'bodyMedium',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              'bodySmall',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              'titleLarge',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              'titleMedium',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              'titleSmall',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Text(
              'labelLarge',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            Text(
              'labelMedium',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Text(
              'labelSmall',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
    // return SliverToBoxAdapter(
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       const Padding(
    //         padding: EdgeInsets.only(top: 30, left: 10, bottom: 10),
    //         child: Text('Font size and color'),
    //       ),
    //       Card(
    //         child: Padding(
    //           padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
    //           child: Column(
    //             children: [],
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}

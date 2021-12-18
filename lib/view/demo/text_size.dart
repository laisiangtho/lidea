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
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 30, left: 10, bottom: 10),
            child: Text('Font size and color'),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Column(
                children: [
                  Text(
                    headline + ' 1',
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  Text(
                    headline + ' 2',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  Text(
                    headline + ' 3',
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  Text(
                    headline + ' 4',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  Text(
                    headline + ' 5',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  Text(
                    headline + ' 6',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Text(
                    subtitle + ' 1',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Text(
                    subtitle + ' 2',
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  Text(
                    text + ' 1',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Text(
                    text + ' 2',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  Text(
                    caption,
                    style: Theme.of(context).textTheme.caption,
                  ),
                  Text(
                    button,
                    style: Theme.of(context).textTheme.button,
                  ),
                  Text(
                    overline,
                    style: Theme.of(context).textTheme.overline,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

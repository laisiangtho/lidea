import 'package:flutter/material.dart';
import 'package:lidea/intl.dart';
// import 'package:fleth/settings.dart';

class DemoTranslate extends StatefulWidget {
  const DemoTranslate({
    super.key,
    // required this.locale,
    required this.itemCount,
    required this.itemCountNumber,
    required this.formatDate,
    required this.confirmToDelete,
    required this.formatCurrency,
  });
  // final Locale locale;
  final String Function(int count) itemCount;
  final String Function(int count, Object number) itemCountNumber;
  final String Function(DateTime date) formatDate;
  final String Function(String task) confirmToDelete;
  final String Function(double value) formatCurrency;

  @override
  State<DemoTranslate> createState() => _DemoTranslateState();
}

class _DemoTranslateState extends State<DemoTranslate> {
  // AppLocalizations get translate => AppLocalizations.of(context)!;
  // String get localeName => translate.localeName;
  Locale get locale => Localizations.localeOf(context);

  // Locale get locale => widget.locale;
  // String get localeName => locale.countryCode;
  String get localeName => locale.languageCode;
  String myanmar(int i) => NumberFormat.simpleCurrency(
        locale: localeName,
        name: '',
        decimalDigits: 0,
      ).format(i);

  @override
  void initState() {
    super.initState();
    // final abcdd = widget.itemCount(5);
    // final adf = locale.languageCode;
    // core = context.read<Core>();
    // settings = context.read<SettingsController>();
    // settings = SettingsController.instance;
    // settings = widget.settings!;
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        <Widget>[
          const Padding(padding: EdgeInsets.all(8.0), child: Text('Number with plural')),
          _number(),
          const Divider(),
          const Padding(padding: EdgeInsets.all(8.0), child: Text('Date')),
          _date(),
          const Divider(),
          const Padding(padding: EdgeInsets.all(8.0), child: Text('Message')),
          _message(),
          const Divider(),
          const Padding(padding: EdgeInsets.all(8.0), child: Text('Percent')),
          _percent(),
          const Divider(),
          const Padding(padding: EdgeInsets.all(8.0), child: Text('Currency')),
          _currency(),
          const Divider(),
          const Padding(padding: EdgeInsets.all(8.0), child: Text('Select')),
          _select(),
        ],
      ),
    );
  }

  Widget _number() {
    return Column(
      children: [
        Text(widget.itemCount(0)),
        Text(widget.itemCount(1)),
        Text(widget.itemCount(2)),
        Text(widget.itemCount(18)),
        Text(widget.itemCount(120)),
        Text(widget.itemCount(2503)),
        Text(widget.itemCount(25030000)),
        Text(widget.itemCountNumber(0, myanmar(0))),
        Text(widget.itemCountNumber(1, myanmar(1))),
        Text(widget.itemCountNumber(10, myanmar(10))),
        Text(widget.itemCountNumber(101, myanmar(101))),
        Text(widget.itemCountNumber(10888, myanmar(10888))),
      ],
    );
  }

  Widget _date() {
    return Column(
      children: [
        Text.rich(
          TextSpan(
            text: 'formatDate = ',
            children: [
              TextSpan(
                text: widget.formatDate(
                  DateFormat('d MMMM yyyy').parse('8 July 1981'),
                ),
                children: const [
                  TextSpan(text: '\nd MMMM yyyy'),
                ],
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _message() {
    return Column(
      children: [
        Text.rich(
          TextSpan(
            text: 'areYouSureTo = ',
            children: [
              TextSpan(
                text: widget.confirmToDelete('all'),
              ),
              TextSpan(
                text: widget.confirmToDelete('this'),
              ),
              TextSpan(
                text: widget.confirmToDelete('none'),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _percent() {
    return Column(
      children: [
        Text.rich(
          TextSpan(
            text: '*.percentPattern = ',
            children: [
              TextSpan(
                text: NumberFormat.percentPattern(locale.languageCode).format(60.23),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _currency() {
    return Column(
      children: [
        Text.rich(
          TextSpan(
            text: '*.compact = ',
            children: [
              TextSpan(
                text: NumberFormat.compact(locale: localeName).format(12345678),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        Text.rich(
          TextSpan(
            text: '*.simpleCurrency = ',
            children: [
              TextSpan(
                text: NumberFormat.simpleCurrency(locale: localeName).format(12345678),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        Text.rich(
          TextSpan(
            text: '*.currency = ',
            children: [
              TextSpan(
                text: NumberFormat.currency(locale: localeName).format(12345678),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        Text.rich(
          TextSpan(
            text: 'formatCurrency = ',
            children: [
              TextSpan(
                text: widget.formatCurrency(12345),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _select() {
    return const Column(
      children: [
        Text.rich(
          TextSpan(
            text: '?? = ',
            children: [
              TextSpan(
                text: '??',
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

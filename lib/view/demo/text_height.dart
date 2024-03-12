// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

class DemoTextHeight extends StatelessWidget {
  const DemoTextHeight({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        <Widget>[
          const Card(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'လူတိုင်းတွင် လွတ်လပ်စွာ တွေးခေါ် ကြံဆနိုင်ခွင့်၊ လွတ်လပ်စွာ ခံယူရပ်တည်နိုင်ခွင့် နှင့် လွတ်လပ်စွာ သက်ဝင် ကိုးကွယ်နိုင်ခွင့်ရှိသည်။ အဆိုပါ အခွင့်အရေးများ၌',
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Material Icons are available in five styles and a range of downloadable sizes and densities. The icons are based on the core Material Design principles and metrics.',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

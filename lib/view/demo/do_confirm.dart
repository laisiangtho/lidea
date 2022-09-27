import 'package:flutter/material.dart';
// import 'package:lidea/main.dart';
import 'package:lidea/view/main.dart';

class DemoDoConfirm extends StatelessWidget {
  const DemoDoConfirm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 5),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          [
            ListTile(
              leading: const Icon(Icons.add_alert),
              title: const Text('doConfirmWithDialog'),
              onTap: () {
                doConfirmWithDialog(
                  context: context,
                  message: 'TextButton custom overlayColor',
                ).then(
                  (bool? confirmation) {
                    // if (confirmation != null && confirmation) onClearAll();
                    debugPrint('response $confirmation');
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

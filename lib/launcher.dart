import 'package:url_launcher/url_launcher.dart';

class Launcher {
  static Future<void> launchInBrowser(Uri url) async {
    // mode: LaunchMode.inAppWebView,
    //   webViewConfiguration: const WebViewConfiguration(
    //       headers: <String, String>{'my_header_key': 'my_header_value'})
    // webViewConfiguration: const WebViewConfiguration(enableJavaScript: false),
    // webViewConfiguration: const WebViewConfiguration(enableDomStorage: false)
    if (!await launchUrl(
      url,
      // mode: LaunchMode.externalApplication,
      mode: LaunchMode.inAppWebView,
    )) {
      throw 'Could not launch $url';
    }
  }

  // static Uri url(String url) => Uri.parse(url);
  // Future<void> launchUniversalLinkIos(String url) async {
  //   final link = Uri.parse(url);
  //   if (await canLaunchUrl(link)) {
  //     final bool test = await launchUrl(link);
  //     if (!test) {
  //       await launchUrl(link);
  //     }
  //   }
  // }
}

import 'package:url_launcher/url_launcher.dart';

class Launcher {
  static Future<bool> canLaunch(Uri uri) async {
    return canLaunchUrl(uri);
  }

  static Future<bool> inNativeApp(Uri uri) async {
    return launchUrl(uri, mode: LaunchMode.externalNonBrowserApplication);
  }

  static Future<void> universalLink(String url) async {
    Uri uri = Uri.parse(url);
    final bool isNativeAppLaunched = await inNativeApp(uri);
    if (!isNativeAppLaunched) {
      await launchUrl(uri, mode: LaunchMode.inAppWebView);
    }
  }

  static Future<void> inBrowser(Uri url) async {
    // mode: LaunchMode.inAppWebView,
    //   webViewConfiguration: const WebViewConfiguration(
    //       headers: <String, String>{'my_header_key': 'my_header_value'})
    // webViewConfiguration: const WebViewConfiguration(enableJavaScript: false),
    // webViewConfiguration: const WebViewConfiguration(enableDomStorage: false)

    if (!await launchUrl(
      url,
      // mode: LaunchMode.externalApplication,
      mode: LaunchMode.platformDefault,
      // mode: LaunchMode.inAppWebView,
    )) {
      // throw 'Could not launch $url';
      throw ArgumentError('Could not launch $url');
    }
  }
}

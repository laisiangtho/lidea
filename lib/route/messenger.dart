part of 'main.dart';

class RouteMessengerWidget extends StatelessWidget {
  final String title;
  final String message;
  const RouteMessengerWidget({
    super.key,
    this.title = 'Route',
    this.message = 'Unknown',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text(message),
      ),
    );
  }
}

part of lidea.route;

class RouteMessengerWidget extends StatelessWidget {
  final String title;
  final String message;
  const RouteMessengerWidget({
    Key? key,
    this.title = 'Route',
    this.message = 'Unknown',
  }) : super(key: key);

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

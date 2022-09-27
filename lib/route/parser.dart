part of lidea.route;

class RouteParser extends RouteInformationParser<Uri> {
  @override
  Future<Uri> parseRouteInformation(RouteInformation routeInformation) async {
    // debugPrint('parse: ${routeInformation.location}');
    return Uri.parse(routeInformation.location!);
  }

  @override
  RouteInformation restoreRouteInformation(Uri configuration) {
    // debugPrint('restore: ${configuration.path}');
    String location = configuration.path;
    final param = configuration.queryParameters;
    // debugPrint('restore-isNotEmpty: ${param.isNotEmpty}');
    if (param.isNotEmpty) {
      String queryString = Uri(queryParameters: param).query;
      location = '$location?$queryString';
    }

    return RouteInformation(location: location);
  }
}

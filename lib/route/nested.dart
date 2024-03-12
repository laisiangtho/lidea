part of 'main.dart';

class RouteNestedWidget extends StatefulWidget {
  final RouteNestDelegate delegate;
  const RouteNestedWidget({
    super.key,
    required this.delegate,
  });

  @override
  State<RouteNestedWidget> createState() => _RouteNestedState();
}

class _RouteNestedState extends State<RouteNestedWidget> {
  // late final NavigatorRouteNestedDelegate delegate = NavigatorRouteNestedDelegate(Of.route);
  late final RouteNestDelegate delegate = widget.delegate;
  late ChildBackButtonDispatcher _dispatcher;

  @override
  void didUpdateWidget(covariant RouteNestedWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // delegate.state = state;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Defer back button dispatching to the child router
    _dispatcher = Router.of(context).backButtonDispatcher!.createChildBackButtonDispatcher();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const ValueKey('nested-scaffold'),
      body: Router(
        key: const ValueKey('nested-router'),
        // routeInformationParser: NavigatorRouteInformationParser(),
        routerDelegate: delegate,
        backButtonDispatcher: _dispatcher,
      ),
    );
  }
}

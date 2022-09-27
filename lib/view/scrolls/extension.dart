part of view.scrolls;

extension ScrollsExtension on ScrollController {
  static final _bottomController = <int, ScrollBottomListener>{};

  ScrollBottomListener get bottom {
    if (_bottomController.containsKey(hashCode)) {
      return _bottomController[hashCode]!;
    }

    return _bottomController[hashCode] = ScrollBottomListener(this);
  }
}

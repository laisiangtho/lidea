part of 'main.dart';

mixin _Header on _State {
  Widget _header(BuildContext context, ViewHeaderData data) {
    return ViewHeaderLayoutStack(
      data: data,
      left: [
        BackButtonWidget(
          navigator: state.navigator,
        ),
      ],
      // primary: ViewHeaderTitle(
      //   alignment: Alignment.lerp(
      //     const Alignment(0, 0),
      //     const Alignment(0, .5),
      //     data.snapShrink,
      //   ),
      //   label: App.preference.text.album(true),
      //   data: data,
      // ),
      primary: Positioned(
        // top: 0,
        // left: 0,
        height: data.minHeight,
        child: ViewHeaderTitle(
          label: App.preference.text.album('true'),
        ),
      ),
      right: [
        ViewButton(
          message: App.preference.text.filter('false'),
          onPressed: showFilter,
          child: const ViewMark(
            icon: Icons.tune_rounded,
          ),
        ),
      ],
      secondary: Align(
        alignment: const Alignment(0, .7),
        child: Opacity(
          opacity: data.snapShrink,
          child: SizedBox(
            height: data.snapHeight,
            width: double.infinity,
            child: _barOptional(data.snapShrink),
          ),
        ),
      ),
    );
  }

  Widget _barOptional(double stretch) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7 * stretch, horizontal: 0),
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
        children: [
          Text.rich(
            TextSpan(
              text: 'Albums ',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 18 * stretch),
              children: [
                const TextSpan(text: '('),
                TextSpan(
                  text: 3454.toString(),
                  // text: album.length.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const TextSpan(text: ')'),
                // if (filter.character.isNotEmpty) const TextSpan(text: ' start with '),
                // TextSpan(
                //   text: filter.character.take(6).join(', '),
                //   style: const TextStyle(
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                // if (filter.language.isNotEmpty) const TextSpan(text: ' in '),
                // TextSpan(
                //   text: filter.language
                //       .map((e) => cacheBucket.langById(e).name.substring(0, 2).toUpperCase())
                //       .join(', '),
                //   style: const TextStyle(
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                // if (filter.genre.isNotEmpty) const TextSpan(text: ' at '),
                // TextSpan(
                //   text:
                //       filter.genre.take(1).map((e) => cacheBucket.genreByIndex(e).name).join(', '),
                //   style: const TextStyle(
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                const TextSpan(text: '...'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

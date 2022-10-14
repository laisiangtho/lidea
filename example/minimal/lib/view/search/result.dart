part of 'main.dart';

mixin _Result on _State {
  Widget resultView() {
    return CustomScrollView(
      primary: true,
      slivers: [
        Selector<Core, ConclusionType>(
          selector: (_, e) => e.cacheConclusion,
          builder: (BuildContext context, ConclusionType o, Widget? child) {
            if (o.emptyQuery) {
              return _resultNoQuery();
            } else if (o.emptyResult) {
              return child!;
            } else {
              return _resultBlock();
            }
          },
          child: ViewFeedback.message(
            label: App.preference.text.searchNoMatch,
          ),
        ),
      ],
    );
  }

  Widget _resultNoQuery() {
    return ViewSection(
      headerTitle: const Text('Result no query'),
      headerTrailing: ViewButton(
        onPressed: () {},
        child: const Icon(Icons.more_horiz),
      ),
      footerTitle: Text('hasFocus ${_focusNode.hasFocus}'),
      child: ViewBlockCard(
        child: ListBody(
          children: [
            ViewButton(
              onPressed: () {},
              child: const Text('ViewButton'),
            ),
            ViewButton(
              child: Text(suggestQuery),
            ),
          ],
        ),
      ),
    );
  }

  Widget _resultBlock() {
    return ViewSection(
      headerTitle: const Text('Result ???'),
      headerTrailing: ViewButton(
        onPressed: () {},
        child: const Icon(Icons.more_horiz),
      ),
      footerTitle: Text('hasFocus ${_focusNode.hasFocus}'),
      child: ViewBlockCard(
        child: ListBody(
          children: [
            ViewButton(
              onPressed: () {},
              child: const Text('ViewButton'),
            ),
            ViewButton(
              child: Text(suggestQuery),
            ),
          ],
        ),
      ),
    );
  }
}

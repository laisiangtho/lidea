part of 'main.dart';

mixin _Suggest on _State {
  Widget suggestView() {
    return CustomScrollView(
      primary: true,
      slivers: [
        Selector<Core, SuggestionType>(
          selector: (_, e) => e.cacheSuggestion,
          builder: (BuildContext context, SuggestionType o, Widget? child) {
            if (o.emptyQuery) {
              return const _Recents();
            } else if (o.emptyResult) {
              return child!;
            } else {
              return _suggestBlock(o);
            }

            // return suggests(o);
          },
          child: ViewFeedback.message(
            label: App.preference.text.searchNoMatch,
          ),
        ),
      ],
    );
  }

  Widget _suggestBlock(SuggestionType o) {
    return ViewSection(
      headerTitle: const Text('Suggest ???'),
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
              child: Text(o.query),
            ),
          ],
        ),
      ),
    );
  }
}

part of 'main.dart';

mixin _Recent on _State {
  // recentBuilder
  Widget _recentBlock(Iterable<MapEntry<dynamic, RecentSearchType>> items) {
    return ViewListBuilder(
      primary: false,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return _recentContainer(index, items.elementAt(index));
      },
      itemSnap: (BuildContext context, int index) {
        return const ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 8),
          leading: Icon(Icons.north_east_rounded),
        );
      },
      itemSeparator: (BuildContext context, int index) {
        return const ViewSectionDivider(primary: false);
      },
      itemCount: items.length,
    );
  }

  Dismissible _recentContainer(int index, MapEntry<dynamic, RecentSearchType> item) {
    return Dismissible(
      key: Key(item.value.date.toString()),
      direction: DismissDirection.endToStart,
      background: _recentDismissibleBackground(),
      // secondaryBackground: _recentListDismissibleSecondaryBackground),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          return onDelete(item.value.word);
        }
        return null;
      },
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
        leading: const Icon(Icons.north_east_rounded),
        title: _recentItem(item.value.word),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Wrap(
              children: item.value.lang
                  .map(
                    (e) => Text(e),
                  )
                  .toList(),
            ),
            Chip(
              avatar: CircleAvatar(
                // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                backgroundColor: Colors.transparent,
                child: Icon(
                  Icons.saved_search_outlined,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              label: Text(
                item.value.hit.toString(),
              ),
            ),
          ],
        ),
        // trailing: Chip(
        //   avatar: CircleAvatar(
        //     // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        //     backgroundColor: Colors.transparent,
        //     child: Icon(
        //       Icons.saved_search_outlined,
        //       color: Theme.of(context).primaryColor,
        //     ),
        //   ),
        //   label: Text(
        //     item.value.hit.toString(),
        //   ),
        // ),
        onTap: () => onSuggest(item.value.word),
      ),
    );
  }

  Widget _recentItem(String word) {
    int hightlight = suggestQuery.length < word.length ? suggestQuery.length : word.length;
    return Text.rich(
      TextSpan(
        text: word.substring(0, hightlight),
        semanticsLabel: word,
        style: TextStyle(
          fontSize: 20,
          color: Theme.of(context).textTheme.bodySmall!.color,
          // color: Theme.of(context).primaryTextTheme.labelLarge!.color,
          fontWeight: FontWeight.w300,
        ),
        children: <TextSpan>[
          TextSpan(
            text: word.substring(hightlight),
            style: TextStyle(
              color: Theme.of(context).primaryTextTheme.labelLarge!.color,
            ),
          )
        ],
      ),
    );
  }

  Widget _recentDismissibleBackground() {
    return Container(
      color: Theme.of(context).disabledColor,
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Text(
          App.preference.text.delete,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}

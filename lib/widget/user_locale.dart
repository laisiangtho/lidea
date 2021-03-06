part of lidea.widget;

class WidgetUserLocale extends StatelessWidget {
  final ClusterController preference;
  const WidgetUserLocale({Key? key, required this.preference}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return WidgetBlockSection(
      duration: const Duration(milliseconds: 250),
      placeHolder: const SliverToBoxAdapter(),
      headerLeading: const Icon(Icons.translate_rounded),
      headerTitle: WidgetBlockTile(
        title: WidgetLabel(
          alignment: Alignment.centerLeft,
          label: preference.text.locale,
        ),
      ),
      child: Card(
        // child: WidgetUserLocale(
        //   supportedLocales: preference.supportedLocales,
        //   updateLocale: preference.updateLocale,
        // ),
        child: WidgetListBuilder(
          primary: false,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: preference.listOfLocale.length,
          itemBuilder: (_, index) {
            final locale = preference.listOfLocale.elementAt(index);

            Locale localeCurrent = Localizations.localeOf(context);
            // final String localeName = Intl.canonicalizedLocale(lang.languageCode);

            // preference.localeName(locale.languageCode);
            // final String localeName = Locale(locale.languageCode).nativeName;
            final String localeName = preference.nameOfLocale(locale.languageCode);
            final bool active = localeCurrent.languageCode == locale.languageCode;

            return WidgetButton(
              child: WidgetLabel(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                alignment: Alignment.centerLeft,
                icon: Icons.check_rounded,
                iconColor: active ? null : Theme.of(context).disabledColor,
                label: localeName,
                labelPadding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                labelStyle: Theme.of(context).textTheme.bodyLarge,
                softWrap: true,
                maxLines: 3,
              ),
              onPressed: () {
                preference.updateLocale(locale);
              },
            );
          },
          itemSeparator: (_, index) {
            return const WidgetListDivider();
          },
        ),
      ),
    );
  }
}

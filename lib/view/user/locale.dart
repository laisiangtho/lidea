part of 'main.dart';

class UserLocaleWidget extends StatelessWidget {
  final PreferenceNest preference;
  final bool? primary;

  const UserLocaleWidget({
    super.key,
    required this.preference,
    this.primary,
  });
  @override
  Widget build(BuildContext context) {
    return ViewSection(
      primary: primary,
      duration: const Duration(milliseconds: 250),
      onAwait: const SliverToBoxAdapter(),
      headerLeading: const Icon(Icons.translate_rounded),
      headerTitle: ViewSectionTitle(
        title: ViewLabel(
          alignment: Alignment.centerLeft,
          label: preference.text.locale,
        ),
      ),
      child: ViewBlockCard(
        // child: WidgetUserLocale(
        //   supportedLocales: preference.supportedLocales,
        //   updateLocale: preference.updateLocale,
        // ),
        child: ViewListBuilder(
          primary: false,
          // padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: preference.listOfLocale.length,
          itemBuilder: (_, index) {
            final locale = preference.listOfLocale.elementAt(index);

            Locale localeCurrent = Localizations.localeOf(context);
            // final String localeName = Intl.canonicalizedLocale(lang.languageCode);

            // preference.localeName(locale.languageCode);
            // final String localeName = Locale(locale.languageCode).nativeName;
            final String localeName = preference.nameOfLocale(locale.languageCode);
            final bool active = localeCurrent.languageCode == locale.languageCode;

            return ListTile(
              selected: active,
              contentPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              leading: const Icon(
                Icons.check_rounded,
              ),
              title: Text(
                localeName,
                style: TextStyle(
                  color: active ? Theme.of(context).highlightColor : null,
                ),
              ),
              onTap: () {
                if (!active) {
                  preference.updateLocale(locale);
                }
              },
            );
          },
          itemSeparator: (_, index) {
            return const ViewSectionDivider(
              primary: false,
            );
          },
        ),
      ),
    );
  }
}

part of 'main.dart';

/// Theme mode
class UserThemeWidget extends StatelessWidget {
  final PreferenceNest preference;
  final bool? primary;
  const UserThemeWidget({
    super.key,
    required this.preference,
    this.primary,
  });

  @override
  Widget build(BuildContext context) {
    return ViewSection(
      primary: primary,
      duration: const Duration(milliseconds: 150),
      onAwait: const SliverToBoxAdapter(),
      headerLeading: const Icon(Icons.light_mode_rounded),
      headerTitle: ViewSectionTitle(
        title: ViewLabel(
          alignment: Alignment.centerLeft,
          label: preference.text.themeMode,
          labelStyle: TextStyle(
            color: Theme.of(context).hintColor,
          ),
        ),
      ),
      child: ViewBlockCard(
        // color: Colors.red,
        // color: Theme.of(context).cardColor,
        child: ViewListBuilder(
          primary: false,
          // padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: ThemeMode.values.length,
          itemBuilder: (BuildContext _, int index) {
            ThemeMode mode = ThemeMode.values[index];
            bool active = preference.themeMode == mode;
            // return ViewButton(
            //   child: ViewLabel(
            //     padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
            //     alignment: Alignment.centerLeft,
            //     icon: Icons.check_rounded,
            //     // iconColor: active ? null : Theme.of(context).focusColor,
            //     iconColor: active ? null : Theme.of(context).disabledColor,
            //     label: preference.nameOfTheme(index),
            //     labelPadding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            //     labelStyle: Theme.of(context).textTheme.bodyLarge,
            //     softWrap: true,
            //     maxLines: 3,
            //   ),
            //   onPressed: () {
            //     if (!active) {
            //       preference.updateThemeMode(mode);
            //     }
            //   },
            // );
            return ListTile(
              selected: active,
              contentPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              leading: const Icon(
                Icons.check_rounded,
              ),
              title: Text(
                preference.nameOfTheme(index),
                style: TextStyle(
                  color: active ? Theme.of(context).highlightColor : null,
                ),
              ),
              onTap: () {
                if (!active) {
                  preference.updateThemeMode(mode);
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

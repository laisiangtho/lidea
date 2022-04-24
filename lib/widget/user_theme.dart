part of 'main.dart';

class WidgetUserTheme extends StatelessWidget {
  final ClusterController preference;
  const WidgetUserTheme({Key? key, required this.preference}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WidgetBlockSection(
      duration: const Duration(milliseconds: 150),
      placeHolder: const SliverToBoxAdapter(),
      headerLeading: const Icon(Icons.light_mode_rounded),
      headerTitle: WidgetBlockTile(
        title: WidgetLabel(
          alignment: Alignment.centerLeft,
          label: preference.text.themeMode,
        ),
      ),
      child: Card(
        child: WidgetListBuilder(
          primary: false,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: ThemeMode.values.length,
          itemBuilder: (_, index) {
            ThemeMode mode = ThemeMode.values[index];
            bool active = preference.themeMode == mode;
            return WidgetButton(
              child: WidgetLabel(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                alignment: Alignment.centerLeft,
                icon: Icons.check_rounded,
                iconColor: active ? null : Theme.of(context).focusColor,
                label: preference.nameOfTheme(index),
                labelPadding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                labelStyle: Theme.of(context).textTheme.bodyLarge,
                softWrap: true,
                maxLines: 3,
              ),
              onPressed: () {
                if (!active) {
                  preference.updateThemeMode(mode);
                }
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

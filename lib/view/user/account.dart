part of view.user;

// UserAccountWidget
class UserAccountWidget extends StatefulWidget {
  final PreferenceNest preference;
  final AuthenticateUnit authenticate;
  final List<Widget> children;
  final bool? primary;
  const UserAccountWidget({
    Key? key,
    required this.preference,
    required this.authenticate,
    this.children = const [],
    this.primary,
  }) : super(key: key);

  @override
  State<UserAccountWidget> createState() => _ViewUserAccountState();
}

class _ViewUserAccountState extends State<UserAccountWidget> {
  List<Widget> get more => widget.children;

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   children.clear();
  //   debugPrint('didChangeDependencies children: ${widget.children.length}');
  //   children.addAll(widget.children);
  //   children.add(doDeleteWidget());
  // }

  @override
  Widget build(BuildContext context) {
    // final List<Widget> children = [...widget.children, doDeleteWidget()];
    return ViewSection(
      primary: widget.primary,
      duration: const Duration(milliseconds: 150),
      onAwait: const SliverToBoxAdapter(),
      headerLeading: const Icon(Icons.face_outlined),
      show: widget.authenticate.hasUser,
      headerTitle: ViewSectionTitle(
        title: ViewLabel(
          alignment: Alignment.centerLeft,
          label: widget.preference.text.account,
        ),
      ),
      child: Card(
        child: ViewListBuilder(
          primary: false,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemBuilder: (_, index) {
            if (index < more.length) {
              return more.elementAt(index);
            }
            return doDeleteWidget();
          },
          itemSeparator: (_, index) {
            return const ViewSectionDivider(
              primary: false,
            );
          },
          itemCount: (more.length + 1).toInt(),
        ),
      ),
      // child: Card(
      //   child: WidgetListBuilder(
      //     primary: false,
      //     padding: const EdgeInsets.symmetric(horizontal: 20),
      //     itemBuilder: (_c, index) {
      //       return children.elementAt(index);
      //     },
      //     itemSeparator: (_c, index) {
      //       return const WidgetListDivider();
      //     },
      //     itemCount: children.length,
      //   ),
      // ),
    );
  }

  Widget doDeleteWidget() {
    return ViewButton(
      onPressed: doDeleteAccountWithConfirm,
      child: ViewLabel(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
        alignment: Alignment.centerLeft,
        icon: Icons.person_remove_outlined,
        iconColor: Theme.of(context).errorColor,
        label: widget.preference.text.deleteAccount,
        labelPadding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
        labelStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Theme.of(context).errorColor,
            ),
        softWrap: true,
        maxLines: 3,
      ),
    );
  }

  void doDeleteAccountWithConfirm() {
    doConfirmWithDialog(
      context: context,
      // message: 'Do you want to delete "$word"?',
      // title: 'Delete Account',
      // message: preference.text.confirmToDelete(preference.text.userAccount),
      title: widget.preference.text.deleteAccount,
      message: widget.preference.text.confirmToDelete('yourAccount'),
    ).then((bool? confirmation) async {
      if (confirmation != null && confirmation == true) {
        await widget.authenticate.deleteAccount().catchError((e) {
          doNotify(widget.authenticate.message);
        });
      }
    });
  }

  void doNotify(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
            content: Text(message),
          ),
        )
        .closed
        .then((value) {
      widget.authenticate.message = '';
    });
  }
}

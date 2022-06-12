part of lidea.widget;

class WidgetUserAccount extends StatefulWidget {
  final ClusterController preference;
  final UnitAuthentication authenticate;
  final List<Widget> children;
  const WidgetUserAccount({
    Key? key,
    required this.preference,
    required this.authenticate,
    this.children = const [],
  }) : super(key: key);

  @override
  State<WidgetUserAccount> createState() => _WidgetUserAccountState();
}

class _WidgetUserAccountState extends State<WidgetUserAccount> {
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
    return WidgetBlockSection(
      duration: const Duration(milliseconds: 150),
      placeHolder: const SliverToBoxAdapter(),
      headerLeading: const Icon(Icons.face_outlined),
      show: widget.authenticate.hasUser,
      headerTitle: WidgetBlockTile(
        title: WidgetLabel(
          alignment: Alignment.centerLeft,
          label: widget.preference.text.account,
        ),
      ),
      child: Card(
        child: WidgetListBuilder(
          primary: false,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemBuilder: (_c, index) {
            if (index < more.length) {
              return more.elementAt(index);
            }
            return doDeleteWidget();
          },
          itemSeparator: (_c, index) {
            return const WidgetListDivider();
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
    return WidgetButton(
      onPressed: doDeleteAccountWithConfirm,
      child: WidgetLabel(
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
      // if (confirmation != null && confirmation == true) {
      //   await widget.authenticate.deleteAccount().catchError((e) {
      //     doNotify(widget.authenticate.message);
      //   });
      // }
      debugPrint('?????????');
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

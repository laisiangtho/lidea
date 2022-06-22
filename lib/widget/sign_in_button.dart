part of lidea.widget;

class SignInButton extends StatelessWidget {
  final IconData? icon;
  final String? label;
  final void Function()? onPressed;
  final void Function()? whenComplete;
  const SignInButton({
    Key? key,
    this.icon,
    this.label,
    this.onPressed,
    this.whenComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WidgetButton(
      // margin: const EdgeInsets.all(7),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
      // decoration: BoxDecoration(
      //   color: Theme.of(context).primaryColor,
      //   borderRadius: BorderRadius.circular(100),
      //   border: Border.all(
      //     color: Theme.of(context).shadowColor,
      //     width: 1,
      //   ),
      // ),
      elevation: 1.5,
      borderRadius: const BorderRadius.all(Radius.circular(100)),
      color: Theme.of(context).primaryColor,
      child: WidgetLabel(
        icon: icon,
        iconColor: Theme.of(context).hintColor,
        iconSize: 20,
        label: label,
        labelStyle: Theme.of(context).textTheme.labelLarge,
      ),
      onPressed: onPressed,
    );
  }
}

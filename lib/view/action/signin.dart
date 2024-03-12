// ignore_for_file: use_super_parameters

part of 'main.dart';

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
    return ViewButton.filled(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 14),
      borderRadius: const BorderRadius.all(Radius.circular(100)),
      // color: Theme.of(context).primaryColor,
      onPressed: onPressed,
      showShadow: true,
      style: Theme.of(context).textTheme.labelLarge,
      child: ViewMark(
        icon: icon,
        // iconColor: Theme.of(context).hintColor,
        iconSize: 20,
        label: label,
        // labelStyle: Theme.of(context).textTheme.labelLarge,
        labelPadding: const EdgeInsets.only(left: 10),
      ),
      // child: ViewLabel(
      //   icon: icon,
      //   iconColor: Theme.of(context).hintColor,
      //   iconSize: 20,
      //   label: label,
      //   labelStyle: Theme.of(context).textTheme.labelLarge,
      // ),
    );
    // return ViewButton(
    //   // margin: const EdgeInsets.all(7),
    //   // margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    //   // padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
    //   // decoration: BoxDecoration(
    //   //   color: Theme.of(context).primaryColor,
    //   //   borderRadius: BorderRadius.circular(100),
    //   //   border: Border.all(
    //   //     color: Theme.of(context).shadowColor,
    //   //     width: 1,
    //   //   ),
    //   // ),
    //   // elevation: 1.5,
    //   borderRadius: const BorderRadius.all(Radius.circular(100)),
    //   // color: Theme.of(context).primaryColor,
    //   onPressed: onPressed,
    //   child: ViewLabel(
    //     // padding: const EdgeInsets.symmetric(
    //     //   horizontal: 20,
    //     // ),
    //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    //     labelPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
    //     decoration: BoxDecoration(
    //       color: Theme.of(context).primaryColor,
    //       borderRadius: BorderRadius.circular(100),
    //       border: Border.all(
    //         color: Theme.of(context).shadowColor,
    //         width: 1,
    //       ),
    //     ),
    //     icon: Icons.ac_unit,
    //     iconColor: Theme.of(context).hintColor,
    //     iconSize: 20,
    //     label: label,
    //     labelStyle: Theme.of(context).textTheme.labelLarge,
    //   ),
    // );
  }
}

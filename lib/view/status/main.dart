library view.action;

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ViewFeedback extends StatelessWidget {
  final bool? primary;
  final String? label;
  final IconData? icon;
  final double? size;
  final Widget? child;
  const ViewFeedback({
    super.key,
    this.primary,
    this.child,
  })  : icon = null,
        size = null,
        label = null;

  const ViewFeedback.empty({
    super.key,
    this.primary,
    this.label,
    this.icon = Icons.contact_support_outlined,
    this.size = 40,
    this.child,
  });

  const ViewFeedback.await({
    super.key,
    this.primary,
    this.label,
    this.icon = Icons.hourglass_top_outlined,
    this.size = 40,
    this.child,
  });

  const ViewFeedback.message({
    super.key,
    this.primary,
    this.label,
  })  : icon = null,
        size = null,
        child = null;

  @override
  Widget build(BuildContext context) {
    final wgt = _wgt(context);

    if (primary == null) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: wgt,
      );
    }
    return wgt;
  }

  Widget _wgt(BuildContext context) {
    return child ??
        Center(
          child: (icon != null)
              ? Icon(
                  icon,
                  semanticLabel: label,
                  size: size,
                  color: Theme.of(context).focusColor,
                )
              : Text(
                  label ?? ':(',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
        );
  }
}

import 'package:flutter/material.dart';

part 'config.dart';
part 'option.dart';

class IdeaModel extends StatefulWidget {
  IdeaModel({
    Key? key,
    required this.initialModel,
    required this.child,
  }) : super(key: key);
  // IdeaModel({
  //   Key? key,
  //   this.initialModel = const IdeaTheme(),
  //   required this.child,
  // }) : assert(initialModel != null), super(key: key);

  final IdeaTheme initialModel;
  final Widget child;

  @override
  _ModelBindingState createState() => _ModelBindingState();
}

class _ModelBindingState extends State<IdeaModel> {
  late IdeaTheme currentModel;

  @override
  void initState() {
    super.initState();
    currentModel = widget.initialModel;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void updateModel(IdeaTheme newModel) {
    if (newModel != currentModel) {
      setState(() {
        currentModel = newModel;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _ModelBindingScope(
      modelBindingState: this,
      child: widget.child
    );
  }
}

class _ModelBindingScope extends InheritedWidget {
  _ModelBindingScope({
    Key? key,
    required this.modelBindingState,
    required Widget child,
  }) : super(key: key, child: child);

  final _ModelBindingState modelBindingState;

  @override
  // bool updateShouldNotify(_ModelBindingScope old) =>  old.modelBindingState != modelBindingState;
  bool updateShouldNotify(_ModelBindingScope oldWidget) => true;
}

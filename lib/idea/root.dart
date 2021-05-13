import 'package:flutter/material.dart';

part 'config.dart';
part 'option.dart';

class IdeaModel extends StatefulWidget {
  IdeaModel({
    Key key,
    this.initialModel = const IdeaTheme(),
    this.child,
  }) : assert(initialModel != null), super(key: key);

  final IdeaTheme initialModel;
  final Widget child;

  @override
  _ModelBindingState createState() => _ModelBindingState();
}

class _ModelBindingState extends State<IdeaModel> {
  IdeaTheme currentModel;

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
    Key key,
    @required this.modelBindingState,
    Widget child,
  }) : assert(modelBindingState != null), super(key: key, child: child);

  final _ModelBindingState modelBindingState;

  @override
  // bool updateShouldNotify(_ModelBindingScope old) =>  old.modelBindingState != modelBindingState;
  bool updateShouldNotify(_ModelBindingScope oldWidget) => true;
}

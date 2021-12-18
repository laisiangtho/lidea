import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class DemoButtonStyle extends StatelessWidget {
  const DemoButtonStyle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text('CupertinoButton'),
              const CupertinoButton(
                onPressed: null,
                child: Text('No'),
              ),
              const SizedBox(height: 5),
              CupertinoButton(
                onPressed: () => false,
                child: const Text('Yes'),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text('ElevatedButton'),
              const ElevatedButton(
                onPressed: null,
                child: Text('No'),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => false,
                child: const Text('Yes'),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text('TextButton'),
              const TextButton(
                onPressed: null,
                child: Text('No'),
              ),
              const SizedBox(height: 5),
              TextButton(
                onPressed: () => false,
                child: const Text('Yes'),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text('IconButton'),
              const IconButton(
                icon: Icon(Icons.accessibility),
                onPressed: null,
              ),
              const SizedBox(height: 5),
              IconButton(
                onPressed: () => false,
                icon: const Icon(Icons.accessibility),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text('TextButton.icon'),
              TextButton.icon(
                icon: const Icon(Icons.accessibility),
                label: const Text('No'),
                onPressed: null,
              ),
              const SizedBox(height: 5),
              TextButton.icon(
                icon: const Icon(Icons.accessibility),
                label: const Text('Yes'),
                onPressed: () => true,
              ),
            ],
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class Responsiveness extends StatelessWidget {
  final Widget child;

  const Responsiveness({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: child,
      ),
    );
  }
}

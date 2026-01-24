import 'package:flutter/material.dart';

/// A widget that unfocuses the keyboard when tapping anywhere on the screen
class UnfocusKeyboard extends StatelessWidget {
  final Widget child;

  const UnfocusKeyboard({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      behavior: HitTestBehavior.opaque,
      child: child,
    );
  }
}

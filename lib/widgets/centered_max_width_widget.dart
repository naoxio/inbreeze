import 'package:flutter/material.dart';

class CenteredMaxWidthWidget extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const CenteredMaxWidthWidget({
    super.key,
    required this.child,
    this.maxWidth = 800,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}

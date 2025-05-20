import 'package:flutter/material.dart';
class IntroBottomContainer extends StatelessWidget {
  const IntroBottomContainer({
    super.key, required this.child,
  });
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          topLeft: Radius.circular(24),
        ),
        color: Colors.white,
      ),
      child: child,
    );
  }
}

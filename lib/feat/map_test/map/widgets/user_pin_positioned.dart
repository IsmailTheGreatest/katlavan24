import 'package:flutter/material.dart';
class UserPinPositioned extends StatelessWidget {
  const UserPinPositioned({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        top: 0,
        child: UserPin());
  }
}

class UserPin extends StatelessWidget {
  const UserPin({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      child: Center(
          child: Image.asset(
            'assets/map/Pin.png',
            width: 48,
            height: 48,
          )),
    );
  }
}

import 'package:flutter/material.dart';

extension WidgetExtension on Widget {
  Widget checkCond(bool test) => test ? this : SizedBox();

  Widget checkCondAnimatedOpacity(bool test) => AnimatedOpacity(
        opacity: test ? 1 : 0,
        duration: Duration(milliseconds: 500),
        child: this,
      );

  Widget checkCondAnimatedSize(bool test,
      [Alignment alignment = Alignment.center, Curve curve = Curves.easeInOutCubic]) =>
      AnimatedSize(
          duration: Duration(milliseconds: 500),
          alignment: alignment,
          curve: curve,
          child: ConstrainedBox(
            constraints: test ? BoxConstraints() : BoxConstraints(maxHeight: 0),
            child: this,
          ));
  Widget checkCondAnimatedSizeHorizontal(bool test,
      [Alignment alignment = Alignment.center, Curve curve = Curves.easeInOutCubic]) =>
      AnimatedSize(
          duration: Duration(milliseconds: 500),
          alignment: alignment,
          curve: curve,
          child: ConstrainedBox(
            constraints: test ? BoxConstraints() : BoxConstraints(maxWidth: 0),
            child: this,
          ));
  Widget checkCondAnimatedPositioned(bool test,double height,{Curve curve=Curves.linear}) =>
      AnimatedPositioned(
        duration: Duration(milliseconds: 500),
        curve: curve,
        top: test?0:-height,
        child: this,
      );
  Widget checkCondAnimatedPositionedLeft(bool test,double height,{Curve curve=Curves.linear}) =>
      AnimatedPositioned(
        duration: Duration(milliseconds: 500),
        curve: curve,
        right: test?0:height,
        bottom: 0,
        left: test?0:-height,
        child: this,
      );
  Widget checkCondAnimatedPositionedBottom(bool test,double height,{Curve curve=Curves.linear}) =>
      AnimatedPositioned(
        duration: Duration(milliseconds: 500),
        curve: curve,
        right: 0,
        bottom: test?0:-height,
        left: 0,
        child: this,
      );
  Widget checkCondAnimatedSlide(bool test,{Curve curve=Curves.easeInOut, Offset customOffset=const Offset(0, -1.5)}) =>
      AnimatedSlide(
        duration: Duration(milliseconds: 600),
        curve: curve,
        offset: test?Offset.zero:customOffset,
        child: this,
      );
  Widget checkCondAnimatedSlideThree(int main,int comparator,{Curve curve=Curves.easeInOut, Offset customOffset=const Offset(0, -1.5), Offset customExitOffset=const Offset(0,1.5)}) =>
      AnimatedSlide(
        duration: Duration(milliseconds: 600),
        curve: curve,
        offset: main==comparator?Offset.zero:main>comparator?customExitOffset:customOffset,
        child: this,
      );
}

import 'package:flutter/material.dart';
class KatlavanBackButton extends StatelessWidget {
  const KatlavanBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        padding: EdgeInsets.all(4),
        visualDensity: VisualDensity.compact,
        onPressed: (){Navigator.pop(context);}, icon: Image.asset('assets/map/back.png',height: 24,width: 24,));
  }
}

import 'package:flutter/material.dart';
class TuneButton extends StatelessWidget {
  const TuneButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: 53,
        right: 20,
        child: GestureDetector(
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xff040415).withValues(alpha: 0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Icon(Icons.tune),
          ),
        ));
  }
}

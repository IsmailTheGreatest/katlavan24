import 'package:flutter/material.dart';

class SmallContainer extends StatelessWidget {
  const SmallContainer({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap, required this.isKm,
  });

  final String text;
  final bool isKm;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xfff4f4f5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Transform.scale(scaleY: 0.9, child: Icon(icon, color: Colors.black)),
          SizedBox(
            width: 32.8,
            child: Center(
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                ),
              ),
            ),
          ),
           Text(
              isKm ? 'км' : 'мин',
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black,
              ),
            )
           ,
        ],
      ),
    );
  }
}

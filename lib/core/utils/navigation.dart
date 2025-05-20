import 'package:flutter/material.dart';

void navigate(BuildContext context,Widget page)=>Navigator.push(context, MaterialPageRoute(builder: (context)=>page));
void navigateReplaceAll(BuildContext context,Widget page)=>Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>page),(p)=>false);

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

showBanner(BuildContext context, String message) {
  return ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(content: Text(message), actions: [TextButton(onPressed: (){}, child: SizedBox())],));
}

showSnackbar(BuildContext context, String message) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
showFlushbar(BuildContext context, String message)async  {
  return  await Flushbar(
    message: message,
    backgroundColor: Colors.black,
    animationDuration: Duration(milliseconds: 400),
    duration: Duration(milliseconds: 2000),
  ).show(context);
}

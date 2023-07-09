import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';

raiseFlashbard(BuildContext context, {String? msg}) {
  context.showErrorBar(
    content: msg == null ? Text('error has occured') : Text(msg),
    primaryActionBuilder: (context, controller) {
      return IconButton(
        onPressed: controller.dismiss,
        icon: Icon(Icons.undo),
      );
    },
  );
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';

class CancelShiprocketOrderConfirmationDialog extends StatelessWidget {
  const CancelShiprocketOrderConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('CANCEL_SHIPROCKET_ORDER'.translate(context: context)),
      content: Text('ARE_YOU_SURE_YOU_WANT_TO_CANCEL_THIS_ORDER'
          .translate(context: context)),
      actions: [
        CupertinoButton(
            child: Text('LOGOUTNO'.translate(context: context)),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        CupertinoButton(
            child: Text('LOGOUTYES'.translate(context: context)),
            onPressed: () {
              Navigator.of(context).pop(true);
            }),
      ],
    );
  }
}

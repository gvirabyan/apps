// get command sized Box
import 'package:flutter/material.dart';
import '../../../Helper/Color.dart';
import '../../../Helper/Constant.dart';

getCommanSizedBox() {
  return const SizedBox(
    height: 10,
  );
}

getCommanSizedBoxWidth() {
  return const SizedBox(
    width: 10,
  );
}

// Comman Primary Text Field :-

getPrimaryCommanText(String title, bool isMultipleLine) {
  return Text(
    title,
    style: const TextStyle(
      fontSize: textFontSize16,
      color: black,
    ),
    overflow: isMultipleLine ? TextOverflow.ellipsis : null,
    softWrap: true,
    maxLines: isMultipleLine ? 2 : 1,
  );
}

// Comman Secondary Text Field :-

getSecondaryCommanText(String title, {Color color = Colors.grey}) {
  return Text(
    title,
    style: TextStyle(
      color: color,
    ),
    softWrap: false,
    overflow: TextOverflow.ellipsis,
    maxLines: 1,
  );
}

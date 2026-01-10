import 'package:flutter/material.dart';

class Insets {
  // all
  static const EdgeInsets all4 = EdgeInsets.all(4);
  static const EdgeInsets all8 = EdgeInsets.all(8);
  static const EdgeInsets all16 = EdgeInsets.all(16);
  static const EdgeInsets all24 = EdgeInsets.all(24);

  // horizontal
  static const EdgeInsets h4 = EdgeInsets.symmetric(horizontal: 4);
  static const EdgeInsets h8 = EdgeInsets.symmetric(horizontal: 8);
  static const EdgeInsets h16 = EdgeInsets.symmetric(horizontal: 16);
  static const EdgeInsets h24 = EdgeInsets.symmetric(horizontal: 24);

  // vertical
  static const EdgeInsets v4 = EdgeInsets.symmetric(vertical: 4);
  static const EdgeInsets v8 = EdgeInsets.symmetric(vertical: 8);
  static const EdgeInsets v16 = EdgeInsets.symmetric(vertical: 16);
  static const EdgeInsets v24 = EdgeInsets.symmetric(vertical: 24);

  // custom
  static const EdgeInsets h16v12 = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 12,
  );
}

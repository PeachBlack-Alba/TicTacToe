import 'package:flutter/material.dart';

class GameButton {
  final id;
  String text;
  Color background;
  bool enabled;

  GameButton({this.id, this.text = '', this.background = Colors.greenAccent, this.enabled = true});
}

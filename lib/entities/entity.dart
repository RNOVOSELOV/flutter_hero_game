import 'package:flutter/material.dart';

abstract class Entity {
  double x;
  double y;
  String spriteName;
  bool isVisible = true;
  List sprites = [];

  Entity({required this.spriteName, required this.x, required this.y}) {
    for (var i = 0; i < 4; i++) {
      sprites.add(Image.asset("assets/images/$spriteName$i.png"));
    }
  }

  void update();

  void move();

  Widget build();
}

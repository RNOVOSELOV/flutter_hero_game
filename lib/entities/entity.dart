import 'package:flutter/material.dart';

abstract class Entity {
  double x;
  double y;
  final String spriteName;
  bool visible = true;
  List sprites = [];
  int currentSprite = 0;
  int currentTick = 0;

  get isVisible => visible;

  Entity({required this.spriteName, this.x = 0, this.y = 0}) {
    for (var i = 0; i < 4; i++) {
      sprites.add(Image.asset("assets/images/$spriteName$i.png"));
    }
  }

  void _animate () {
    currentTick ++;
    if (currentTick > 15) {
      currentSprite ++;
      currentTick = 0;
    }
    if (currentSprite > 3) {
      currentSprite = 0;
    }
  }

  void update() {
    _animate();
    move();
  }

  void move();

  Widget build();
}

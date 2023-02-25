import 'package:flutter/material.dart';

abstract class AppScene {
  Stack buildScene ();
  void update ();

  get getAsteroidsList;
}
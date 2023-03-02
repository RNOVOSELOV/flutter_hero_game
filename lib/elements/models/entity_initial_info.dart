import 'dart:math';

class EntityInitialInfo<T> {
  final T x;
  final T y;
  final T? angle;

  EntityInitialInfo({required this.x, required this.y, this.angle});
}

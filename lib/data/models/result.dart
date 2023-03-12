import 'package:hive/hive.dart';

part 'result.g.dart';

@HiveType(typeId: 0)
class Result extends HiveObject {
  @HiveField(0)
  String? name;
  @HiveField(1)
  int score;
  @HiveField(2)
  DateTime dateTime;

  Result({
    this.name = 'unknown',
    required this.score,
    required this.dateTime,
  });
}

import 'package:isar/isar.dart';

part 'result.g.dart';

@collection
class Result {
  Id id = Isar.autoIncrement;
  String? name;
  @Index(type: IndexType.value)
  int score;
  DateTime dateTime;

  Result({
    this.name = 'unknown',
    required this.score,
    required this.dateTime,
  });
}

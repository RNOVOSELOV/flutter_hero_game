import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'game_result.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Result extends Equatable {
  final int score;
  final DateTime dt;

  const Result({required this.score, required this.dt});

  factory Result.fromJson(final Map<String, dynamic> json) =>
      _$ResultFromJson(json);

  Map<String, dynamic> toJson() => _$ResultToJson(this);

  @override
  List<Object?> get props => [dt, score];
}

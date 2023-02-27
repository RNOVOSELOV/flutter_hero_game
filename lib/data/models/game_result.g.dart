// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Result _$ResultFromJson(Map<String, dynamic> json) => Result(
      score: json['score'] as int,
      dt: DateTime.parse(json['dt'] as String),
    );

Map<String, dynamic> _$ResultToJson(Result instance) => <String, dynamic>{
      'score': instance.score,
      'dt': instance.dt.toIso8601String(),
    };

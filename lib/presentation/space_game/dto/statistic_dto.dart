import 'package:equatable/equatable.dart';

class StatisticDto extends Equatable {
  final int score;
  final int brokenLives;

  const StatisticDto({required this.score, required this.brokenLives});

  const StatisticDto.initial()
      : score = 0,
        brokenLives = 0;

  StatisticDto copyWith({int? score, int? brokenLives}) {
    return StatisticDto(
      score: score ?? this.score,
      brokenLives: brokenLives ?? this.brokenLives,
    );
  }

  @override
  List<Object?> get props => [score, brokenLives];
}

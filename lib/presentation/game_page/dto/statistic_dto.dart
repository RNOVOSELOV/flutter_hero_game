import 'package:equatable/equatable.dart';
import 'package:spacehero/resources/app_constants_parameters.dart';

class StatisticDto extends Equatable {
  final int score;
  final int brokenLives;
  final int maxLivesCount;

  const StatisticDto(
      {required this.maxLivesCount,
      required this.score,
      required this.brokenLives});

  const StatisticDto.initial()
      : score = 0,
        brokenLives = 0,
        maxLivesCount = AppConstants.maxLivesCount;

  StatisticDto copyWith({int? score, int? brokenLives, int? maxLivesCount}) {
    return StatisticDto(
      score: score ?? this.score,
      brokenLives: brokenLives ?? this.brokenLives,
      maxLivesCount: maxLivesCount ?? this.maxLivesCount,
    );
  }

  @override
  List<Object?> get props => [score, brokenLives, maxLivesCount];
}

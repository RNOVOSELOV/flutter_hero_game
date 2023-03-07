import 'package:equatable/equatable.dart';
import 'package:spacehero/resources/app_constants_parameters.dart';

class InventDto extends Equatable {
  final int speed;
  final int armor;
  final int rocket;
  final int bomb;

  const InventDto({
    required this.speed,
    required this.armor,
    required this.rocket,
    required this.bomb,
  });

  const InventDto.initial()
      : speed = AppConstants.defaultSpeedBonus,
        armor = AppConstants.defaultArmorBonus,
        rocket = AppConstants.defaultRocketCount,
        bomb = AppConstants.defaultBombCount;

  InventDto copyWith({
    int? speed,
    int? armor,
    int? rocket,
    int? bomb,
  }) {
    return InventDto(
      speed: speed ?? this.speed,
      armor: armor ?? this.armor,
      rocket: rocket ?? this.rocket,
      bomb: bomb ?? this.bomb,
    );
  }

  @override
  List<Object?> get props => [speed, armor, rocket, bomb];
}

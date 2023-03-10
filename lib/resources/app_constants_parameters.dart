class AppConstants {
  AppConstants._();

  static const int defaultSpeedBonus = 0;
  static const int defaultArmorBonus = 0;
  static const int defaultRocketCount = 50;
  static const int defaultBombCount = 3;
  static const int maxLivesCount = 3;

  static const double bonusGenerationTimeInSeconds = 8;
  static const double bonusSideSide = 50;

  static const double blackHoleGenerationTimeInSeconds = 12;
  static const blackHoleMinimumRotationSpeed = 2;
  static const blackHolAdditionalRandomRotationSpeed = 2;
  static const blackHolMinimumSideSize = 40;
  static const blackHolAdditionalRandomSideSize = 100;

  static const double asteroidGenerationTimeInSeconds = 1;
  static const asteroidMinimumSpeed = 3;
  static const asteroidAdditionalRandomSpeed = 4;
  static const asteroidMinimumSideSize = 30;
  static const asteroidAdditionalRandomSideSize = 50;

  static const playerRespawnTime = 4;
  static const playerShipSideSize = 80.0;
  static const double playerSpeed = 3;
  static const int playerAngleRotationCoefficient = 80;

  static const bulletSideSize = 20.0;
  static const bulletSpeed = 10.0;

  static const bombSideSize = 20.0;

  static const maxStatisticsResultsCount = 3;
}

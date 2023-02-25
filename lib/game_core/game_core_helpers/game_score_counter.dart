class GameScoreCounter {
  int _startGameCounterValue = 0;
  int _currentScoreValue = 0;
  GameProgressValue _gameStatus = GameProgressValue.gameNotStarted;

  GameScoreCounter();

  void startGame() {
    _gameStatus = GameProgressValue.gameStarted;
  }

  void endGame() {
    _gameStatus = GameProgressValue.gameEnded;
  }

  bool gameIsEnded () {
    return (_gameStatus == GameProgressValue.gameEnded) ? true : false;
  }

  int getCurrentScore(int counter) {
    switch (_gameStatus) {
      case GameProgressValue.gameNotStarted:
        return 0;
      case GameProgressValue.gameStarted:
        _currentScoreValue = 0;
        _startGameCounterValue = counter;
        _gameStatus = GameProgressValue.gameInProgress;
        return 0;
      case GameProgressValue.gameInProgress:
        _currentScoreValue = counter - _startGameCounterValue;
        return _currentScoreValue;
      case GameProgressValue.gameEnded:
        return _currentScoreValue;
    }
  }
}

enum GameProgressValue {
  gameNotStarted,
  gameStarted,
  gameInProgress,
  gameEnded,
}

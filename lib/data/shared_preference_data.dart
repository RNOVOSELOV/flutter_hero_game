import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceData {
  static const _gameResultsKey = "space_game_results_key";

  static SharedPreferenceData? _instance;

  factory SharedPreferenceData.getInstance() =>
      _instance ??= SharedPreferenceData._internal();

  SharedPreferenceData._internal();

  Future<bool> setResults(final List<String> results) => setItems(_gameResultsKey, results);

  Future<List<String>> getResults() => getItems(_gameResultsKey);

  Future<bool> setItems(
    final String key,
    final List<String> items,
  ) async {
    final sp = await SharedPreferences.getInstance();
    final result = sp.setStringList(key, items);
    return result;
  }

  Future<List<String>> getItems(final String key) async {
    final sp = await SharedPreferences.getInstance();
    return sp.getStringList(key) ?? [];
  }
}

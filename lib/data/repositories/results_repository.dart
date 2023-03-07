import 'dart:convert';
import 'package:spacehero/data/models/game_result.dart';
import 'package:spacehero/data/repositories/list_reactive_repository.dart';
import 'package:spacehero/data/shared_preference_data.dart';

class ResultsRepository extends ListReactiveRepository<Result> {
  final int _maxItemsCount = 10;
  final SharedPreferenceData spData;

  static ResultsRepository? instance;

  ResultsRepository._internal(this.spData);

  factory ResultsRepository.getInstance() => instance ??=
      ResultsRepository._internal(SharedPreferenceData.getInstance());

  @override
  Result convertFromString(String rawItem) =>
      Result.fromJson(json.decode(rawItem));

  @override
  String convertToString(Result item) => json.encode(item.toJson());

  @override
  Future<List<String>> getRawData() => spData.getResults();

  @override
  Future<bool> saveRawData(List<String> items) => spData.setResults(items);

  @override
  Future<bool> addItem(final Result item) async {
    final items = await getItems();
    items.add(item);
    items.sort((a, b) => a.score.compareTo(b.score));
    if (items.length > _maxItemsCount) {
      items.removeRange(_maxItemsCount, items.length);
    }
    return setItems(items);
  }
}

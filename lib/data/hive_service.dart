import 'package:hive_flutter/hive_flutter.dart';
import 'package:spacehero/data/models/result.dart';
import 'package:spacehero/resources/app_constants_parameters.dart';
import 'package:spacehero/resources/app_strings.dart';

class HiveService {
  late final Box<Result> resultsBox;

  HiveService() {
    openDb();
  }

  Future<void> openDb() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ResultAdapter());
    resultsBox = await Hive.openBox<Result>(
      AppStrings.hiveBoxName,
    );
  }

  Future<void> closeDb() async {
    await resultsBox.close();
  }

  Future<int> addResult(Result result) async {
    if (resultsBox.length < AppConstants.maxStatisticsResultsCount) {
      return await resultsBox.add(result);
    }
    final values = resultsBox.values.toList();
    values.sort(
      (a, b) => b.score.compareTo(a.score),
    );
    if (values.last.score < result.score) {
      await values.last.delete();
      return await resultsBox.add(result);
    }
    return Future<int>.value(0);
  }

  List<Result> getPeoples() {
    return resultsBox.values.toList()
      ..sort(
        (a, b) => b.score.compareTo(a.score),
      );
  }
}

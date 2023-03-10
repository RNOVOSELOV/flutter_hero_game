import 'package:isar/isar.dart';
import 'package:spacehero/data/models/result.dart';
import 'package:spacehero/resources/app_constants_parameters.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDb();
  }

  Future<Isar> openDb() async {
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open([ResultSchema]);
    }
    return await Future.value(Isar.getInstance());
  }

  Future<void> addResult(Result result) async {
    final isar = await db;
    isar.writeTxnSync(() => isar.results.putSync(result));
  }

  Future<List<Result>> getPeoples() async {
    final isar = await db;
    return isar.results.where().sortByScoreDesc()
        .limit(AppConstants.maxStatisticsResultsCount)
        .findAllSync();
  }

  Future<void> deleteResults (int score) async {
    final isar = await db;



      final count = await isar.results.filter()
          .scoreLessThan(score)
          .deleteAll();
      print('We deleted $count recipes');

  }
}

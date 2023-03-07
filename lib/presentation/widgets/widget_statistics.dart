import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:spacehero/data/models/game_result.dart';
import 'package:spacehero/presentation/game_page/bloc/space_game_bloc.dart';

class BestResultsWidget extends StatelessWidget {
  final List<Result> results;

  const BestResultsWidget({
    Key? key,
    required this.results,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    results.sort(
      (a, b) => b.score.compareTo(a.score),
    );
    final data = results
        .map((e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(
                "${e.score} - ${DateFormat('dd MMM yyyy').format(e.dt)}",
                style: const TextStyle(fontSize: 14),
              ),
            ))
        .toList();
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            results.isEmpty ? 'EMPTY STATISTIC LIST' : 'BEST RESULTS',
            style: const TextStyle(fontSize: 32),
          ),
          const SizedBox(
            height: 16,
          ),
          ...data,
          const SizedBox(
            height: 16,
          ),
          TextButton(
              onPressed: () =>
                  context.read<SpaceGameBloc>().add(OpenInitialScreenEvent()),
              child: const Text(
                "OPEN START PAGE",
                style: TextStyle(fontSize: 22, color: Colors.lightBlueAccent),
              )),
        ],
      ),
    );
  }
}

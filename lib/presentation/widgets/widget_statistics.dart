import 'package:flutter/material.dart';

class BestResultsWidget extends StatelessWidget {
  const BestResultsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.shrink();
    //   final bloc = Provider.of<GameBloc>(context, listen: false);
    //
    //   return StreamBuilder<List<Result>>(
    //       stream: ResultsRepository.getInstance().observeItems(),
    //       builder: (context, snapshot) {
    //         String title = "EMPTY STATISTIC LIST";
    //         List<Widget> result = [];
    //         if (!snapshot.hasData ||
    //             snapshot.data == null ||
    //             snapshot.data!.isEmpty) {
    //         } else {
    //           title = "BEST RESULTS";
    //           result = snapshot.data!
    //               .map((e) => Padding(
    //                     padding: const EdgeInsets.symmetric(vertical: 2),
    //                     child: Text(
    //                       "${e.score} - ${DateFormat('dd MMM yyyy').format(e.dt)}",
    //                       style: const TextStyle(fontSize: 14),
    //                     ),
    //                   ))
    //               .toList();
    //         }
    //         print("BestResultsWidget ${snapshot.data}");
    //         return Center(
    //           child: Column(
    //             mainAxisSize: MainAxisSize.min,
    //             children: [
    //               Text(
    //                 title,
    //                 style: const TextStyle(fontSize: 32),
    //               ),
    //               const SizedBox(
    //                 height: 16,
    //               ),
    //               ...result,
    //               const SizedBox(
    //                 height: 16,
    //               ),
    //               TextButton(
    //                   onPressed: () => bloc.openFirstPage(),
    //                   child: const Text(
    //                     "OPEN START PAGE",
    //                     style: TextStyle(
    //                         fontSize: 22, color: Colors.lightBlueAccent),
    //                   )),
    //             ],
    //           ),
    //         );
    //       });
  }
}

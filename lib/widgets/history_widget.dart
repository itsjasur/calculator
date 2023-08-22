// // import 'package:flutter/material.dart';

// // class HistoryWidget extends StatefulWidget {
// //   const HistoryWidget({super.key});

// //   @override
// //   State<HistoryWidget> createState() => _HistoryWidgetState();
// // }

// // class _HistoryWidgetState extends State<HistoryWidget> {
// //   @override
// //   void initState() {
// //     super.initState();
// //   }

// //   @override
// //   void dispose() {
// //     super.dispose();
// //   }

// //   Future<void> getHistory() async {}

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: const Text('History')),
// //       body: ListView.builder(
// //         itemCount: 1,
// //         itemBuilder: (BuildContext context, int index) {
// //           return;
// //         },
// //       ),
// //     );
// //   }
// // }


// import 'package:flutter/material.dart';


// Future<void> showBottomImageSheet(
//   BuildContext context,
//   String url,
// ) async {
//   await showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     builder: (BuildContext context) {
//       return Wrap(
//         children: [
//           Container(
//             // color: Colors.transparent,
//             padding: const EdgeInsets.symmetric(vertical: 7),
//             alignment: Alignment.center,
//             child: InkWell(
//               onTap: () {

//               },
//               child: const Text(
//                 'close',
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ),
//           ClipRRect(
//             borderRadius: const BorderRadius.only(
//               topLeft: Radius.circular(15),
//               topRight: Radius.circular(15),
//             ),
//             child: Image.network(url),
//           ),
//         ],
//       );
//     },
//   );
// }

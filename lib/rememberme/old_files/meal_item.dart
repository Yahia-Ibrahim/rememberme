// import 'package:flutter/material.dart';
// import 'package:transparent_image/transparent_image.dart';
//
// import '../models/meal.dart';
//
// class MealItem extends StatelessWidget {
//   const MealItem({super.key, required this.meal, required this.onSelectMeal});
//   final Meal meal;
//
//   final void Function(Meal meal) onSelectMeal;
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.all(8),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(8)
//       ),
//       clipBehavior: Clip.hardEdge,
//       elevation: 2,
//       child: InkWell(
//         onTap: () => onSelectMeal(meal),
//         child: Column(
//           children: [
//             Stack(
//             children: [
//               FadeInImage(
//                   placeholder: MemoryImage(kTransparentImage),
//                   image: NetworkImage(meal.imageUrl),
//               ),
//               Positioned(
//                 bottom: 0,
//                 right: 0,
//                 left: 0,
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 44),
//                   color: Colors.black54,
//                   child: Column(
//                     children: [
//                       Text(
//                           meal.title,
//                           textAlign: TextAlign.center,
//                           maxLines: 2,
//                           softWrap: true,
//                           overflow: TextOverflow.ellipsis,
//                           style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
//                       ),
//                       const SizedBox(height: 12,),
//                       const Row(
//                         children: [
//
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               )
//             ],
//                   ),
//             Padding(
//               padding: const EdgeInsets.all(20),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   Row(
//                     children: [
//                       const Icon(Icons.alarm),
//                       const SizedBox(width: 6),
//                       Text('${meal.duration} min')
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       const Icon(Icons.work),
//                       const SizedBox(width: 6),
//                       Text('${meal.complexityText}.')
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       const Icon(Icons.attach_money),
//                       const SizedBox(width: 6),
//                       Text("${meal.affordabilityText}.")
//                     ],
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//
//
//       ),
//     );
//   }
// }

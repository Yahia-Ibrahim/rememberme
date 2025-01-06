// import 'package:flutter/material.dart';
// import 'package:rememberme/rememberme/widgets/category_grid_item.dart';
//
// import 'dummy_data.dart';
// import '../models/meal.dart';
//
// class CategoriesScreen extends StatelessWidget {
//   const CategoriesScreen({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   title: const Text('Pick your Category', style: TextStyle(fontWeight: FontWeight.w600),),
//       //   backgroundColor: Colors.blue,
//       // ),
//       body: Container(
//         margin: const EdgeInsets.fromLTRB(12, 12, 12, 20),
//         child: GridView(
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               mainAxisSpacing: 20,
//               crossAxisSpacing: 20,
//               childAspectRatio: 3 / 2,
//           ),
//
//           children: [
//             for(final category in availableCategories)
//               CategoryGridItem(category: category,)
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:rememberme/rememberme/old_files/dummy_data.dart';
// import 'package:rememberme/rememberme/models/category.dart';
// import 'package:rememberme/rememberme/screens/meals_screen.dart';
// import 'package:rememberme/rememberme/models/meal.dart';
//
// class CategoryGridItem extends StatelessWidget {
//   const CategoryGridItem({super.key, required this.category,});
//
//   final Category category;
//   //final void Function(Meal meal) onToggleFavorite;
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         final List<Meal> filteredMeals = dummyMeals.where(
//                 (elem) => elem.categories.contains(category.id)).toList();
//         Navigator.of(context).push(
//           MaterialPageRoute(builder: (ctx) => MealsScreen(
//             title: category.title,
//             meals: filteredMeals,
//           ))
//         );
//       },
//       splashColor: Theme.of(context).primaryColor,
//       borderRadius: BorderRadius.circular(16),
//       child: Container(
//           padding: const EdgeInsets.all(15),
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(16),
//               gradient: LinearGradient(
//                 colors: [
//                   category.color.withOpacity(0.54),
//                   category.color.withOpacity(0.9),
//                 ],
//               )
//           ),
//           child: Text(
//               category.title,
//               style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                 color: Theme.of(context).colorScheme.onSurface
//               ),
//           )
//
//       ),
//     );
//   }
// }

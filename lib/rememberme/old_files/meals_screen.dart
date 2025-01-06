// import 'package:flutter/material.dart';
// import 'package:rememberme/rememberme/old_files/meal_details_screen.dart';
// import 'package:rememberme/rememberme/widgets/meal_item.dart';
//
// import '../models/meal.dart';
//
// class MealsScreen extends StatelessWidget {
//   const MealsScreen({super.key, required this.title, required this.meals});
//   final String? title;
//   final List<Meal> meals;
//   //final void Function(Meal meal) onToggleFavorite;
//   @override
//   Widget build(BuildContext context) {
//     return (title == null) ? content(context) : Scaffold(
//       appBar: AppBar(
//           title: Text(title!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
//           backgroundColor: Colors.blue,
//       ),
//       body: content(context),
//     );
//   }
//   SingleChildScrollView content(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         children: meals.map((e) => MealItem(meal: e, onSelectMeal: (Meal meal) {
//           Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => MealDetailsScreen(
//             meal: meal,
//             )));
//         },)).toList(),
//       ),
//     );
//   }
// }

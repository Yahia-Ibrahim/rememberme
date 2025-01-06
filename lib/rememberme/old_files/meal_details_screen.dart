// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:rememberme/rememberme/models/meal.dart';
// import 'package:rememberme/rememberme/old_files/favorites_provider.dart';
//
// class MealDetailsScreen extends ConsumerWidget {
//   const MealDetailsScreen({super.key, required this.meal});
//
//   final Meal meal;
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(meal.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
//         backgroundColor: Colors.blue,
//         actions: [
//           IconButton(onPressed: () {
//             final wasAdded = ref.read(favoritesMealsProvider.notifier).toggleMealFavoriteStatus(meal);
//             ScaffoldMessenger.of(context).clearSnackBars();
//             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text((wasAdded) ? 'Meal added to Favorites':'Meal removed from Favorites')));
//           }, icon: const Icon(Icons.star))
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Image.network(meal.imageUrl),
//             const SizedBox(height: 14,),
//             Text(
//                 'Ingredients',
//                 style: Theme.of(context).textTheme.bodyMedium!.copyWith(
//                   color: Theme.of(context).colorScheme.primary,
//                   fontWeight: FontWeight.bold
//                 ),
//
//             ),
//             const SizedBox(height: 14,),
//             for(final ingredient in meal.ingredients)
//               Text(
//                 ingredient,
//                 style: Theme.of(context).textTheme.bodyMedium!.copyWith(
//                     color: Theme.of(context).colorScheme.onSurface
//                 ),
//               ),
//             const SizedBox(height: 24,),
//             Text(
//               'Steps',
//               style: Theme.of(context).textTheme.bodyMedium!.copyWith(
//                   color: Theme.of(context).colorScheme.primary,
//                   fontWeight: FontWeight.bold
//               ),
//             ),
//             const SizedBox(height: 14,),
//             for(final step in meal.steps)
//                Padding(
//                  padding: const EdgeInsets.symmetric(
//                    vertical: 8,
//                    horizontal: 12,
//                  ),
//                  child: Text(
//                     textAlign: TextAlign.center,
//                     step,
//                     style: Theme.of(context).textTheme.bodyMedium!.copyWith(
//                         color: Theme.of(context).colorScheme.onSurface
//                     ),
//
//                   ),
//                ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import "package:flutter_riverpod/flutter_riverpod.dart";
// import "package:rememberme/rememberme/old_files/dummy_data.dart";
//
// import "../models/meal.dart";
//
//
// class FavoritesMealNotifier extends StateNotifier<List<Meal>>{
//   FavoritesMealNotifier(): super([]);
//   bool toggleMealFavoriteStatus(Meal meal) {
//       final bool isExistent = state.contains(meal);
//       if(isExistent) {
//         state = state.where((e) => e.id != meal.id).toList();
//         return false;
//       }
//       else {
//         state = [...state, meal];
//         return true;
//       }
//   }
// }
//
// final favoritesMealsProvider =
// StateNotifierProvider<FavoritesMealNotifier, List<Meal>>((ref) {
//   return FavoritesMealNotifier();
// });
//

// import "package:flutter_riverpod/flutter_riverpod.dart";
// import "package:rememberme/rememberme/old_files/dummy_data.dart";
//
// import "../models/meal.dart";
//
// enum Filter {
//   glutenFree,
//   lactoseFree,
//   vegan,
//   vegetarian,
// }
//
// class FiltersNotifier extends StateNotifier<Map<Filter, bool>>{
//   FiltersNotifier(): super({
//     Filter.glutenFree : false,
//     Filter.lactoseFree : false,
//     Filter.vegan : false,
//     Filter.vegetarian : false,
//   });
//   void setFilter(Filter filter, bool isActive) {
//     state = {
//       ...state, filter: isActive
//     };
//   }
// }
//
// final filtersProvider =
// StateNotifierProvider<FiltersNotifier, Map<Filter, bool>>((ref) {
//   return FiltersNotifier();
// });
//

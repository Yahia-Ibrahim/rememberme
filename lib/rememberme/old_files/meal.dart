enum Complexity {
  simple,
  challenging,
  hard,
}

enum Affordability {
  affordable,
  pricey,
  luxurious,
}

class Meal {
  const Meal({
    required this.id,
    required this.categories,
    required this.title,
    required this.imageUrl,
    required this.ingredients,
    required this.steps,
    required this.duration,
    required this.complexity,
    required this.affordability,
    required this.isGlutenFree,
    required this.isLactoseFree,
    required this.isVegan,
    required this.isVegetarian,
  });

  final String id;
  final List<String> categories;
  final String title;
  final String imageUrl;
  final List<String> ingredients;
  final List<String> steps;
  final int duration;
  final Complexity complexity;
  final Affordability affordability;
  final bool isGlutenFree;
  final bool isLactoseFree;
  final bool isVegan;
  final bool isVegetarian;

  String get complexityText {
    switch(complexity) {
      case Complexity.simple:
        return 'simple'; break;
      case Complexity.challenging:
        return 'challenging'; break;
      case Complexity.hard:
        return 'hard'; break;
      default:
        return 'Unknown'; break;
    }
  }

  String get affordabilityText {
    switch(affordability) {
      case Affordability.affordable:
        return 'affordable'; break;
      case Affordability.pricey:
        return 'pricey'; break;
      case Affordability.luxurious:
        return 'luxurious'; break;
      default:
        return 'Unknown';
    }
  }
}

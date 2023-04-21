class Cocktail {
  final int id;
  final String name;
  final String description;
  final String image;
  final String recipe;
  final String instructions;

  Cocktail({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.recipe,
    required this.instructions,
  });

  factory Cocktail.fromJson(Map<String, dynamic> json) {
    return Cocktail(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        recipe: json['recipe'],
        instructions: json['instructions'],
        image: json['image']);
  }
}

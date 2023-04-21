import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models/cocktail_model.dart';

Future<List<Cocktail>> loadMenuItems() async {
  String jsonString = await rootBundle.loadString('assets/menu.json');
  List<dynamic> jsonList = json.decode(jsonString);
  List<Cocktail> items =
      jsonList.map((json) => Cocktail.fromJson(json)).toList();
  return items;
}

class CocktailScreen extends StatefulWidget {
  final List<Cocktail> items;

  const CocktailScreen({super.key, required this.items});

  @override
  _CocktailScreenState createState() => _CocktailScreenState();
}

class _CocktailScreenState extends State<CocktailScreen> {
  late Future<List<Cocktail>> _menuItems;

  @override
  void initState() {
    super.initState();
    _menuItems = loadMenuItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Cocktail>>(
        future: _menuItems,
        builder:
            (BuildContext context, AsyncSnapshot<List<Cocktail>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          List<Cocktail> items = snapshot.requireData;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50, left: 20),
                child: Text(
                  "I Want to Learn to Make...",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        _showRecipeOverlay(context, items[index]);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 30, horizontal: 40),
                        child: Card(
                          elevation: 14,
                          color: Color.fromARGB(248, 255, 160, 167),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 40, horizontal: 30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      items[index].name,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.asset(
                                      items[index].image,
                                      fit: BoxFit.cover,
                                      height: 150,
                                      width: 150,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showRecipeOverlay(BuildContext context, Cocktail cocktail) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.grey[200], // Change background color
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ), // Add rounded corners
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.95, // Increase height

          child: Container(
            margin: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                SizedBox(
                  child: Text(
                    cocktail.name,
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ),
                Text(
                  "Recipe",
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ingredients',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(cocktail.recipe),
                      ),
                      Text(
                        'Instructions',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(cocktail.instructions),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

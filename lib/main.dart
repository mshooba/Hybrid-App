import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models/cocktail_model.dart';
import 'cocktail_screen.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadMenuItems(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Cocktail> items = snapshot.data as List<Cocktail>;
          return MaterialApp(
            theme: ThemeData(
              primaryColor: const Color(0xFFFF4081),
              scaffoldBackgroundColor: const Color.fromARGB(253, 253, 229, 200),
              textTheme: const TextTheme(
                displayLarge: TextStyle(
                    fontFamily: 'Azo-Sans-Uber',
                    fontSize: 50,
                    fontWeight: FontWeight.w900,
                    color: Color.fromARGB(248, 255, 112, 122)),
                displayMedium: TextStyle(
                    fontFamily: 'Cereal',
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: Color.fromARGB(255, 54, 54, 54)),
                displaySmall: TextStyle(
                    fontFamily: 'Cereal',
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Color.fromARGB(255, 54, 54, 54)),
                bodyLarge: TextStyle(
                    fontFamily: 'Cereal',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 54, 54, 54)),
                bodyMedium: TextStyle(
                    fontFamily: 'Cereal',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 54, 54, 54)),
                bodySmall: TextStyle(
                    fontFamily: 'Cereal',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 54, 54, 54)),
                // add default TextStyle with color property
              ),
              colorScheme: ColorScheme.fromSwatch()
                  .copyWith(secondary: const Color(0xFFFF4081)),
            ),
            home: Scaffold(
              body: HomeScreen(
                items: items,
              ),
            ),
            
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        // By default, show a loading spinner
        return const CircularProgressIndicator();
      },
    );
  }

  Future<List<Cocktail>> loadMenuItems() async {
    String jsonString = await rootBundle.loadString('assets/menu.json');
    List<dynamic> jsonList = json.decode(jsonString);
    List<Cocktail> items =
        jsonList.map((json) => Cocktail.fromJson(json)).toList();
    return items;
  }
}

class HomeScreen extends StatelessWidget {
  final List<Cocktail> items;
  const HomeScreen({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 100, left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "It's Time for a",
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  Text(
                    "DRINK",
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  Text(
                    "The one stop to find amazing drink mixes\nfor any occasion",
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: 226,
                    height: 58,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 46, 46, 46),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CocktailScreen(items: items),
                          ),
                        );
                      },
                      child: const Text('Get Started'),
                    ),
                  ),
                ),
              ),
            ),
            Image.asset(
              'assets/images/cocktail-home.png',
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}

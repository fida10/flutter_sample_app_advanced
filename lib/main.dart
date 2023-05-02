import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main(){

}

class MyApp extends StatelessWidget {
  //MyApp, the primary widget of the application
//All widgets are here or are children of widgets that are here
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          MyAppState(), //application global items, callable via context
      //stuff like "theme", fonts, colors, etc. can be defined
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData( //this is themedata
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        ),

      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var history = <WordPair>[];


  var favorites = <WordPair>[];

  void removeFavorite(WordPair pair) {
    favorites.remove(pair);
    notifyListeners();
  }
}
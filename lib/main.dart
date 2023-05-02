import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main(){
  runApp(MyApp());
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
  var current = WordPair.random(); //generates a random pair of words, from the WordPair library
  var history = <WordPair>[]; //an empty list (for now) that stores history of wordpairs.

  GlobalKey? historyListKey; 
  //GlobalKey is a way to uniquely something, like a widget state.
  //Here, we are creating a unique variable named historyListKey, which will save the state of some widget later
  //Dart is null safe by default. Adding a '?' tells Dart that it is OK if historyListKey is null
  //We know historyListKey will not be null, as we will assign it, but Dart does not know that and will throw errors if we do not handle this
  //Kind of like "unsafe" in rust

  void getNext(){ //getNext method, presumably to get the next wordPair
    history.insert(0, current); //inserts the "current" object into history at position 0. Essentially inserts current at the beginning of the history list
    var animatedList = historyListKey?.currentState as AnimatedListState?;
    //above, we created a variable called animatedList, which gets the current state of whatever widget we call getNext() from
    //Since we put "as AnimatedList", it can be expected that this will be used in an AnimatedList widget
    //The question marks are again there to tell Dart to ignore null safeties
    //I don't fully understand this. Need more knowledge of Dart for this
    animatedList?.insertItem(0);
    //inserts an item into animated list. Which I guess is also a list. 
    current = WordPair.random(); //resets current into a new WordPair.
    notifyListeners(); //all widgets currently watching MyAppState are notified of the change
  }
  //so in summary, it looks like this adds a new wordpair to the historyList whenever it is called. 
  //that historyList is then displayed in another widget
  //as there is an app state change that is happening, we had to go through the details of extracting and saving the state

  var favorites = <WordPair>[]; //an empty list (for now) that stores favorited word pairs

  void toggleFavorite([WordPair? pair]) { //Assuming that this is what happens after the like button is selected
    //above is a function declaration, that takes a wordpair list as a parameter. Question mark for handling null if the list provided has nothing in it
    pair = pair ?? current; //the double question mark does the following: 
    //if pair is not assigned, it is given the value of current.
      //which I suppose means if Wordpair list is empty
      //double question mark basically provides a default value, if pair is null.
    if(favorites.contains(pair)) {
      favorites.remove(pair);
    } else{
      favorites.add(pair);
    } //adds pair to the favorites list if it is not already in there. If it is, pair is removed from the list
    notifyListeners(); //as always, with a change in the app, listeners are notified and the app is basically reloaded
  }

  void removeFavorite(WordPair pair) { //removes a favorited word from the favorites list.
  //assumption is that this would be called when the garbage can next to a word on the favorites list is called
    favorites.remove(pair);
    notifyListeners();
  }
}
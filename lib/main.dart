import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
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
        theme: ThemeData(
          //this is themedata
        theme: ThemeData(
          //this is themedata
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        ),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair
      .random(); //generates a random pair of words, from the WordPair library
  var history =
      <WordPair>[]; //an empty list (for now) that stores history of wordpairs.

  GlobalKey? historyListKey;
  //GlobalKey is a way to uniquely something, like a widget state.
  //Here, we are creating a unique variable named historyListKey, which will save the state of some widget later
  //Dart is null safe by default. Adding a '?' tells Dart that it is OK if historyListKey is null
  //We know historyListKey will not be null, as we will assign it, but Dart does not know that and will throw errors if we do not handle this
  //Kind of like "unsafe" in rust

  void getNext() {
    //getNext method, presumably to get the next wordPair
    history.insert(0,
        current); //inserts the "current" object into history at position 0. Essentially inserts current at the beginning of the history list
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

  var favorites =
      <WordPair>[]; //an empty list (for now) that stores favorited word pairs

  void toggleFavorite([WordPair? pair]) {
    //Assuming that this is what happens after the like button is selected
    //above is a function declaration, that takes a wordpair list as a parameter. Question mark for handling null if the list provided has nothing in it
    pair = pair ?? current; //the double question mark does the following:
    //if pair is not assigned, it is given the value of current.
    //which I suppose means if Wordpair list is empty
    //double question mark basically provides a default value, if pair is null.
    if (favorites.contains(pair)) {
      favorites.remove(pair);
    } else {
      favorites.add(pair);
    } //adds pair to the favorites list if it is not already in there. If it is, pair is removed from the list
    notifyListeners(); //as always, with a change in the app, listeners are notified and the app is basically reloaded
  }

  void removeFavorite(WordPair pair) {
    //removes a favorited word from the favorites list.
    //assumption is that this would be called when the garbage can next to a word on the favorites list is called
    favorites.remove(pair);
    notifyListeners();
  }
}

class HistoryListView extends StatefulWidget {
  const HistoryListView({Key? key}) : super(key: key);

  @override
  State<HistoryListView> createState() => _HistoryListViewState();
}

class _HistoryListViewState extends State<HistoryListView> {
  /// Needed so that [MyAppState] can tell [AnimatedList] below to animate
  /// new items.
  final _key = GlobalKey(); //links this state to the app state somehow (this is initialized in the app state)

  /// Used to "fade out" the history items at the top, to suggest continuation.
  static const Gradient _maskingGradient = LinearGradient(
    // This gradient goes from fully transparent to fully opaque black...
    colors: [Colors.transparent, Colors.black],
    // ... from the top (transparent) to half (0.5) of the way to the bottom.
    stops: [0.0, 0.5],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  ); //so this right here is how you do a fade out. This fades out the list

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>(); //even though this is a stateful widget, it is still possible for it to watch the app state too!
    appState.historyListKey = _key;

    return ShaderMask(
      shaderCallback: (bounds) => _maskingGradient.createShader(bounds), //applies the masking gradient created above to the returned widget, which I believe is a list
      // This blend mode takes the opacity of the shader (i.e. our gradient)
      // and applies it to the destination (i.e. our animated list).
      blendMode: BlendMode.dstIn, //the mode the words blend in (disappear?)
      child: AnimatedList( //a moving list widget
        key: _key, //this looks like it gets the app state we made in global app state here
        reverse: true, //I suppose this makes the list go from bottom to top
        padding: EdgeInsets.only(top: 100), //padding values set
        initialItemCount: appState.history.length,
        itemBuilder: (context, index, animation) {
          final pair = appState.history[index]; //gets the current wordpair, I think. No idea how it generates the index
          return SizeTransition( //another type of widget. This is the animation for the box, when a new word that is bigger or smaller comes within it
            sizeFactor: animation, 
            child: Center(
              child: TextButton.icon(
                onPressed: () {
                  appState.toggleFavorite(pair); //generates a new wordpair, using the method inside of app state
                },
                icon: appState.favorites.contains(pair) //wordpairs get added to the animated list as they are liked/next'ed
                    ? Icon(Icons.favorite, size: 12) //adds a small icon (heart) to words that have been favorited
                    : SizedBox(),
                label: Text( //specifies properties of the Text inside this widget. In this case, it is the word pair 
                  pair.asLowerCase,
                  semanticsLabel: pair.asPascalCase,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


class BigCard extends StatelessWidget {
  // বিগকার্ড নতুন একটি স্টেটলেস উইজেট।
  const BigCard({
    // conts এর অর্থ হলো একদম আটকে দেওয়া। যার মান কোন সময় পরিবর্তন করা যায় না।
    Key? Key, // এইটা বুঝতে পারিনাই?
    required this.pair, // এইটা বুঝতে পারিনাই?
  }) : super(key: Key);

  final WordPair
      pair; //এটি একটি Dart প্রোগ্রামিং এর ভেরিয়েবল। একবার এটি ফাইনাল করলে আর পরিবর্তন করা যাবে না।

  @override
  Widget build(BuildContext context) {
    // আমরা বিল্ড এর ভেতরে যাকিছু লিখেদেই তা আমাদের স্ক্রিনে দেখতে পাই। আমরা এর ভিতরে যতি কোন পরিবর্তন করি তা এই বিল্ড এর মাধ্যমে স্ক্রিনে পুনরায় আমাদের দেখিয়ে দেয়।
    var theme = Theme.of(
        context); // var হলো একটি জাভাস্ক্রিনের ভেরিয়েবল। ভেরিয়েবল স্পষ্টভাবে টাইপ ডিক্লার না হলে এর মান পরিবর্তন যোগ্য।
    var style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme
          .onPrimary, // মাইএ্যপস্টেট এর মধ্যে আমরা যে কালার উল্লেখ করেছি।
    );

    return Card(
      color: theme.colorScheme
          .primary, // মাইএ্যপস্টেট এর মধ্যে আমরা যে কালার উল্লেখ করেছি।
      child: Padding(
        // এটি হলো লেআউট প্রপার্টি যা উইজেটের সাথে তার পরিবেশকে কত দূরত্বে পরিবর্তন না করে বর্থমান উইজেটের আকার পরিবর্তন করে। এটি পেজের কতটুকু জায়গা নেবে তা উল্লেখ করে দেওয়া যায়।
        padding: const EdgeInsets.all(15),
        child: AnimatedSize(
          //এটি অ্যানিমেশন সহ একটি স্থানান্তরিত উইজেট সরবরাহ করে। এটি আকার পরিবর্তন করতে পারে।
          duration: Duration(
              milliseconds:
                  150), //'milliseconds' একটি সময় একক, যা সেকেন্ডের এক হাজারতমান শতাংশ। এটি কম্পিউটার সফটওয়্যারে সময় নির্ণয়ে ব্যবহৃত হয়, যেমন একটি ফাংশনে কতক্ষণ অপেক্ষা করতে হবে বা কোনও এনিমেশনে কতক্ষণ একটি অ্যানিমেশন চলবে এর মাধ্যমে সময় নির্ণয় করা হয়। 1 মিলিসেকেন্ড সেকেন্ডের 1/1000 হিসাবে গণ্য হয়।
          child: MergeSemantics(
            // এটি এক বা একাধিক টাইল্ড উইজেট কে একত্রিত করে স্ক্রিনে দেখানোর জন্য এই সেমান্টিক ব্যবহার করা হয়।
            child: Wrap(
              // wrap হলো এমন একটি উইজেট যা ব্যবহার করে অন্য উইজেটগুলো একসাথে ফাঁকা জায়গা পূর্ণ করে স্ক্রীনে প্রদর্শিত করা যায়। যেমন, একটি কলামে বিভিন্ন সাইজের ছবি বা টেক্সট দেখানোর জন্য wrap ব্যবহার করা হয়। Wrap এর সাথে একটি প্যারামিটার হিসেবে direction ব্যবহার করে সাজানো যায় যার মাধ্যমে এর লেআউট পরিবর্তন করা যায়।
              children: [
                Text(
                  pair.first, // বিগকার্ডে যে শব্দটি প্রতিবার আসে তার প্রথম অংশ কে pair.first বলা হয়।
                  style: style.copyWith(
                      fontWeight: FontWeight
                          .w100), // যে শব্দটি এলো তার ধরণ কেমন হবে তা আমরা বলে দিলাম।
                ),
                Text(
                  pair.second, // বিগকার্ডে যে শব্দটি প্রতিবার আসে তার প্রথম অংশ কে pair.second বলা হয়।
                  style: style.copyWith(
                      fontWeight: FontWeight
                          .bold), // যে শব্দটি এলো তার ধরণ কেমন হবে তা আমরা বলে দিলাম।
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}



class FavoritesPage extends StatelessWidget {
  // FavoritesPage নতুন একটি স্টেটলেস উইজেট।
  @override
  Widget build(BuildContext context) {
    // conts এর অর্থ হলো একদম আটকে দেওয়া। যার মান কোন সময় পরিবর্তন করা যায় না।
    var theme = Theme.of(
        context); // var হলো একটি জাভাস্ক্রিনের ভেরিয়েবল। ভেরিয়েবল স্পষ্টভাবে টাইপ ডিক্লার না হলে এর মান পরিবর্তন যোগ্য।
    var appState = context.watch<
        MyAppState>(); // var হলো একটি জাভাস্ক্রিনের ভেরিয়েবল। ভেরিয়েবল স্পষ্টভাবে টাইপ ডিক্লার না হলে এর মান পরিবর্তন যোগ্য।

    if (appState.favorites.isEmpty) {
      // এই লাইনটি একটি শর্তের লজিকাল অংশ (logical statement) বা শর্ত চেক করে একটি অধিকতর অংশের মধ্যে ব্যবহৃত হয়।এটি চেক করে যে appState এর favorites নামক অ্যারে খালি না তাহলে এর ভিতরের কোডব্লক অংশ এক্সিকিউট হবে। যদি শর্তটি সত্য না হয় তাহলে এই কোডব্লক অংশ এসে নিচ্ছে না বা এর বর্তমান স্টেট বা অবজেক্ট স্টেট অনুযায়ী কাজ করবে।
      return Center(
        //স্ক্রীনের কেন্দ্র পরিবর্তন করে না কিন্তু একটি উইজেট বা স্ট্রিং কে কেন্দ্রভাবে স্থানান্তর করে দেয়া হয়। উইজেটটি স্ক্রীনের কেন্দ্রে স্থানান্তর করে দেয়া হলে উইজেটটি আকারের সাথে সম্পর্কিত উপাদান একটি কেন্দ্রবিন্দুতে স্থান পাবে।
        child: Text('No favorites yet.'),
      );
    }

    return Column(
      //কলাম লেআউট হল স্ক্রীনে তথ্য প্রদর্শনের জন্য ব্যবহৃত হয় যেখানে তথ্যগুলো একটি স্ট্রিং বা অন্য কোন উইজেট হতে পারে। একটি Column সাধারণত একটি উচ্চতা বা প্রস্থ দিয়ে তৈরি হয় এবং এক সাথে একাধিক উইজেট বা স্ট্রিং সম্পাদন করার জন্য ব্যবহৃত হয়।
      crossAxisAlignment: CrossAxisAlignment
          .start, //এটি ফ্লাটারের কোন ওয়িজেটের স্থানান্তর বা লেআউট পুনর্নির্দেশ করে। এটি Column এবং Row ওয়িজেটে ব্যবহৃত হয় যাতে উক্ত ওয়িজেটের সমস্ত চাইল্ড ওয়িজেট একই হাইটে না থাকলে চাইল্ড ওয়িজেটগুলি বামদিকে জোড়া হয়ে থাকে।
      children: [
        Padding(
          // এটি হলো লেআউট প্রপার্টি যা উইজেটের সাথে তার পরিবেশকে কত দূরত্বে পরিবর্তন না করে বর্থমান উইজেটের আকার পরিবর্তন করে। এটি পেজের কতটুকু জায়গা নেবে তা উল্লেখ করে দেওয়া যায়।
          padding: const EdgeInsets.all(30),
          child: Text('You have '
              '${appState.favorites.length} favorites:'),
        ),
        Expanded(
          //Expanded হলো ফ্লাটারে একটি লেআউট প্রপার্টি যা দ্বিতীয় বা তৃতীয় উইজেটের সাথে ব্যবহৃত হয়। এটি একটি উইজেটের আকার পরিবর্তন করতে সাহায্য করে যাতে উক্ত উইজেটটি তার প্যারেন্ট উইজেটের সমস্ত উইজেটের মধ্যে মধ্যস্থতা নির্ধারণ করতে পারে।
          child: GridView(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              //ফ্লাটারে ব্যবহৃত SliverGrid উইজেটের একটি প্রপার্টি। এটি একটি SliverGridDelegate উইজেট দেখার জন্য উপযোগী, যা গ্রিডের স্লিভারগুলি নিয়ন্ত্রণ করে।
              maxCrossAxisExtent:
                  400, //maxCrossAxisExtent হল একটি প্রোপার্টি যা SliverGrid উইজেটের জন্য ব্যবহার করা হয়। এটি ক্রস এক্সিস উইজেটের সর্বাধিক পরিসীমা (প্রত্যেক উইজেটের প্রস্থ বা দৈর্ঘ্য) নির্ধারণ করে এবং যদি উইজেট এই সীমা অতিক্রম করে তবে এটি নিয়ন্ত্রিত করে উইজেটের সাইজ।
              childAspectRatio: 400 /
                  80, //childAspectRatio ফ্লাটারে একটি AspectRatio উইজেটের একটি প্রোপার্টি যা ব্যবহার করা হয়।আমরা GridView, ListView, বা Wrap উইজেটগুলো ব্যবহার করি। এই উইজেটগুলো আপনাকে চাইল্ড উইজেটগুলোর আকার নির্দিষ্ট করতে দেয়। সাধারণত আমরা স্ক্রীনে যতগুলো কলাম বা সারি দেখানোর চেষ্টা করি ততগুলো উইজেটকে সমান আকারে বিভক্ত করি। এটা হল childAspectRatio এর উপস্থিতির কারণে। এটি আপনাকে সেট করতে হবে যখন আপনি এই উইজেটগুলো ব্যবহার করবেন
            ),
            children: [
              for (var pair in appState
                  .favorites) //আপনি যে কোড স্নিপেটটি দেখাচ্ছেন তা JavaScript লেখা, না যে Flutter এ ব্যবহৃত হয়। তবে, মানে হলো যদি appState.favorites একটি অবজেক্ট হয় তবে for...in লুপটি অবজেক্টের প্রতিটি প্রোপার্টির জন্য লুপ চালাবে। প্রতিটি প্রোপার্টির জন্য, লুপটি pair নামক একটি ভেরিয়েবল তৈরি করবে এবং এর মাধ্যমে সে প্রতিটি প্রোপার্টির কী (key) এবং ভ্যালু (value) এর মান অ্যাক্সেস করতে পারবেন।
                ListTile(
                  leading: IconButton(
                    //একটি আইকন বা ছবি দেখানোর সাথে সাথে একটি স্পেসিফিক অ্যাকশন যুক্ত করা যায়, যেমন কোন একটি পৃষ্ঠা বা স্ক্রীন খোলা, একটি ফাংশন কল করা ইত্যাদি।
                    icon: Icon(Icons.delete_outline, semanticLabel: 'Delete'),
                    color: theme.colorScheme
                        .primary, // মাইএ্যপস্টেট এর মধ্যে আমরা যে কালার উল্লেখ করেছি।
                    onPressed: () {
                      appState.removeFavorite(pair);
                    },
                  ),
                  title: Text(
                    pair.asLowerCase, //একটি পেয়ার এর দুইটি উপাদান থাকে এবং উপাদানগুলির নাম কেমন হয় তা প্রোগ্রামার নির্ভর করে। যেমন, যদি একটি পেয়ারে দুইটি নাম থাকে "Name" এবং "Age" তবে সম্ভবত কোডে পেয়ারের দুইটি উপাদান কেই নিম্নরূপে অ্যাক্সেস করা হয়েছে: pair.Name এবং pair.Age।প্রোগ্রামিং ভাষাতে উপাদানের নাম ক্যাপিটাল হলে সেটি উপাদানের নাম লোয়ারকেসে রুপান্তর করা হয়
                    semanticsLabel: pair
                        .asPascalCase, // // এটি এক বা একাধিক টাইল্ড উইজেট কে একত্রিত করে স্ক্রিনে দেখানোর জন্য এই সেমান্টিক ব্যবহার করা হয়।
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

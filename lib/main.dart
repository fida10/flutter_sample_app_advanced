import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {}

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

// added list

class FavoritesPage extends StatelessWidget {// FavoritesPage নতুন একটি স্টেটলেস উইজেট।
  @override
  Widget build(BuildContext context) {// conts এর অর্থ হলো একদম আটকে দেওয়া। যার মান কোন সময় পরিবর্তন করা যায় না।
    var theme = Theme.of(context);// var হলো একটি জাভাস্ক্রিনের ভেরিয়েবল। ভেরিয়েবল স্পষ্টভাবে টাইপ ডিক্লার না হলে এর মান পরিবর্তন যোগ্য।
    var appState = context.watch<MyAppState>();// var হলো একটি জাভাস্ক্রিনের ভেরিয়েবল। ভেরিয়েবল স্পষ্টভাবে টাইপ ডিক্লার না হলে এর মান পরিবর্তন যোগ্য।

    if (appState.favorites.isEmpty) {// এইটা বুঝতে পারিনাই?
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,//এটি ফ্লাটারের কোন ওয়িজেটের স্থানান্তর বা লেআউট পুনর্নির্দেশ করে। এটি Column এবং Row ওয়িজেটে ব্যবহৃত হয় যাতে উক্ত ওয়িজেটের সমস্ত চাইল্ড ওয়িজেট একই হাইটে না থাকলে চাইল্ড ওয়িজেটগুলি বামদিকে জোড়া হয়ে থাকে।
      children: [
        Padding(    // এটি হলো লেআউট প্রপার্টি যা উইজেটের সাথে তার পরিবেশকে কত দূরত্বে পরিবর্তন না করে বর্থমান উইজেটের আকার পরিবর্তন করে। এটি পেজের কতটুকু জায়গা নেবে তা উল্লেখ করে দেওয়া যায়।
          padding: const EdgeInsets.all(30),
          child: Text('You have '
              '${appState.favorites.length} favorites:'),
        ),
        Expanded(//Expanded হলো ফ্লাটারে একটি লেআউট প্রপার্টি যা দ্বিতীয় বা তৃতীয় উইজেটের সাথে ব্যবহৃত হয়। এটি একটি উইজেটের আকার পরিবর্তন করতে সাহায্য করে যাতে উক্ত উইজেটটি তার প্যারেন্ট উইজেটের সমস্ত উইজেটের মধ্যে মধ্যস্থতা নির্ধারণ করতে পারে।
         child: GridView(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(//ফ্লাটারে ব্যবহৃত SliverGrid উইজেটের একটি প্রপার্টি। এটি একটি SliverGridDelegate উইজেট দেখার জন্য উপযোগী, যা গ্রিডের স্লিভারগুলি নিয়ন্ত্রণ করে।
              maxCrossAxisExtent: 400, //maxCrossAxisExtent হল একটি প্রোপার্টি যা SliverGrid উইজেটের জন্য ব্যবহার করা হয়। এটি ক্রস এক্সিস উইজেটের সর্বাধিক পরিসীমা (প্রত্যেক উইজেটের প্রস্থ বা দৈর্ঘ্য) নির্ধারণ করে এবং যদি উইজেট এই সীমা অতিক্রম করে তবে এটি নিয়ন্ত্রিত করে উইজেটের সাইজ।
              childAspectRatio: 400 / 80,//childAspectRatio ফ্লাটারে একটি AspectRatio উইজেটের একটি প্রোপার্টি যা ব্যবহার করা হয়।আমরা GridView, ListView, বা Wrap উইজেটগুলো ব্যবহার করি। এই উইজেটগুলো আপনাকে চাইল্ড উইজেটগুলোর আকার নির্দিষ্ট করতে দেয়। সাধারণত আমরা স্ক্রীনে যতগুলো কলাম বা সারি দেখানোর চেষ্টা করি ততগুলো উইজেটকে সমান আকারে বিভক্ত করি। এটা হল childAspectRatio এর উপস্থিতির কারণে। এটি আপনাকে সেট করতে হবে যখন আপনি এই উইজেটগুলো ব্যবহার করবেন
            ),
            children: [
              for (var pair in appState.favorites)//আপনি যে কোড স্নিপেটটি দেখাচ্ছেন তা JavaScript লেখা, না যে Flutter এ ব্যবহৃত হয়। তবে, মানে হলো যদি appState.favorites একটি অবজেক্ট হয় তবে for...in লুপটি অবজেক্টের প্রতিটি প্রোপার্টির জন্য লুপ চালাবে। প্রতিটি প্রোপার্টির জন্য, লুপটি pair নামক একটি ভেরিয়েবল তৈরি করবে এবং এর মাধ্যমে সে প্রতিটি প্রোপার্টির কী (key) এবং ভ্যালু (value) এর মান অ্যাক্সেস করতে পারবেন।
                ListTile(
                  leading: IconButton(
                    icon: Icon(Icons.delete_outline, semanticLabel: 'Delete'),
                    color: theme.colorScheme.primary,// মাইএ্যপস্টেট এর মধ্যে আমরা যে কালার উল্লেখ করেছি।
                    onPressed: () {
                      appState.removeFavorite(pair);
                    },
                  ),
                  title: Text(
                    pair.asLowerCase,//একটি পেয়ার এর দুইটি উপাদান থাকে এবং উপাদানগুলির নাম কেমন হয় তা প্রোগ্রামার নির্ভর করে। যেমন, যদি একটি পেয়ারে দুইটি নাম থাকে "Name" এবং "Age" তবে সম্ভবত কোডে পেয়ারের দুইটি উপাদান কেই নিম্নরূপে অ্যাক্সেস করা হয়েছে: pair.Name এবং pair.Age।প্রোগ্রামিং ভাষাতে উপাদানের নাম ক্যাপিটাল হলে সেটি উপাদানের নাম লোয়ারকেসে রুপান্তর করা হয় 
                    semanticsLabel: pair.asPascalCase,// // এটি এক বা একাধিক টাইল্ড উইজেট কে একত্রিত করে স্ক্রিনে দেখানোর জন্য এই সেমান্টিক ব্যবহার করা হয়।
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

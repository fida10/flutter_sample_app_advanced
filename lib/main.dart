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
              // এইটা বুঝতে পারিনাই?
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

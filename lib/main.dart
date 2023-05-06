import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var history = <WordPair>[];

  GlobalKey? historyListKey;

  void getNext() {
    history.insert(0, current);
    var animatedList = historyListKey?.currentState as AnimatedListState?;
    animatedList?.insertItem(0);
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorite([WordPair? pair]) {
    pair = pair ?? current;
    if (favorites.contains(pair)) {
      favorites.remove(pair);
    } else {
      favorites.add(pair);
    }
    notifyListeners();
  }

  void removeFavorite(WordPair pair) {
    favorites.remove(pair);
    notifyListeners();
  }
}

//shakil  home work11

class MyHomePage extends StatefulWidget {
  // jode widget er modde poriborthon ba onek kisu add korrte chai tahole StatefulWidget use kori
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context)
        .colorScheme; // color proparrti babohar kora hoice colorScheme variabale er madhome (context)

    Widget page; //
    switch (selectedIndex) {
      // programing languages e 0 theke count hoy for example:0,1,2,
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = Placeholder();
        break;
      default:
        throw UnimplementedError(
            'no widget for $selectedIndex'); // $ use kora hoy string er modde kono variabale er karjoksrta ba kaj k show koranor jonno
    }

    var mainArea = ColoredBox(
      // bujinai??????
      color: colorScheme.surfaceVariant,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        child: page,
      ),
    );

    return Scaffold(
      // akta building er kaj korte jamo bas ba lohar kathamo dorkar hoy app er modde scaffold ta mon kathamor moto kaj kore
      body: LayoutBuilder(
        // simana nirdharon kora jonno,
        builder: (context, constraints) {
          // buji nai ?
          if (constraints.maxWidth < 450) {
            return Column(
              //aktar niche r akta rakhar jonno ba sajanor jono
              children: [
                Expanded(
                    child:
                        mainArea), // ak onsho bade baki onsho onno k deyadeyo
                SafeArea(
                  //app er bam side e akta jaygha creat kora j khan e bivinoo icon butto add kora hoy
                  child: BottomNavigationBar(
                    // kono Widget er niche/bottom e button creat korar jonnoo
                    items: [
                      BottomNavigationBarItem(
                        icon: Icon(Icons
                            .home), // button er icon ki logo hobe ta nirdharon kora hoy
                        label:
                            'Home', //icon tar ki nam deya hobe ta nirdaron kora hoy
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.favorite),
                        label: 'Favorites',
                      ),
                    ],
                    currentIndex:
                        selectedIndex, //  icon/button k cromick vabe sajanor jonno
                    onTap: (value) {
                      //ontap buji nai????????
                      setState(() {
                        //145
                        selectedIndex = value;
                      });
                    },
                  ),
                )
              ],
            );
          } else {
            // else babohar er karon airow er modde obastan sob button,icon side e r bottom e both show korbe

            return Row(
              //widget er modde kono kisu bam theke dan e sajate babohar kora hoy
              children: [
                //
                SafeArea(
                  // 107
                  child: NavigationRail(
                    // ati akti widget jar modde onek properti babohar kora jay backgroundColor,labelType,minWidth,elevation
                    extended: constraints.maxWidth >=
                        600, //layout builder er modde simana nir dharon kora hoice jode 600 ba tar soman hoy tahole safeare modde icon nam show korabe onno thay na
                    destinations: [
                      NavigationRailDestination(
                        icon: Icon(Icons.home),
                        label: Text('Home'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.favorite),
                        label: Text('Favorites'),
                      ),
                    ],
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (value) {
                      setState(() {
                        // safeare er modde j kono icon/button e press korle 77 number line k call back korbe than sei press e ki ghotona ghotbe ta nirdharon korbe
                        selectedIndex = value;
                      });
                    },
                  ),
                ),
                Expanded(child: mainArea),
              ],
            );
          }
        },
      ),
    );
  }
}

// shakil home work2

class GeneratorPage extends StatelessWidget {
  //Stateless widget ja nirdisto /const kore rakhar jonno
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<
        MyAppState>(); // Widget er moddr kono rokom poriborton ba change hole ta dekhe Myappstate k jananor jonno watch method use koora hoy
    var pair = appState
        .current; //  pair variabale er modde appState.current k store kora hoice

    IconData
        icon; // icon data ja if else statement er madhome present kora hoice if/jode (posondo hoy) heart icon show  korabe else/onnothay jode posondo na hoy tahoke heart icon show korabe na faka thake sudhu  heart icon boder ba ager ta thakbe
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
        child: Column(
      //
      mainAxisAlignment:
          MainAxisAlignment.center, // maje borabor kono elements dekhanor jonno
      children: [
        SizedBox(height: 10),
        SizedBox(height: 10),
        Row(
          //
          mainAxisSize: MainAxisSize
              .min, // e ti row er modde thka elements gula k (min/max)side ba maje prodorshon kore
          children: [
            ElevatedButton.icon(
              onPressed: () {
                // button er press korle ki hobe ta dekhano hoice
                appState.toggleFavorite();
              },
              icon: Icon(icon),
              label: Text('Like'),
            ),
            SizedBox(
                width:
                    10), // duita button er modde space barano ba komano er jonno
            ElevatedButton(
              onPressed: () {
                appState.getNext(); //188
              },
              child: Text('Next'),
            ),
          ],
        ),
        Spacer(flex: 2),

        ///?? bujinai
      ],
    ));
  }
}

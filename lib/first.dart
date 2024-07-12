

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main () {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'My App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;

    switch (_selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      default: 
        throw UnimplementedError("Unknown selected index $_selectedIndex");
    }

    return LayoutBuilder(
      builder: (context, containers) {
        return Scaffold(
          body: Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  extended: containers.maxWidth >= 600,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home')
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite_rounded),
                      label: Text("Favorites")
                    )
                  ],
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (value) => {
                    setState(() {
                      _selectedIndex = value;
                    })
                  },
                )
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              )
            ],
          ),
        );
      }
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  var favourites = <WordPair>[];

  void doGetNext() {
    current = WordPair.random();
    notifyListeners();
  }

  void doToggleFavourite(WordPair pair) {
    if (favourites.contains(pair)) {
      favourites.remove(pair);
    } else {
      favourites.add(pair);
    }
    notifyListeners();
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favourites.contains(pair)) {
      icon = Icons.favorite_rounded;
    } else {
      icon = Icons.favorite_outline_rounded;
    } 

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PairWord(pair: pair),
          SizedBox(height: 20),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(onPressed: () => { appState.doToggleFavourite(pair) }, label: Text("Favourites"), icon: Icon(icon)),
              SizedBox(width: 20,),
              ElevatedButton(onPressed: () => { appState.doGetNext() }, child: Text("Next")),
            ],
          )
        ],
      ),
    );
  }
}

class PairWord extends StatelessWidget {
  const PairWord({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary
    );
    
    return Card(
      color: theme.primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text('${pair.first}${pair.second}', style: textStyle,),
      ),
    );
  }
}


class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    final theme = Theme.of(context);

    if (appState.favourites.isEmpty) {
      return Center(
        child: Text("No favorites yet"),
      );
    }

    print(appState.favourites.map((p) => Text("${p.first}${p.second}")).toList());
    // return Column(
    //   children: [
    //     Text('Favorites', style: theme.textTheme.titleMedium),
    //     ListView(
    //       children: appState.favourites.map((p) => Text("${p.first}${p.second}")).toList(),
    //     )
    //   ],
    // );
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have '
              '${appState.favourites.length} favorites:', style: theme.textTheme.titleMedium,),
        ),
        for (var pair in appState.favourites)
          ListTile(
            leading: IconButton(
              color: theme.colorScheme.primary,
              icon: Icon(Icons.favorite_rounded),
              onPressed:() => appState.doToggleFavourite(pair),
            ),
            title: Text(pair.asLowerCase),
          ),
      ],
    );
  }
}

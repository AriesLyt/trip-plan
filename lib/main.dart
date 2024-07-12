
import 'package:flutter/material.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal
      ),
      home: MyApp()
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.teal[800],
            pinned: true,
            // snap: true,
            // floating: true,
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text("SliverAppBar", style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Theme.of(context).colorScheme.onPrimary),),
            ),
          ),
          SliverList(delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
            return Row(
              children: [
                SizedBox(width: 100, height: 100, child: Icon(Icons.abc)),
                Text("Line $index")
              ],
            );
          }, childCount: 20))
        ],
      ),
    );
  }
}
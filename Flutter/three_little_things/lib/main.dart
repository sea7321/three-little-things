import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.lightGreen,
      ),
      home: const AppLayout(),
    );
  }
}

enum Page { analytics, addEntry, community, settings }

class AppLayout extends StatefulWidget {
  const AppLayout({Key? key}) : super(key: key);

  @override
  State<AppLayout> createState() => _App();
}

class _App extends State<AppLayout> {
  Page _selectedPage = Page.community;

  void _onItemTapped(int index) {
    setState(() {
      _selectedPage = Page.values[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: const EdgeInsets.only(top: 75, left: 25, right: 25),
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/background.png"),
                  fit: BoxFit.fill)),
          child: const ChartPage()),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: SizedBox(
                  child: Image(image: AssetImage('assets/chart.png')),
                  width: 100,
                  height: 100),
              label: ""),
          BottomNavigationBarItem(
              icon: SizedBox(
                  child: Image(image: AssetImage('assets/add.png')),
                  width: 100,
                  height: 100),
              label: ""),
          BottomNavigationBarItem(
              icon: SizedBox(
                  child: Image(image: AssetImage('assets/community.png')),
                  width: 100,
                  height: 100),
              label: ""),
          BottomNavigationBarItem(
              icon: SizedBox(
                  child: Image(image: AssetImage('assets/settings.png')),
                  width: 100,
                  height: 100),
              label: ""),
        ],
        currentIndex: _selectedPage.index,
        onTap: _onItemTapped,
        iconSize: 6,
      ),
    );
  }
}

class ChartPage extends StatelessWidget {
  const ChartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
        child: Align(
            alignment: Alignment.topCenter,
            child: Column(children: [
              const Text("What have you accomplished in the past",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              DropdownButton(
                  value: "week",
                  style: const TextStyle(fontSize: 24, color: Colors.black),
                  items: <String>['week', 'month', 'year', 'life']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? val) {})
            ])));
  }
}

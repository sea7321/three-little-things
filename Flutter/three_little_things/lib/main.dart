import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseData {
  CollectionReference<Map<String, dynamic>> thoughtCollection;
  String uuid;
  
  FirebaseData(this.thoughtCollection, this.uuid);
}

void main() => runApp(const MyApp());

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
      home: const FirstRoute(),
    );
  }
}

class FirstRoute extends StatelessWidget {
  const FirstRoute({Key? key}) : super(key: key);
  
  Future<FirebaseData> getData() async {
    await Firebase.initializeApp(options: FirebaseOptions(
      apiKey: "AIzaSyCqCZ4hj54UALwigomO-6LKJ4kS8ZxNuAg",
      authDomain: "three-little-things.firebaseapp.com",
      projectId: "three-little-things",
      storageBucket: "three-little-things.appspot.com",
      messagingSenderId: "312349347082",
      appId: "1:312349347082:web:32f6eb7768dc2528ba7ef3",
      measurementId: "G-W5FHGWVEC5"
    ));
    
    /*
    var googleUser = await GoogleSignIn().signIn();
    var googleAuth = await googleUser?.authentication;
    var credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken
    );    
    var userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    */
    
    var thoughtCollection = FirebaseFirestore.instance.collection("thoughts");
    
    return FirebaseData(thoughtCollection, "test");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getData(),
        builder: (context, data) {
          if (data.hasError) {
            return Stack();
          }

          if (data.connectionState == ConnectionState.done) {
            return const AppLayout();
          }

          return const Loading();
        });
  }
}

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: const [CircularProgressIndicator()],
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
  Page _selectedPage = Page.analytics;

  void _onItemTapped(int index) {
    setState(() {
      _selectedPage = Page.values[index];
    });
  }

  Widget getPage() {
    if (_selectedPage == Page.analytics) {
      return const AnalyticsPage();
    } else {
      return Positioned.fill(child: Stack());
    }
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
          child: Stack(children: [getPage()])),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: SizedBox(
                  child: Image(image: AssetImage('assets/analytics.png')),
                  width: 100,
                  height: 100),
              label: "",
              activeIcon: SizedBox(
                  child:
                      Image(image: AssetImage('assets/analytics_selected.png')),
                  width: 100,
                  height: 100)),
          BottomNavigationBarItem(
              icon: SizedBox(
                  child: Image(image: AssetImage('assets/add.png')),
                  width: 100,
                  height: 100),
              label: "",
              activeIcon: SizedBox(
                  child: Image(image: AssetImage('assets/add_selected.png')),
                  width: 100,
                  height: 100)),
          BottomNavigationBarItem(
              icon: SizedBox(
                  child: Image(image: AssetImage('assets/community.png')),
                  width: 100,
                  height: 100),
              label: "",
              activeIcon: SizedBox(
                  child:
                      Image(image: AssetImage('assets/community_selected.png')),
                  width: 100,
                  height: 100)),
          BottomNavigationBarItem(
              icon: SizedBox(
                  child: Image(image: AssetImage('assets/settings.png')),
                  width: 100,
                  height: 100),
              label: "",
              activeIcon: SizedBox(
                  child:
                      Image(image: AssetImage('assets/settings_selected.png')),
                  width: 100,
                  height: 100)),
        ],
        currentIndex: _selectedPage.index,
        onTap: _onItemTapped,
        iconSize: 6,
      ),
    );
  }
}

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AnalyticsPage();
}

enum ChartDisplayDuration { week, month, year, life }

class _AnalyticsPage extends State<AnalyticsPage> {
  ChartDisplayDuration _displayTime = ChartDisplayDuration.week;

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
                  value: _displayTime.name,
                  style: const TextStyle(fontSize: 24, color: Colors.black),
                  items: ChartDisplayDuration.values
                      .map((e) => e.name)
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (Object? val) {
                    setState(() {
                      switch (val) {
                        case "week":
                          _displayTime = ChartDisplayDuration.week;
                          break;
                        case "month":
                          _displayTime = ChartDisplayDuration.month;
                          break;
                        case "year":
                          _displayTime = ChartDisplayDuration.year;
                          break;
                        case "life":
                          _displayTime = ChartDisplayDuration.life;
                          break;
                      }
                    });
                  })
            ])));
  }
}

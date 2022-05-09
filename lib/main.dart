import 'package:bluetooth/bluetooth.dart';
import 'package:bluetooth/irRemote.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(
                text: 'IR REMOTE',
              ),
              Tab(
                text: 'BLUETOOTH',
              ),
            ],
          ),
          title: Text('INTERNET OF THINGS  '),
          backgroundColor: Colors.deepPurple,
        ),
        body: TabBarView(
          children: [
            Remote(),
            BluetoothApp()
          ],
        ),
      ),
    );
  }
}

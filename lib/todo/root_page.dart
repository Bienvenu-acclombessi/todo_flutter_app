
import 'package:blog/screens/taches.dart';
import 'package:blog/todo/pages/dashbord.dart';
import 'package:blog/todo/pages/my_tache.dart';
import 'package:blog/todo/pages/taches_sqlites.dart';
import 'package:flutter/material.dart';

import 'home/home.dart';
List itemsTab = [
  {"icon": Icons.home, "size": 28.0},
  {"icon": Icons.task, "size": 22.0},
  {"icon": Icons.list_alt_sharp, "size": 22.0},
];
class RootApp extends StatefulWidget {
  const RootApp({super.key});

  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  int activeTab = 0;
   int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static  List<Widget> _widgetOptions = <Widget>[
      DashboardPage(),
      MyTachesPage(),
      MyTachesPageSqlite()

  ];
 
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: getFooter(),
      body: _widgetOptions.elementAt(_selectedIndex)
    );
  }



  Widget getFooter() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.2)))),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
              itemsTab.length,
              (index) => IconButton(
                  onPressed: () {
                    setState(() {
                     _selectedIndex=index;
                    });
                  },
                  icon: Icon(
                    itemsTab[index]['icon'],
                    size: itemsTab[index]['size'],
                    color:  _selectedIndex == index ? Colors.blue : Colors.black,
                  ))),
        ),
      ),
    );
  }
}

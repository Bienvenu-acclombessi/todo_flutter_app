
import 'package:blog/data/models/tache.dart';
import 'package:blog/data/services/tache_service.dart';
import 'package:blog/todo/pages/widgets/nombre_card.dart';
import 'package:blog/todo/pages/widgets/tache_card.dart';
import 'package:blog/todo/pages/widgets/task_card_sqlite.dart';
import 'package:blog/todo/services/db_service.dart';
import 'package:blog/todo/services/tachesqlite.dart';
import 'package:blog/utils/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:blog/data/services/users_service.dart';
import 'package:blog/screens/login_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/theme_helper.dart';
import 'login_page.dart';
import 'new_tache.dart';
import 'widgets/header_widget.dart';

import 'profile_page.dart';

class MyTachesPageSqlite extends  StatefulWidget{
  @override
  State<StatefulWidget> createState() {
     return _MyTachesPageSqliteState();
  }
}

class _MyTachesPageSqliteState extends State<MyTachesPageSqlite>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: Text(
          "Mes tâches",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                Theme.of(context).primaryColor,
                Theme.of(context).accentColor,
              ])),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(child:FutureBuilder(
                          future: DatabaseHelper.instance.fetch(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.data == null || snapshot.data.length==0) {
                              return Container(
                                child: Text('Aucune tache'),
                              );
                            } else {
                              return ListView.builder(
                                  itemCount: snapshot.data.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                        final TacheSqlite tache=snapshot.data[index];
                                    return TaskCard(tache: tache,) ;
                                  });
                            }
                          },
                        ), 
      
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => NouvelleTachePage()));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add_task),
      ),
    );
  }

}
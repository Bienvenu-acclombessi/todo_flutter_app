
import 'package:blog/data/models/tache.dart';
import 'package:blog/data/services/tache_service.dart';
import 'package:blog/todo/pages/widgets/nombre_card.dart';
import 'package:blog/todo/pages/widgets/tache_card.dart';
import 'package:blog/todo/pages/widgets/task_card.dart';
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

class MyTachesPage extends  StatefulWidget{
  @override
  State<StatefulWidget> createState() {
     return _MyTachesPageState();
  }
}

class _MyTachesPageState extends State<MyTachesPage>{
List<Tache> taches = [];
  bool isLoadingTaches = false;

  loadTache () async {
    setState(() {
      isLoadingTaches = true;
    });
    try {
      taches =await TacheService.fetch();
    } on DioError catch(e) {
      print(e);
      Map<String, dynamic> error = e.response?.data;
      if (error != null && error.containsKey('message')) {
        Fluttertoast.showToast(msg: error['message']);
      } else {
        Fluttertoast.showToast(msg: "Une erreur est survenue veuillez rééssayer");
      }
    } finally {
      isLoadingTaches = false;
      setState(() {});
    }
  }

    _finishTache(id) async {
    
    try {
      var result = await TacheService.finishedAt(id);
      Fluttertoast.showToast(msg: "Tache finie avec succès");
    } on DioError catch (e) {
      Map<String, dynamic> error = e.response?.data;
      if (error != null && error.containsKey('message')) {
        Fluttertoast.showToast(msg: error['message']);
      } else {
        Fluttertoast.showToast(msg: "Une erreur est survenue veuillez rééssayer");
      }
      print(e.response);
    } finally {
      setState(() {
      loadTache();
      });
    }
   }
 _beginTache(id) async {
    
    try {
      var result = await TacheService.beginAt(id);
      Fluttertoast.showToast(msg: "Tache commencée avec succès");
    } on DioError catch (e) {
      Map<String, dynamic> error = e.response?.data;
      if (error != null && error.containsKey('message')) {
        Fluttertoast.showToast(msg: error['message']);
      } else {
        Fluttertoast.showToast(msg: "Une erreur est survenue veuillez rééssayer");
      }
      print(e.response);
    } finally {
      setState(() {
      loadTache();
      });
    }
}
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadTache();
  }

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
      body: isLoadingTaches ? Center(
        child: SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator()
        ),
      ) : taches.length > 0 ? Container(
        
              margin: EdgeInsets.fromLTRB(10, 50, 10, 10),
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: ListView.builder(
          itemCount: taches.length,
          itemBuilder: (BuildContext context, int index) {
            return TaskCard(tache: taches[index],begin: ()=>_beginTache(taches[index].id),finish: ()=>_finishTache(taches[index].id),);
          },
        ),
      ) : Center(
        child: Text("Aucunes Taches disponibles", style: TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic),),
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
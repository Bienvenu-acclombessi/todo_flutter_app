import 'package:blog/data/models/tache.dart';
import 'package:blog/data/services/tache_service.dart';
import 'package:blog/screens/create_Tache.dart';
import 'package:blog/screens/login_screen.dart';
import 'package:blog/screens/widgets/tache_widget.dart';
import 'package:blog/todo/pages/new_tache.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'detail_tache.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

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
        title: Text("Liste des Taches"),
        actions: [
          IconButton(
              onPressed: () async{
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();

                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              icon: Icon(Icons.logout)
          )
        ],
      ),
      body: isLoadingTaches ? Center(
        child: SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator()
        ),
      ) : taches.length > 0 ? ListView.builder(
        itemCount: taches.length,
        itemBuilder: (BuildContext context, int index) {
          return TacheWidget(tache: taches[index],begin: ()=>_beginTache(taches[index].id),finish: ()=>_finishTache(taches[index].id),);
        },
      ) : Center(
        child: Text("Aucunes Taches disponibles", style: TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic),),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => NouvelleTachePage()));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
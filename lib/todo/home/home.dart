import 'package:blog/data/models/tache.dart';
import 'package:blog/data/services/tache_service.dart';
import 'package:blog/todo/home/widgets/nombreWidget.dart';
import 'package:blog/todo/root_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TodoHome extends StatefulWidget {
  const TodoHome({super.key});

  @override
  State<TodoHome> createState() => _TodoHomeState();
}

class _TodoHomeState extends State<TodoHome> {
  bool isLoadingTaches=false;
  
  List<Tache> taches = [];
  List<Tache?> taches_no_start = [];
  List<Tache?> taches_en_cours = [];
  List<Tache?> taches_finie = [];
  List<Tache?> taches_finie_retard = [];
  loadTache () async {
    setState(() {
      isLoadingTaches = true;
    });
    try {
      taches =await TacheService.fetch();
      taches_no_start=await TacheService.fetchby_begined();
      taches_en_cours=await TacheService.fetchby_cours();
      taches_finie=await TacheService.fetchby_finished();
      taches_finie_retard=await TacheService.fetchby_finie_en_retard();
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
  
  @override
  void initState() {
    super.initState();
    loadTache();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body: SafeArea(child: isLoadingTaches ? Center(
        child: SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator()
        ),
      ) : SingleChildScrollView(child: Column(
        children: [
          SizedBox(height: 30,),
          Row(
            children: [
              Expanded(child: NumberWidget(nombre: taches.length, couleur: Colors.green, texte: 'Nombre de taches'))
              ,              Expanded(child: NumberWidget(nombre: taches_no_start.length, couleur: Colors.yellow, texte: 'Nombre de taches non commencé'))
          ,
            ],
          ),
          SizedBox(height: 30,),
          Row(
            children: [
              Expanded(child: NumberWidget(nombre: taches_en_cours.length, couleur: Colors.blue, texte: 'Nombre de tache en cours'))
              ,              Expanded(child: NumberWidget(nombre: taches_finie.length, couleur: Colors.blueAccent, texte: 'Nombre de tache finie'))
          ,
            ],
          ),
          Row(
            children: [
              Expanded(child: NumberWidget(nombre: taches_finie_retard.length, couleur: Colors.red, texte: 'Nombre de tache finie en retard'))
              ,              Expanded(child: SizedBox())
          ,
            ],
          )
                  ],
      ),)),
    );
  }
}




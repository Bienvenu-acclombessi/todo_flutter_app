
import 'package:blog/data/models/tache.dart';
import 'package:blog/data/services/tache_service.dart';
import 'package:blog/todo/pages/widgets/nombre_card.dart';
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
import 'widgets/header_widget.dart';

import 'profile_page.dart';

class DashboardPage extends  StatefulWidget{
  @override
  State<StatefulWidget> createState() {
     return _DashboardPageState();
  }
}

class _DashboardPageState extends State<DashboardPage>{
bool isLoadingTaches=false;
  
  List<Tache> taches = [];
  List<Tache?> taches_no_start = [];
  List<Tache?> taches_en_cours = [];
  List<Tache?> taches_finie = [];
  List<Tache?> taches_finie_retard = [];
 String username='';
  loadTache () async {
    setState(() {
      isLoadingTaches = true;
    });
    try {
      
    final prefs = await SharedPreferences.getInstance();
     username = prefs.getString(Constant.USERNAME_PREF_KEY) ?? '' ;
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
      appBar: AppBar(
        elevation: 0.5,
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
      backgroundColor: Colors.white,
      body:isLoadingTaches ? Center(
        child: SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator()
        ),
      ): SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 200,
              child: HeaderWidget(200, false, Icons.person_add_alt_1_rounded),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(25, 50, 25, 10),
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
             
              child: Column(
                children: [
        SizedBox(height: 10,),
                   Text(
          "Tableau de bord",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 20),
        ),
        
        SizedBox(height: 20,),
                  Text(
          "Salut ${username}",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400,fontSize: 16),
        ),
        SizedBox(height: 100,),
           Row(
            children: [
              Expanded(child: NumberWidget(nombre: taches.length,texte: 'Tâches',couleur: Colors.cyan,)),
             Expanded(child: NumberWidget(nombre: taches_no_start.length, texte: 'Tâches non commencée',couleur: Colors.blueAccent,)),
              
            ],
           ),
           Row(
            children: [
              Expanded(child: NumberWidget(nombre: taches_en_cours.length, couleur: Colors.orangeAccent, texte: 'Tâche en cours')),
             Expanded(child: NumberWidget(nombre: taches_finie.length, couleur: Colors.greenAccent, texte: 'Tâche finie'))
            ],
            
           ),
            Row(
            children: [
              Expanded(child: NumberWidget(nombre: taches_finie_retard.length, couleur: Colors.redAccent, texte: 'Tâche finie en retard')),
             Expanded(child: SizedBox())
            ],
            
           )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
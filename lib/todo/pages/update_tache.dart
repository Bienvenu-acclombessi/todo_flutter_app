import 'package:blog/data/models/tache.dart';
import 'package:blog/data/services/tache_service.dart';
import 'package:blog/todo/root_page.dart';
import 'package:flutter/gestures.dart';
import 'package:blog/data/services/users_service.dart';
import 'package:blog/screens/login_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:select_form_field/select_form_field.dart';
import '../common/theme_helper.dart';
import 'login_page.dart';
import 'widgets/header_widget.dart';

import 'profile_page.dart';

class ModifierTachePage extends StatefulWidget {
  final Tache tache;
  const ModifierTachePage({Key? key,required this.tache}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _ModifierTachePageState();
  }
}

class _ModifierTachePageState extends State<ModifierTachePage> {
 final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  _modifyTache(title, description) async {
    setState(() {
      isLoading = true;
    });
    try {
      var result = await TacheService.patch(widget.tache.id,{
        'title': title,
        'description': description,
      });
      Fluttertoast.showToast(msg: "Tache Modifiée avec succès");
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
        isLoading = false;
      });
    }
  }
  
@override
void initState() {
  super.initState();
  setState((){
titleController.text=widget.tache.title!;
descriptionController.text=widget.tache.description!;

  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Modifier la tache",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
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
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 80,
              child: HeaderWidget(80, false, Icons.person_add_alt_1_rounded),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(25, 50, 25, 10),
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        // Text(
                        //   "Nouvelle Tache",
                        //   style: TextStyle(
                        //       fontWeight: FontWeight.bold,
                        //       fontSize: 30,
                        //       color: Colors.white),
                        // ),
                        SizedBox(height: 60.0),

                        Container(
                          child: TextFormField(
                            controller: titleController,
                            keyboardType: TextInputType.text,
                            decoration: ThemeHelper().textInputDecoration(
                                'Titre', 'Entrer le titre de votre tache'),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Veuillez entrer un pseudo";
                              }
                              return null;
                            },
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),

                        SizedBox(height: 15.0),
                        Container(
                          child: TextFormField(
                            controller: descriptionController,
                            keyboardType: TextInputType.text,
                            minLines: 5,
                            maxLines: 7,
                            decoration: ThemeHelper().textInputDecoration(
                                "Description*", "Description de la tache"),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Description";
                              }
                              return null;
                            },
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          decoration:
                              ThemeHelper().buttonBoxDecoration(context),
                          child: ElevatedButton(
                            style: ThemeHelper().buttonStyle(),
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(40, 10, 40, 10),
                              child: isLoading
                                  ? SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 3,
                                      ))
                                  : Text(
                                      "Modifier".toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                           onPressed: () async {
                            if (!isLoading && formKey.currentState!.validate()) {
                              await _modifyTache(titleController.text, descriptionController.text);
                            }
                          },
                          ),
                        ),
                        SizedBox(height: 30.0),
                        Container(
                          margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
                          child: Text.rich(TextSpan(children: [
                            TextSpan(
                              text: 'Voir la liste des taches',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const RootApp()));
                                },
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).accentColor),
                            ),
                          ])),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

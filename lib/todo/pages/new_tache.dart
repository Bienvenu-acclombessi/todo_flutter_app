import 'package:blog/data/services/tache_service.dart';
import 'package:blog/todo/root_page.dart';
import 'package:blog/todo/services/db_service.dart';
import 'package:blog/todo/services/tachesqlite.dart';
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

import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield_new.dart';

class NouvelleTachePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NouvelleTachePageState();
  }
}

class _NouvelleTachePageState extends State<NouvelleTachePage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final priorityController = TextEditingController();
  final deadlineController = TextEditingController();

  final format = DateFormat("yyyy-MM-dd HH:mm:ss");
  final List<Map<String, dynamic>> _items = [
    {
      'value': 'low',
      'label': 'low',
      'icon': Icon(Icons.stop),
    },
    {
      'value': 'medium',
      'label': 'Medium',
      'icon': Icon(Icons.fiber_manual_record),
    }
  ];

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  _createTache(title, description, priority, deadline) async {
    setState(() {
      isLoading = true;
    });
    try {
      var result = await TacheService.create({
        'title': title,
        'description': description,
        'priority': priority,
        'deadline_at': deadline,
        'begined_at': "0000-01-01 00:00:00",
        'finished_at': "0000-01-01 00:00:00"
      });
    await  DatabaseHelper.instance.insertTache(TacheSqlite(titre:title ,description: description));
      Fluttertoast.showToast(msg: "Tachee créé avec succès");
    } on DioError catch (e) {
      Map<String, dynamic> error = e.response?.data;
      if (error != null && error.containsKey('message')) {
        Fluttertoast.showToast(msg: error['message']);
      } else {
        Fluttertoast.showToast(
            msg: "Une erreur est survenue veuillez rééssayer");
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
    // setState(() {
    //   deadlineController.text = DateTime.now().toString();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Nouvelle tache",
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
                        SizedBox(height: 20.0),

                        Container(
                          child: SelectFormField(
                            type: SelectFormFieldType.dropdown,
                            controller: priorityController,
                            icon: Icon(Icons.format_shapes),
                            labelText: 'Prorité',
                            items: _items,
                            decoration: ThemeHelper().textInputDecoration(
                                "Priorité", "Entrer votre priorité"),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Veuillez choisir une priorité";
                              }
                              return null;
                            },
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 20.0),

                        Container(
                          child: DateTimeField(
                            controller: deadlineController,
                            decoration: ThemeHelper().textInputDecoration(
                                "Delai*", "Entrer le delai de la tache"),
                            validator: (val) {
                              if (val==null) {
                                return "Veuillez entrer delai";
                              }
                              return null;
                            },
                            format: format,
                            onShowPicker: (context, currentValue) async {
                              final date = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime.now(),
                                  initialDate: currentValue ?? DateTime.now(),
                                  lastDate: DateTime(3100));
                              if (date != null) {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.fromDateTime(
                                      currentValue ?? DateTime.now()),
                                );
                                return DateTimeField.combine(date, time);
                              } else {
                                return currentValue;
                              }
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
                                      "Créer".toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                            onPressed: () async {
                              if (!isLoading &&
                                  formKey.currentState!.validate()) {
                                await _createTache(
                                    titleController.text,
                                    descriptionController.text,
                                    priorityController.text,
                                    deadlineController.text);
                                titleController.text = "";
                                descriptionController.text = "";
                                deadlineController.text = "";
                                priorityController.text = "";
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

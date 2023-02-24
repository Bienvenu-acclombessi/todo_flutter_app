import 'package:blog/data/services/tache_service.dart';
import 'package:blog/screens/taches.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CreateTacheScreen extends StatefulWidget {
  const CreateTacheScreen({Key? key}) : super(key: key);

  @override
  State<CreateTacheScreen> createState() => _CreateTacheScreenState();
}

class _CreateTacheScreenState extends State<CreateTacheScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final priorityController = TextEditingController();
  final deadlineController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  _createTache(title, description,priority,deadline) async {
    setState(() {
      isLoading = true;
    });
    try {
      var result = await TacheService.create({
        'title': title,
        'description': description,
        'priority':priority,
        'deadline_at':deadline,
        'begined_at':"0000-01-01 00:00:00",
        'finished_at':"0000-01-01 00:00:00"
      });
      Fluttertoast.showToast(msg: "Tachee créé avec succès");
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
deadlineController.text=DateTime.now().toString();
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tachee"),),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("Nouvelle Tache", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.blue),),
              Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: titleController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            hintText: "Entrez le titre du Tachee",
                            labelText: "Titre",
                        ),
                        validator: (value) {
                          return value == null || value == "" ? "Ce champs est obligatoire" : null;
                        },
                      ),
                      TextFormField(
                        controller: priorityController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            hintText: "La priorité",
                            labelText: "Priority",
                        ),
                        validator: (value) {
                          return value == null || value == "" ? "Ce champs est obligatoire" : null;
                        },
                      ),
                      TextFormField(
                        controller: deadlineController,
                        keyboardType: TextInputType.datetime,
                        decoration: const InputDecoration(
                            hintText: "Deadline at",
                            labelText: "Deadline",
                        ),
                        validator: (value) {
                          return value == null || value == "" ? "Ce champs est obligatoire" : null;
                        },
                      ),
                      SizedBox(height: 10.0,),
                      TextFormField(
                        controller: descriptionController,
                        keyboardType: TextInputType.text,
                        minLines: 5,
                        maxLines: 7,
                        decoration: const InputDecoration(
                            hintText: "Entrez la description de la Tachee",
                            labelText: "Description",
                        ),
                        validator: (value) {
                          return value == null || value == "" ? "Ce champs est obligatoire" : null;
                        },
                      ),
                      
                      SizedBox(height: 20.0,),
                      ElevatedButton(
                          onPressed: () async {
                            if (!isLoading && formKey.currentState!.validate()) {
                              await _createTache(titleController.text, descriptionController.text,priorityController.text,deadlineController.text);
                              titleController.text = "";
                              descriptionController.text = "";
                              deadlineController.text="";
                              priorityController.text="";
                            }
                          },
                          child: isLoading ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3,)) : Text("Créer")
                      )
                    ],
                  )
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                  },
                  child: Text("Voir la liste des Tachees", style: TextStyle(fontSize: 17, color: Colors.blue),),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

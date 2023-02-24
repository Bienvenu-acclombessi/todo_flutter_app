
import 'package:flutter/gestures.dart';
import 'package:blog/data/services/users_service.dart';
import 'package:blog/screens/login_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../common/theme_helper.dart';
import 'login_page.dart';
import 'widgets/header_widget.dart';

import 'profile_page.dart';

class RegistrationPage extends  StatefulWidget{
  @override
  State<StatefulWidget> createState() {
     return _RegistrationPageState();
  }
}

class _RegistrationPageState extends State<RegistrationPage>{

  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool _passwordVisible = false;

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  _register(email, username, password) async {
    setState(() {
      isLoading = true;
    });
    try {
      var result = await UserService.create({
        'username':username,
        'email':email,
        'password': password
      }); 
      Fluttertoast.showToast(msg: "Utilisateur créé avec succès");
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 250,
              child: HeaderWidget(250, false, Icons.person_add_alt_1_rounded),
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
                        GestureDetector(
                          child: Stack(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                      width: 5, color: Colors.white),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 20,
                                      offset: const Offset(5, 5),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.person,
                                  color: Colors.grey.shade300,
                                  size: 80.0,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(80, 80, 0, 0),
                                child: Icon(
                                  Icons.add_circle,
                                  color: Colors.grey.shade700,
                                  size: 25.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                      SizedBox(height: 100.0),
                        Text(
                        'TODO',
                        style: TextStyle(
                            fontSize: 60, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Créer un nouveau compte',
                        style: TextStyle(color: Colors.grey),
                      ),
                        SizedBox(height: 30,),
                        Container(
                          child: TextFormField(
                      controller: usernameController,
                      keyboardType: TextInputType.text,
                            decoration: ThemeHelper().textInputDecoration('Pseudo', 'Entrer votre pseudo'),
                          validator: (val) {
                              if (val!.isEmpty) {
                                return "Veuillez entrer un pseudo";
                              }
                              return null;
                            },),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          child: TextFormField(
                      controller: emailController,
                            decoration: ThemeHelper().textInputDecoration("Adresse email", "Entrer votre email"),
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) {
                              if((val!.isEmpty) || !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(val)){
                                return "Email invalide";
                              }
                              return null;
                            },
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          child: TextFormField(
                          controller: passwordController,
                          keyboardType: TextInputType.text,
                          obscureText: true,
                            decoration: ThemeHelper().textInputDecoration(
                                "Mot de passe*", "Entrer un mot de passe"),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Veuillez entrer un mot de passe";
                              }
                              return null;
                            },
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 15.0),
                        
                        SizedBox(height: 20.0),
                        Container(
                          decoration: ThemeHelper().buttonBoxDecoration(context),
                          child: ElevatedButton(
                            style: ThemeHelper().buttonStyle(),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                              child: isLoading ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3,)) : Text(
                                "S'inscrire".toUpperCase(),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                             onPressed: () async {
                          if (!isLoading && formKey.currentState!.validate()) {
                            await _register(emailController.text, usernameController.text, passwordController.text);
                            emailController.text = "";
                            usernameController.text = "";
                            passwordController.text = "";
                          }
                        },
                        
                          ),
                        ),
                        SizedBox(height: 30.0),
                          Container(
                              margin: EdgeInsets.fromLTRB(10,20,10,20),
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(text: "Avez vous dejà un compte? "),
                                    TextSpan(
                                      text: 'Se connecter',
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = (){
                                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
                                        },
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).accentColor),
                                    ),
                                  ]
                                )
                              ),
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
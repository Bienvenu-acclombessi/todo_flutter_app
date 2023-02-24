import 'package:blog/todo/pages/widgets/tache_card.dart';
import 'package:blog/todo/root_page.dart';
import 'package:flutter/gestures.dart';
import 'package:blog/data/models/AuthenticatedUser.dart';
import 'package:blog/data/services/users_service.dart';
import 'package:blog/todo/home/home.dart';
import 'package:blog/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common/theme_helper.dart';
import 'registration_page.dart';
import 'widgets/header_widget.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double _headerHeight = 250;
  Key _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _passwordVisible = false;

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  _login(email, password) async {
    setState(() {
      isLoading = true;
    });
    try {
      AuthenticatedUser authenticatedUser = await UserService.authentication(
          {'strategy': 'local', 'email': email, 'password': password});
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(
          Constant.USERNAME_PREF_KEY, authenticatedUser.user!.username!);
      prefs.setString(Constant.EMAIL_PREF_KEY, authenticatedUser.user!.email!);
      prefs.setString(Constant.USER_ID_PREF_KEY, authenticatedUser.user!.id!);
      prefs.setString(Constant.TOKEN_PREF_KEY, authenticatedUser.accessToken!);
      emailController.text = "";
      passwordController.text = "";
      Fluttertoast.showToast(msg: "Connexion effectuée avec succès");

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => RootApp()));
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: _headerHeight,
              child: HeaderWidget(_headerHeight, true,
                  Icons.login_rounded), //let's create a common header widget
            ),
            SafeArea(
              child: Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  margin: EdgeInsets.fromLTRB(
                      20, 10, 20, 10), // This will be the login form
                  child: Column(
                    children: [
                      Text(
                        'TODO',
                        style: TextStyle(
                            fontSize: 60, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Se connecter à son compte',
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 30.0),
                      Form(
                          key: formKey,
                          child: Column(
                            children: [
                              Container(
                                child: TextFormField(
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: ThemeHelper().textInputDecoration(
                                      'Email', 'Entrer votre email '),
                                      validator: (val) {
                              if((val!.isEmpty) || !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(val)){
                                return "Email invalide";
                              }
                              return null;
                            },
                                ),
                                decoration:
                                    ThemeHelper().inputBoxDecorationShaddow(),
                              ),
                              SizedBox(height: 30.0),
                              Container(
                                child: TextFormField(
                                  controller: passwordController,
                                  keyboardType: TextInputType.text,
                                  obscureText: !_passwordVisible,
                                  decoration: ThemeHelper().textInputDecoration(
                                      'Mot de passe',
                                      'Entrer votre mot de passe'),
                                      validator: (val) {
                              if (val!.isEmpty) {
                                return "Veuillez entrer un mot de passe";
                              }
                              return null;
                            },
                                ),
                                decoration:
                                    ThemeHelper().inputBoxDecorationShaddow(),
                              ),

                              SizedBox(height: 15.0),
                              Container(
                                decoration:
                                    ThemeHelper().buttonBoxDecoration(context),
                                child: ElevatedButton(
                                  style: ThemeHelper().buttonStyle(),
                                  child: Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(40, 10, 40, 10),
                                    child: isLoading
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 3,
                                            ))
                                        : Text(
                                            'Se connecter'.toUpperCase(),
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                  ),
                                  onPressed: () async {
                                    if (!isLoading &&
                                        formKey.currentState!.validate()) {
                                      await _login(emailController.text,
                                          passwordController.text);
                                    }
                                  },
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
                                child: Text.rich(TextSpan(children: [
                                  TextSpan(
                                      text: "N\'avez vous pas un compte? "),
                                  TextSpan(
                                    text: 'Crée',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    RegistrationPage()));
                                      },
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).accentColor),
                                  ),
                                ])),
                              )
                            ],
                          )),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

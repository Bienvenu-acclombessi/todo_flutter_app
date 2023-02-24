import 'package:blog/todo/common/theme_helper.dart';
import 'package:flutter/material.dart';

class NumberWidget extends StatelessWidget {
  final int nombre;
  final String texte;
  final Color couleur;
  const NumberWidget({super.key,required this.nombre,required this.couleur,required this.texte});

  @override
  Widget build(BuildContext context) {
    return Container(
    height: 150,
    margin: EdgeInsets.all(5),
    decoration: ThemeHelper().BoxDecorationShaddow(),
    child: Container(
      decoration: BoxDecoration(
        color: couleur,
      borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          SizedBox(height: 40,),
          Text("${nombre}",style: TextStyle(color:Colors.white ,fontSize: 30,fontWeight: FontWeight.bold),),
          SizedBox(height: 10,),
          Text(texte,textAlign: TextAlign.center,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color:Colors.white),),
        ],
      ),
    ),
    );
  }
}
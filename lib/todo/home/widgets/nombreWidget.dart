import 'package:flutter/material.dart';

class NumberWidget extends StatelessWidget {
  final int nombre;
  final String texte;
  final Color couleur;
  const NumberWidget({super.key,required this.nombre,required this.couleur,required this.texte});

  @override
  Widget build(BuildContext context) {
    return Container(
    height: 200,
    
    
    child: Card(
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
        color: couleur,
      ),
        child: Column(
          children: [
            Text(texte,textAlign: TextAlign.center,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color:Colors.white),),
            SizedBox(height: 40,),
             Text("${nombre}",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),)
          ],
        ),
      ),
    ),
    );
  }
}
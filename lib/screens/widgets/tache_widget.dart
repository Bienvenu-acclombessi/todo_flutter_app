
import 'package:blog/data/models/tache.dart';
import 'package:blog/screens/detail_tache.dart';
import 'package:blog/screens/update_tache.dart';
import 'package:flutter/material.dart';

class TacheWidget extends StatefulWidget {
  Tache tache;
  Future<dynamic> Function()  begin;
  Future<dynamic> Function() finish;
 TacheWidget({super.key,required this.tache,required this.begin,required this.finish});

  @override
  State<TacheWidget> createState() => _TacheWidgetState();
}

class _TacheWidgetState extends State<TacheWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 100),
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${widget.tache.title}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              Text("${ widget.tache.description} ...",style: TextStyle(fontSize: 15),),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
              widget.tache.begined_at==null ? ElevatedButton(onPressed: widget.begin , child:  Icon(Icons.play_arrow))
                :  widget.tache.finished_at==null ?   ElevatedButton(onPressed: widget.finish, child: Icon(Icons.stop)) : SizedBox(),
                   ElevatedButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailTacheScreen(tache: widget.tache)));
                  }, child: Icon(Icons.remove_red_eye)),
                   ElevatedButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ModifyTacheScreen(tache: widget.tache)));
                  }, child: Icon(Icons.update))
                ],
              )
          ]),
        ),
      ),
    );
  }
}
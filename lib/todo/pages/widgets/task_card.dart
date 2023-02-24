import 'package:blog/data/models/tache.dart';
import '../detail_tache.dart';
import 'package:blog/todo/common/theme_helper.dart';
import 'package:blog/todo/pages/update_tache.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
class TaskCard extends StatefulWidget {
  Tache tache;
  Future<dynamic> Function()  begin;
  Future<dynamic> Function() finish;
 TaskCard({super.key,required this.tache,required this.begin,required this.finish});


  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: ThemeHelper().BoxDecorationShaddow(),
      child: Container(
        constraints: BoxConstraints(
          minHeight: 100
        ),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),
        color:Colors.blue,
        
        ),
        child: Row(
          children: [
            Expanded(
                child: Container(
                  child: Text(formattingDate(DateTime.parse("${widget.tache.deadline_at}") ),textAlign: TextAlign.center,style: TextStyle(fontSize: 20,color:Colors.white), ),
            )),
            Expanded(
              flex: 3,
                child: Container(
                  constraints: BoxConstraints(
          minHeight: 100
        ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${widget.tache.title}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                        SizedBox(height: 10,),
                        Text('${subDescription(widget.tache.description!)}',style: TextStyle(fontSize: 15,fontStyle: FontStyle.italic),),
                        SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                                 widget.tache.begined_at==null ? ElevatedButton(style: ThemeHelper().tacheButtonStyle(Colors.green),  onPressed: widget.begin , child:  Icon(Icons.play_arrow))
                :  widget.tache.finished_at==null ?   ElevatedButton(style: ThemeHelper().tacheButtonStyle(Colors.red),  onPressed: widget.finish, child: Icon(Icons.stop)) : SizedBox(),
                   ElevatedButton(style: ThemeHelper().tacheButtonStyle(Colors.blue), onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailTacheScreen(tache: widget.tache)));
                  }, child: Icon(Icons.remove_red_eye)),
                   ElevatedButton(style: ThemeHelper().tacheButtonStyle(Colors.yellow), onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ModifierTachePage(tache: widget.tache)));
                  }, child: Icon(Icons.update)),
                              

                          ],
                        )
                     
                      ],
                    ),
                  ),
            )),
          ],
        ),
      ),
    );
  }
  String formattingDate(date) {
    initializeDateFormatting('fr', null);
    DateTime? dateTime = date;
    DateFormat dateFormat = DateFormat.yMMMd('fr');
    return dateFormat.format(dateTime ?? DateTime.now());
  }

  String formattingDateMessage(date) {
    initializeDateFormatting('fr', null);
    DateTime? dateTime = date;
    DateFormat dateFormat = DateFormat.Hm('fr');
    return dateFormat.format(dateTime ?? DateTime.now());
  }
String  subDescription(String desc){
  if(desc.length>50){
    return desc.substring(0,50);
  }else{
    return desc;
  }
}
}

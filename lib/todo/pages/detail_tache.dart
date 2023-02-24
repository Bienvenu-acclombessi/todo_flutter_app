import 'package:blog/data/models/comment.dart';
import 'package:blog/data/models/tache.dart';
import 'package:blog/data/services/comments_service.dart';
import 'package:blog/todo/common/theme_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class DetailTacheScreen extends StatefulWidget {
  const DetailTacheScreen({Key? key, required this.tache}) : super(key: key);

  final Tache tache;

  @override
  State<DetailTacheScreen> createState() => _DetailTacheScreenState();
}

class _DetailTacheScreenState extends State<DetailTacheScreen> {
  final contentController = TextEditingController();

  List<Comment> _comments = [];

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail de la tâche'),
      ),
      body: SafeArea(
          child: ListView(
        children: [
          SizedBox(height: 50,),
          Container(
            decoration: ThemeHelper().BoxDecorationShaddow(),
            child: Container(
              color: Colors.white,
              child: ListTile(
                title: Text(
                  'Titre',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(widget.tache.title!),
              ),
            ),
          ),
          SizedBox(height: 20,),
          Container(
            decoration: ThemeHelper().BoxDecorationShaddow(),
            child: Container(
              color: Colors.white,
              child: ListTile(
                title: Text(
                  'Description',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(widget.tache.description!),
              ),
            ),
          ),
          SizedBox(height: 20,),
          Container(
            decoration: ThemeHelper().BoxDecorationShaddow(),
            child: Container(
              color: Colors.white,
              child: ListTile(
                title: Text(
                  'priority',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(widget.tache.priority!),
              ),
            ),
          ),
          SizedBox(height: 20,),
          Container(
            decoration: ThemeHelper().BoxDecorationShaddow(),
            child: Container(
              color: Colors.white,
              child: ListTile(
                title: Text(
                  'Deadline',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(widget.tache.deadline_at!),
              ),
            ),
          ),
          SizedBox(height: 20,),
          widget.tache.begined_at != null
              ? Container(
                  decoration: ThemeHelper().BoxDecorationShaddow(),
                  child: Container(
                    color: Colors.white,
                    child: ListTile(
                      title: Text(
                        'Commencée le',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(widget.tache.begined_at!),
                    ),
                  ),
                )
              : SizedBox(
                  child: Text(
                    'Pas encore commencé',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
          SizedBox(height: 20,),
          widget.tache.finished_at != null
              ? Container(
                  decoration: ThemeHelper().BoxDecorationShaddow(),
                  child: Container(
                    color: Colors.white,
                    child: ListTile(
                      title: Text('Finie le',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                      subtitle: Text(widget.tache.finished_at!),
                    ),
                  ),
                )
              : SizedBox(),
          SizedBox(height: 20,),
        ],
      )),
    );
  }
   String formattingDate(date) {
    initializeDateFormatting('fr', null);
    DateTime? dateTime = date;
    DateFormat dateFormat = DateFormat.yMMMd('fr');
    return dateFormat.format(dateTime ?? DateTime.now());
  }
}

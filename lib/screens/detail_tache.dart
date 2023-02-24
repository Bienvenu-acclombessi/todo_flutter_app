import 'package:blog/data/models/comment.dart';
import 'package:blog/data/models/tache.dart';
import 'package:blog/data/services/comments_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
        title: Text(widget.tache.title!),
      ),
      body: SafeArea(child: ListView(
        children: [
          ListTile(
            title: Text('Titre'),
            subtitle: Text(widget.tache.title!) ,
          ),
          
          ListTile(
            title: Text('Description'),
            subtitle: Text(widget.tache.description!) ,
          ),
          
          ListTile(
            title: Text('priority'),
            subtitle: Text(widget.tache.priority!) ,
          ),
          
          ListTile(
            title: Text('Deadline'),
            subtitle: Text(widget.tache.deadline_at!) ,
          ),
          widget.tache.begined_at!=null ? ListTile(
            title: Text('Commencée le'),
            subtitle: Text(widget.tache.begined_at!) ,
          ) : SizedBox(child: Text('Pas encore commencé'),),
          widget.tache.finished_at!=null ? ListTile(
            title: Text('Finie le'),
            subtitle: Text(widget.tache.finished_at!) ,
          ) : SizedBox(),
        ],
      ) ),
    );
  }
}

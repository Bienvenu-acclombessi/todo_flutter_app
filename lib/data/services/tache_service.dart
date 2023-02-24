import 'package:blog/data/models/tache.dart';
import 'package:blog/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TacheService {

  static Future<Tache> create(data) async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString(Constant.TOKEN_PREF_KEY) ?? '' ;
    print(token);
    var response = await Dio().post(
        Constant.BASE_URL+'todos',
        data: data,
        options: Options(headers: {"authorization": "Bearer $token"})
    );

    return Tache.fromJson(response.data) ;
  }

  static Future<List<Tache>> fetch ({queryParameters = null}) async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString(Constant.TOKEN_PREF_KEY) ?? '' ;

    var response = await Dio().get(
        Constant.BASE_URL+'todos',
        queryParameters: queryParameters,
        options: Options(headers: {"authorization": "Bearer $token"})
    );

    return (response.data! as List).map((x) => Tache.fromJson(x))
        .toList();
  }
  
  static Future<List<Tache?>> fetchby_begined ({queryParameters = null,  gets=null}) async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString(Constant.TOKEN_PREF_KEY) ?? '' ;

    var response = await Dio().get(
        Constant.BASE_URL+'todos',
        queryParameters: queryParameters,
        options: Options(headers: {"authorization": "Bearer $token"})
    );
  final tous= (response.data! as List).map((x) => Tache.fromJson(x))
        .toList();
        final filtred=tous.where((element) => element.begined_at==gets).toList();
  return filtred;
  }

    static Future<List<Tache?>> fetchby_finished ({queryParameters = null,  gets=null}) async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString(Constant.TOKEN_PREF_KEY) ?? '' ;

    var response = await Dio().get(
        Constant.BASE_URL+'todos',
        queryParameters: queryParameters,
        options: Options(headers: {"authorization": "Bearer $token"})
    );
  final tous= (response.data! as List).map((x) => Tache.fromJson(x))
        .toList();
        final filtred=tous.where((element) => element.finished_at!=gets).toList();
  return filtred;
  }
   static Future<List<Tache?>> fetchby_cours ({queryParameters = null}) async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString(Constant.TOKEN_PREF_KEY) ?? '' ;

    var response = await Dio().get(
        Constant.BASE_URL+'todos',
        queryParameters: queryParameters,
        options: Options(headers: {"authorization": "Bearer $token"})
    );
  final tous= (response.data! as List).map((x) => Tache.fromJson(x))
        .toList();
        final filtred=tous.where((element) => element.finished_at==null && element.begined_at!=null).toList();
  return filtred;
  }
   static Future<List<Tache?>> fetchby_finie_en_retard({queryParameters = null}) async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString(Constant.TOKEN_PREF_KEY) ?? '' ;

    var response = await Dio().get(
        Constant.BASE_URL+'todos',
        queryParameters: queryParameters,
        options: Options(headers: {"authorization": "Bearer $token"})
    );
  final tous= (response.data! as List).map((x) => Tache.fromJson(x))
        .toList();
        final filtred=tous.where((element){
          if(element.finished_at!=null){
            return   DateTime.parse(element.finished_at!).compareTo(DateTime.parse(element.deadline_at!))==1;
      
          }else{
  return false;
          }
           } ).toList();
  return filtred;
  }

  static Future<Tache> get (id, {queryParameters = null}) async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString(Constant.TOKEN_PREF_KEY) ?? '' ;

    var response = await Dio().get(
        Constant.BASE_URL+'todos/'+id,
        queryParameters: queryParameters,
        options: Options(headers: {"authorization": "Bearer $token"})
    );

    return Tache.fromJson(response.data);
  }

  static Future<Tache> patch (id, data) async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString(Constant.TOKEN_PREF_KEY) ?? '' ;

    var response = await Dio().patch(
        Constant.BASE_URL+'todos/'+id,
        data: data,
        options: Options(headers: {"authorization": "Bearer $token"})
    );

    return Tache.fromJson(response.data) ;
  }
    static Future<Tache> beginAt(id) async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString(Constant.TOKEN_PREF_KEY) ?? '' ;

    var response = await Dio().patch(
        Constant.BASE_URL+'todos/'+id,
        data: {
          "begined_at": DateTime.now().toString()
        },
        options: Options(headers: {"authorization": "Bearer $token"})
    );

    return Tache.fromJson(response.data) ;
  }
    static Future<Tache> finishedAt(id) async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString(Constant.TOKEN_PREF_KEY) ?? '' ;

    var response = await Dio().patch(
        Constant.BASE_URL+'todos/'+id,
        data:{
           "finished_at": DateTime.now().toString()
        },
        options: Options(headers: {"authorization": "Bearer $token"})
    );

    return Tache.fromJson(response.data) ;
  }

  static Future<Tache> delete (id, data) async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString(Constant.TOKEN_PREF_KEY) ?? '' ;

    var response = await Dio().delete(
        '${Constant.BASE_URL}todos/'+id,
        options: Options(headers: {"authorization": "Bearer $token"})
    );

    return Tache.fromJson(response.data) ;
  }

}
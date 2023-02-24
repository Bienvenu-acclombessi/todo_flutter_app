// To parse this JSON data, do
//
//     final Tache = TacheFromJson(jsonString);

import 'dart:convert';

List<Tache> TacheFromJson(String str) => List<Tache>.from(json.decode(str).map((x) => Tache.fromJson(x)));

class Tache {
  Tache({
    this.id,
    this.description,
    this.title,
    this.begined_at,
    this.deadline_at,
    this.finished_at,
    this.priority,
    this.user_id,
    this.created_at,
    this.updated_at
  });

  String? id;
  String? description;
  String? title;
  String? begined_at;
  String? finished_at;
  String? deadline_at;
  String? priority;
  String? user_id;
  DateTime? created_at;
  DateTime? updated_at;

  factory Tache.fromJson(Map<String, dynamic> json) => Tache(
    id: json["id"] == null ? null : json["id"],
    description: json["description"] == null ? null : json["description"],
    title: json["title"] == null ? null : json["title"],
    user_id: json["user_id"] == null ? null : json["user_id"],
    created_at: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updated_at: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    begined_at: json["begined_at"] == null ? null : json["begined_at"],
    finished_at: json["finished_at"] == null ? null : json["finished_at"], 
    priority: json["priority"] == null ? null : json["priority"], 
    deadline_at: json["deadline_at"] == null ? null : json["deadline_at"],
          );
}

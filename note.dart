

import 'package:flutter/material.dart';
import 'package:todo_app/colors/color.dart';

class Note{
  int ? id;
  String title;
  String description;
  bool status ;

  Note({
    this.id, required this.title , required this.description, required this.status
});

  factory Note.fromMap(Map<String,dynamic> json){
    return Note(
    id : json['id'],
    title : json['title'],
    description : json['description'],
        status: json['status'] == 1 ? true : false,

    );
  }

  Map<String,dynamic> toMap(){
    return {'id': id, 'title':title, 'description': description, 'status': status ? 1:0};
  }

  @override
  String toString() {
    return 'Note{id: $id, title: $title, description: $description, status: $status}';
  }
}
import 'dart:convert';

class CommentEntity {
  final int id;
  final String title;
  final String contect;
  final String date;
  final String email;

  CommentEntity.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      title = json['title'],
      contect = json['content'],
      date = json['date'],
      email = json['author']['email'];
}

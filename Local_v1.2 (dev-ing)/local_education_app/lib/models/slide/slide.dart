import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Slide {
  String id;
  String lessonId;
  String title;
  String content;
  // FIXME: Use Enum instead
  String layout;
  int index;
  String thumbnailPath;
  String urlPath;
  bool isPublished;
  Slide({
    required this.id,
    required this.lessonId,
    required this.title,
    required this.content,
    required this.layout,
    required this.index,
    required this.thumbnailPath,
    required this.urlPath,
    required this.isPublished,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'lessonId': lessonId,
      'title': title,
      'content': content,
      'layout': layout,
      'index': index,
      'thumbnailPath': thumbnailPath,
      'urlPath': urlPath,
      'isPublished': isPublished,
    };
  }

  factory Slide.fromMap(Map<String, dynamic> map) {
    return Slide(
      id: map['id'] as String,
      lessonId: map['lessonId'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      layout: map['layout'] as String,
      index: map['index'] as int,
      thumbnailPath: map['thumbnailPath'] as String,
      urlPath: map['urlPath'] as String,
      isPublished: map['isPublished'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Slide.fromJson(String source) =>
      Slide.fromMap(json.decode(source) as Map<String, dynamic>);
}

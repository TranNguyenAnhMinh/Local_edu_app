class Lesson {
  String id;
  String courseId;
  String title;
  String thumbnailPath;
  int index;
  bool isVr;
  String tourSlug;
  int totalSlide;
  bool isPublished;
  String description;
  Lesson({
    required this.id,
    required this.courseId,
    required this.title,
    required this.thumbnailPath,
    required this.index,
    required this.isVr,
    required this.tourSlug,
    required this.totalSlide,
    required this.isPublished,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'courseId' : courseId,
      'title': title,
      'thumbnailPath': thumbnailPath,
      'index': index,
      'isVr': isVr,
      'tourSlug': tourSlug,
      'totalSlide': totalSlide,
      'isPublished': isPublished,
      'description': description,
    };
  }

  factory Lesson.fromMap(Map<String, dynamic> map) {
    return Lesson(
      id: map['id'] as String,
      courseId: map['courseId'] as String,
      title: map['title'] as String,
      thumbnailPath: map['thumbnailPath'] as String,
      index: map['index'] as int,
      isVr: map['isVr'] as bool,
      tourSlug: map['tourSlug'] as String,
      totalSlide: map['totalSlide'] as int,
      isPublished: map['isPublished'] as bool,
      description: map['description'] as String,
    );
  }

  // String toJson() => json.encode(toMap());

  // factory Lesson.fromJson(String source) =>
  //     Lesson.fromMap(json.decode(source) as Map<String, dynamic>);
}

import 'package:flutter/material.dart';
import 'package:local_education_app/api/slide_api.dart';
import 'package:local_education_app/models/slide/slide.dart';

class SlideProivder with ChangeNotifier {
  List<Slide>? _slideList;
  void setSlideList(List<Slide> list) {
    _slideList = list;
    notifyListeners();
  }

  List<Slide>? get slideList => _slideList;

  Future<int> slideGetList(String lessonId) async {
    try {
      final response = await getSlidesByLesson(lessonId);
      if (response['statusCode'] == 200) {
        final result = response['result'];
        _slideList = result?.map<Slide>((e) {
              return Slide.fromMap(e);
            }).toList() ??
            [];
        notifyListeners();
        return 200;
      } else {
        return 300;
      }
    } catch (e, stack) {
      debugPrint("There is error while getting Slides: $e");
      debugPrintStack(stackTrace: stack);
      return 400;
    }
  }
}

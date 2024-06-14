import 'package:flutter/material.dart';
import 'package:local_education_app/config/routes/router.dart';
import 'package:local_education_app/config/routes/routes.dart';
import 'package:local_education_app/constants/api_constant.dart';
import 'package:local_education_app/models/lesson/lesson.dart';
import 'package:local_education_app/provider/lesson_provider.dart';
import 'package:provider/provider.dart';

class LessonScreen extends StatefulWidget {
  const LessonScreen({super.key, required this.courseSlug});
  final String courseSlug;

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  bool _showLoadingIndicator = true;
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() {
    final lessonProv = Provider.of<LessonProvider>(context, listen: false);
    lessonProv.lessonGetList(widget.courseSlug).then((_) {
      if (lessonProv.lessonList == null || lessonProv.lessonList!.isEmpty) {
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            setState(() {
              _showLoadingIndicator = false;
            });
          }
        });
      } else {
        if (mounted) {
          setState(() {
            _showLoadingIndicator = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final lessonProv = Provider.of<LessonProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lessons"),
      ),
      body: _showLoadingIndicator
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : (lessonProv.lessonList == null || lessonProv.lessonList!.isEmpty)
              ? const Center(
                  child: Text("Không tìm thấy bài học nào"),
                )
              : ListView.builder(
                  itemCount: lessonProv.lessonList!.length,
                  itemBuilder: (context, index) {
                    final Lesson lesson = lessonProv.lessonList![index];
                    const domain = ApiEndpoint.domain;
                    return Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(16.0),
                      decoration: const BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            RouteName.slideScreen,
                            arguments: SlideArgument(lessonId: lesson.id),
                          );
                        },
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                      "$domain/${lesson.thumbnailPath}"),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Text(lesson.title),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

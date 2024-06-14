import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_education_app/constants/api_constant.dart';
import 'package:local_education_app/models/lesson/lesson.dart';
import 'package:local_education_app/models/slide/slide.dart';
import 'package:local_education_app/provider/lesson_provider.dart';
import 'package:local_education_app/provider/slide_provider.dart';
import 'package:local_education_app/screens/exam/pages/quiz_details.dart';
import 'package:provider/provider.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:local_education_app/screens/exam/models/category.dart';
import 'package:local_education_app/screens/exam/models/question.dart';
import 'package:local_education_app/screens/exam/pages/quiz_details.dart';
import 'package:local_education_app/screens/exam/services/load_data.dart';

class SlideScreen extends StatefulWidget {
  const SlideScreen({Key? key, required this.lessonId}) : super(key: key);
  final String lessonId;

  @override
  State<SlideScreen> createState() => _SlideScreenState();
}

class _SlideScreenState extends State<SlideScreen> {
  late ChewieController _chewieController;
  PageController _pageController = PageController(initialPage: 0);
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  bool _showLoadingIndicator = true;

  _loadData() {
    final slideProv = Provider.of<SlideProivder>(context, listen: false);
    final lessonProv = Provider.of<LessonProvider>(context,listen:false);
    
    slideProv.slideGetList(widget.lessonId).then((_) {
      if (slideProv.slideList == null || slideProv.slideList!.isEmpty) {
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    final slideProv = Provider.of<SlideProivder>(context);
    const domain = ApiEndpoint.domain;
    late Slide currentSlide;
    return Scaffold(
              backgroundColor: Color.fromARGB(255, 13, 33, 8), // Set the background color here
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 13, 33, 8), 
        leading: IconButton(
          onPressed: () {
            SystemChrome.setPreferredOrientations(
              [
                DeviceOrientation.portraitDown,
                DeviceOrientation.portraitUp,
              ],
            );
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      endDrawer: (slideProv.slideList == null || slideProv.slideList!.isEmpty)
        ? const Drawer(
              child: Text('Getting slide list'),
            )
          : Drawer(
              child: Stack(
                children: [
                   ListView.builder(
                itemCount: slideProv.slideList!.length,
                itemBuilder: (context, index) {
                  currentSlide = slideProv.slideList![index];
                  return ListTile(
                    onTap: () {
                      _pageController.jumpToPage(index);
                      Navigator.pop(context);
                    },
                    title: Text(currentSlide.title),
                  );
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(onPressed: (){
                  final category = categories[0];
                 loadQuestionThenNavigate(category);
                }, child: Text("Kiểm tra")),
              )
                ],
              )
            ),
      body: _showLoadingIndicator
        ? const Center(
              child: CircularProgressIndicator(),
            )
          : (slideProv.slideList == null || slideProv.slideList!.isEmpty)
            ? const Center(
                  child: Text("Không tìm thấy slide nào"),
                )
              : Column(
                  children: [
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: slideProv.slideList!.length,
                        onPageChanged: (int index) {
                          setState(() {
                            currentIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          final currentSlide = slideProv.slideList![index];
                          if (currentSlide.layout == 'text') {
                            return Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(32.0),
                                    child: SingleChildScrollView(
                                      child: HtmlWidget(currentSlide.content),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else if (currentSlide.layout =='media') {
                            if ((currentSlide.urlPath)
                                  .toString()
                                  .split('.')
                                  .last ==
                                "png") {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image(
                                  image: NetworkImage(
                                    "$domain/${currentSlide.urlPath}",
                                  ),
                                ),
                              );
                            } else {
                              VideoPlayerController videoPlayerController =
                                  VideoPlayerController.network(
                                "$domain/${currentSlide.urlPath}",
                              );
                              ChewieController chewieController =
                                  ChewieController(
                                videoPlayerController: videoPlayerController,
                              
                                looping: false,
                                aspectRatio: 16 / 9,
                                autoInitialize: true,
                              );
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Chewie(
                                  controller: chewieController,
                                ),
                              );
                            }
                          } else if (currentSlide.layout == 'full') {
                            if ((currentSlide.urlPath)
                                  .toString()
                                  .split('.')
                                  .last ==
                                "png") {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Expanded(
                                      child: SingleChildScrollView(
                                        child: HtmlWidget(
                                              currentSlide.content,
                                              textStyle: const TextStyle(
                                                color: Color(
                                                    0xFFFFEBCD), // Màu chữ
                                              ),
                                            ),
                                      ),
                                    ),
                                    SizedBox(width: 8), // Khoảng cách giữa hình ảnh và nội dung
                                    Image(
                                      image: NetworkImage(
                                        "$domain/${currentSlide.urlPath}",
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              VideoPlayerController videoPlayerController =
                                  VideoPlayerController.network(
                                "$domain/${currentSlide.urlPath}",
                              );
                              ChewieController chewieController =
                                  ChewieController(
                                videoPlayerController: videoPlayerController,
                         
                                looping: false,
                                aspectRatio: 16 / 9,
                                autoInitialize: true,
                              );
                              return Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Chewie(
                                        controller: chewieController,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(32.0),
                                      child: SingleChildScrollView(
                                        child: HtmlWidget(
                                              currentSlide.content,
                                              textStyle: const TextStyle(
                                                color: Color(
                                                    0xFFFFEBCD), // Màu chữ
                                              ),
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }
                          }
                          return Container(); // Default empty container
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                       OutlinedButton(
  style: OutlinedButton.styleFrom(
    foregroundColor: Colors.orange, backgroundColor: Colors.white, // Text color
    side: BorderSide(color: Colors.black), // Border color
  ),
  onPressed: () {
    if (currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  },
  child: const Text("Trang trước"),
),

                        ElevatedButton(
                          onPressed: () {
                            if (currentIndex <
                                slideProv.slideList!.length - 1) {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            } else {
                              SystemChrome.setPreferredOrientations(
                                [
                                  DeviceOrientation.portraitDown,
                                  DeviceOrientation.portraitUp,
                                ],
                              );
                              Navigator.pop(context);
                            }
                          },
                          child: const Text("Trang sau"),
                        )
                      ],
                    )
                  ],
                ),
    );
  }
  void loadQuestionThenNavigate(Category category) async {
    final questions = await getQuestionsFromFile(category.questionPath);
    await navigateToQuizDetails(category, questions);
  }

  navigateToQuizDetails(Category category, List<Question> questions) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizDetailsPage(
          selectedCategory: category,
          questions: questions,
        ),
      ),
    );
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

import 'package:local_education_app/screens/atlas/altas_screen.dart';
import 'package:local_education_app/screens/lesson/lesson_screen.dart';
import 'package:local_education_app/screens/login/login_screen.dart';
import 'package:local_education_app/screens/signup/signup_screen.dart';
import 'package:local_education_app/screens/slide/slide_screen.dart';
import 'package:local_education_app/screens/tour_detail/tour_detail_screen.dart';
import 'package:local_education_app/screens/home/home_screen.dart';

class AppRouter {
  static Route generateRoute(RouteSettings settings) {
    // final TourArgument tourArgument = settings.arguments as TourArgument;
    // final LessonArgument lessonArgument = settings.arguments as LessonArgument;
    switch (settings.name) {
      case "HomeScreen":
        {
          return MaterialPageRoute(builder: (context) => const HomeScreen());
        }
      case "SignupScreen":
        {
          return MaterialPageRoute(builder: (context) => const SignUpScreen());
        }
      case "LoginScreen":
        {
          return MaterialPageRoute(builder: (context) => const LoginScreen());
        }
      case "TourScreen":
        {
          if (settings.arguments is TourArgument) {
            final tourArgument = settings.arguments as TourArgument;
            return MaterialPageRoute(
                builder: (context) => TourScreen(
                      tourSlug: tourArgument.tourSlug,
                      startIndex: tourArgument.startSceneIndex,
                    ));
          } else {
            return MaterialPageRoute(builder: (_) {
              return Scaffold(
                body: Center(
                  child: Text('Wrong argument defined for ${settings.name}'),
                ),
              );
            });
          }
        }
      case "AtlasScreen":
        {
          return MaterialPageRoute(builder: (context) => const AtlasScreen());
        }
      case "LessonScreen":
        {
          if (settings.arguments is LessonArgument) {
            final lessonArgument = settings.arguments as LessonArgument;
            return MaterialPageRoute(
                builder: (context) =>
                    LessonScreen(courseSlug: lessonArgument.courseSlug));
          } else {
            return MaterialPageRoute(builder: (_) {
              return Scaffold(
                body: Center(
                  child: Text('Wrong argument defined for ${settings.name}'),
                ),
              );
            });
          }
        }
      case 'SlideScreen':
        {
          if (settings.arguments is SlideArgument) {
            final slideArgument = settings.arguments as SlideArgument;
            return MaterialPageRoute(
                builder: (context) =>
                    SlideScreen(lessonId: slideArgument.lessonId));
          } else {
            return MaterialPageRoute(builder: (_) {
              return Scaffold(
                body: Center(
                  child: Text('Wrong argument defined for ${settings.name}'),
                ),
              );
            });
          }
        }
      default:
        return MaterialPageRoute(builder: (_) {
          return Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          );
        });
    }
  }
}

class TourArgument {
  final String tourSlug;
  final int startSceneIndex;
  TourArgument({
    required this.tourSlug,
    this.startSceneIndex = 0,
  });
}

class LessonArgument {
  final String courseSlug;
  LessonArgument({required this.courseSlug});
}

class SlideArgument {
  final String lessonId;
  SlideArgument({
    required this.lessonId,
  });
}

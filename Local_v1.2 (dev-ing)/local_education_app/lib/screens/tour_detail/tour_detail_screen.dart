import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:local_education_app/config/routes/router.dart';
import 'package:local_education_app/config/routes/routes.dart';
import 'package:local_education_app/constants/api_constant.dart';
import 'package:local_education_app/provider/tour_provider.dart';
import 'package:local_education_app/services/coordinate/coordinate_converter.dart';
import 'package:panorama_viewer/panorama_viewer.dart';
import 'package:provider/provider.dart';

class TourScreen extends StatefulWidget {
  const TourScreen({super.key, this.startIndex = 0, required this.tourSlug});
  final String tourSlug;
  final int startIndex;
  @override
  State<TourScreen> createState() => _TourScreenState();
}

class _TourScreenState extends State<TourScreen> {
  int currentIndex = 0;
  bool isPlaying = false;
  final audioPlayer = AudioPlayer();
  @override
  void initState() {
    super.initState();
    // Provider.of<TourProvider>(context).tourGetTourBySlug(widget.tourSlug);
    currentIndex = widget.startIndex;
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    audioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Consumer<TourProvider>(
      builder: (context, tour, child) {
        if (tour.tourDetail?.scenes == null ||
            tour.tourDetail!.scenes.isEmpty) {
          tour.tourGetTourBySlug(widget.tourSlug);
          return const Center(
            child: Text("No Screne found"),
          );
        } else {
          final currentTour = tour.tourDetail;
          final imageUrl = currentTour?.scenes[currentIndex].urlImage;
          const domain = ApiEndpoint.domain;
          final linkHotSpots = currentTour?.scenes[currentIndex].linkHotspots;
          final infoHotSpot = currentTour?.scenes[currentIndex].infoHotspots;

          final audio = currentTour?.scenes[currentIndex].audio;
          final linkHotSpotWidget = linkHotSpots?.map((item) {
            return Hotspot(
              longitude: CoordinateConverter.toLongitude(
                item.x,
                item.y,
                item.z,
              ),
              latitude: CoordinateConverter.toLatitude(
                item.x,
                item.y,
                item.z,
              ),
              widget: IconButton(
                icon: const Icon(
                  Icons.assistant_navigation,
                  color: Colors.red,
                  size: 32,
                ),
                onPressed: () {
                  final index = item.sceneIndex;
                  debugPrint(index.toString());
                  setState(
                    () {
                      currentIndex = index;
                    },
                  );
                },
              ),
            );
          }).toList();
          final infoHotSpotWidget = infoHotSpot?.map((item) {
            return Hotspot(
              longitude: CoordinateConverter.toLongitude(
                item.x,
                item.y,
                item.z,
              ),
              latitude: CoordinateConverter.toLatitude(
                item.x,
                item.y,
                item.z,
              ),
             widget: Flexible( // Wrap with Flexible
             
                child: Stack(
                  
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.assistant_navigation,
                        color: Colors.blue,
                        size: 32,
                      ),
                      onPressed: () async {
                        await audioPlayer.stop();
                        if (context.mounted) {
                          Navigator.pushNamed(context, RouteName.slideScreen,
                              arguments: SlideArgument(lessonId: item.lessonId));
                        }
                      },
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Column(children: [
                        
                        Text(
                      "Chương " + item.title.split('.')[0],
                      softWrap: false,
                      style: TextStyle(
                        overflow: TextOverflow.visible,
                        color: Colors.white,
                      ),
                    ),SizedBox(
                          height: 12,
                        ),
                      ],)
                    )
                  ],
                ),
              ),
            );
          }).toList();

          return Center(
            child: Stack(
              children: [
                PanoramaViewer(
                  animSpeed: 0,
                  hotspots: [...?infoHotSpotWidget, ...?linkHotSpotWidget],
                  child: Image.network('$domain/$imageUrl'),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 70,
                    color: Colors.black.withOpacity(0.5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () async {
                              await audioPlayer.stop();
                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                            },
                            child: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            disabledColor: Colors.grey,
                            onPressed: audio == null
                                ? null
                                : () async {
                                    debugPrint("pressed");
                                    if (isPlaying) {
                                      await audioPlayer.pause();
                                    } else {
                                      await audioPlayer.play(
                                          UrlSource("$domain/${audio.path}"));
                                    }
                                  },
                            icon: Icon(
                              isPlaying ? Icons.volume_up : Icons.volume_off,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () async {
                              await audioPlayer.stop();
                              if (context.mounted) {
                                Navigator.pushNamed(
                                    context, RouteName.atlasScreen);
                              }
                            },
                            child: const Icon(
                              Icons.map,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    ));
  }
}

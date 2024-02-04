import 'package:flutter/material.dart';
import 'components.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  YoutubePlayerController? myController;
  // int _counter = 0;

  // void _incrementCounter() {
  //   setState(() {
  //     // _counter++;
  //   });
  // }

  @override
  void initState() {
    String testURL = "https://www.youtube.com/watch?v=snYu2JUqSWs";
    String testID = YoutubePlayer.convertUrlToId(testURL) as String;
    myController = YoutubePlayerController(
      initialVideoId: testID,
      flags: const YoutubePlayerFlags(
          mute: false,
          autoPlay: true,
          disableDragSeek: true,
          loop: false,
          enableCaption: false),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(widget.title),
          centerTitle: true,
          bottom: PreferredSize(
              preferredSize: const Size.fromHeight(0.4),
              child: Container(
                  color: const Color.fromARGB(255, 185, 162, 224),
                  height: 2.0))),
      body: Center(
          // child: chatContainer()
          child: outputChannel(myController as YoutubePlayerController)),
      backgroundColor: Colors.white,
    );
  }
}

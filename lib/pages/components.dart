import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

Container debugBox({required Widget child, required Color color}) {
  return Container(
      decoration: BoxDecoration(border: Border.all(color: color)),
      child: child);
}

FractionallySizedBox chatContainer(YoutubePlayerController controller) {
  return FractionallySizedBox(
      widthFactor: 0.7,
      heightFactor: 0.9,
      child: debugBox(
        color: Colors.greenAccent,
        child: Container(
          decoration:
              BoxDecoration(border: Border.all(color: Colors.greenAccent)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              outputChannel(controller),
              inputField(),
            ],
          ),
        ),
      ));
}

Padding inputField() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 80.0, vertical: 0),
    child: TextFormField(
      decoration: const InputDecoration(
        // border: OutlineInputBorder(),
        hintText: 'Enter a search term',
      ),
    ),
  );
}

YoutubePlayer outputChannel(YoutubePlayerController controller) {
  // String videoId;
  // videoId = YoutubePlayer.convertUrlToId(
  //     "https://www.youtube.com/watch?v=snYu2JUqSWs") as String;
  // YoutubePlayerController controller = YoutubePlayerController(
  //   initialVideoId: videoId,
  //   flags: const YoutubePlayerFlags(
  //     autoPlay: true,
  //     mute: true,
  //   ),
  // );
  print('hi');
  return YoutubePlayer(
    controller: controller,
    showVideoProgressIndicator: true,
    onReady: () {
      print('Player is ready.');
    },
  );
}

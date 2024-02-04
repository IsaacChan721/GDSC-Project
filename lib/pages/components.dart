import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

Container debugBox({required Widget child, required Color color}) {
  return Container(
      decoration: BoxDecoration(border: Border.all(color: color)),
      child: child);
}

FractionallySizedBox chatContainer() {
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
              outputChannel(),
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

Container outputChannel() {
  final myController = YoutubePlayerController(
    params: const YoutubePlayerParams(
      mute: false,
      showControls: true,
      showFullscreenButton: true,
    ),
  );
  myController.loadVideoById(videoId: 'grd-K33tOSM', startSeconds:10, endSeconds: 20);
  // myController.loadPlaylist(list:['grd-K33tOSM', 'MtN1YnoL46Q'], startSeconds: 30);
  // myController.loadVideoById(...); // Auto Play
  // myController.cueVideoById(...); // Manual Play
  // myController.loadPlaylist(...); // Auto Play with playlist
  // myController.cuePlaylist(...); // Manual Play with playlist

  // If the requirement is just to play a single video.
  // final myController = YoutubePlayerController.fromVideoId(
  //   videoId: 'grd-K33tOSM',
  //   autoPlay: false,
  //   params: const YoutubePlayerParams(showFullscreenButton: true),
  // );
  return Container(
      child: YoutubePlayer(
    controller: myController,
    aspectRatio: 16 / 9,
  ));
}

// YoutubePlayer outputChannel(YoutubePlayerController controller) {
//   // String videoId;
//   // videoId = YoutubePlayer.convertUrlToId(
//   //     "https://www.youtube.com/watch?v=snYu2JUqSWs") as String;
//   // YoutubePlayerController controller = YoutubePlayerController(
//   //   initialVideoId: videoId,
//   //   flags: const YoutubePlayerFlags(
//   //     autoPlay: true,
//   //     mute: true,
//   //   ),
//   // );
//   print('hi');
//   return YoutubePlayer(
//     controller: controller,
//     showVideoProgressIndicator: true,
//     onReady: () {
//       print('Player is ready.');
//     },
//   );
// }

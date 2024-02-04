import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:flutter/cupertino.dart';
import 'globals.dart';

Container debugBox({required Widget child, required Color color}) {
  return Container(
      decoration: BoxDecoration(border: Border.all(color: color)),
      child: child);
}

FractionallySizedBox chatContainer(
    {required BuildContext context,
    required TextEditingController myController,
    required List videoIDs,
    required Function func,
    required Function mySetState}) {
  return FractionallySizedBox(
    widthFactor: 0.7,
    heightFactor: 0.9,
    child: debugBox(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // youtubeEmbed(context),
          // promptField(myController),
          Expanded(
            child: outputChannel(videoIDs),
          ),
          Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black54),
                  borderRadius: const BorderRadius.all(Radius.circular(15))),
              child: inputContainer(
                  myController: myController,
                  func: func,
                  mySetState: mySetState))
        ],
      ),
    ),
  );
}

Row inputContainer(
    {required TextEditingController myController,
    required Function func,
    required Function mySetState}) {
  return Row(
    children: [
      Expanded(
          flex: 8,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(50.0, 0, 0, 0),
            child: promptField(myController, mySetState),
          )),
      Expanded(flex: 1, child: Container(child: searchBtn(func)))
    ],
  );
}

SizedBox promptField(TextEditingController myController, Function mySetState) {
  return SizedBox(
    width: 500,
    height: 60,
    child: TextFormField(
      cursorColor: Colors.red[300],
      controller: myController,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red[300] as Color, width: 2)),
        hintText: 'Enter a search term',
      ),
      onChanged: (val) {
        onPromptFieldChanged(val, mySetState);
      },
    ),
  );
}

Container outputChannel(List videoIDs) {
  if (isSearching) {
    return Container(
        child: Column(
      children: [
        const Expanded(
          child: SizedBox(),
        ),
        Container(
          width: 200,
          height: 200,
          child: AspectRatio(
            aspectRatio: 1,
            child: CircularProgressIndicator(
              color: Colors.red[300],
            ),
          ),
        ),
        const Expanded(
          child: SizedBox(),
        ),
      ],
    ));
    // return Container(
    //     child: SizedBox(
    //       width: 300,
    //       height: 300,
    //       child: AspectRatio(
    //         aspectRatio: 1,
    //         child: CircularProgressIndicator(
    //           color: Colors.red[300]

    //         ),
    //       ),
    //     )

    // );
  }
  if (videoIDs.isNotEmpty) {
    String s = "";
    for (String v in videoIDs) {
      s += v + ", ";
      print(v);
    }

    return Container(
      child: Center(child: Text(s)),
    );
  }
  // const CircularProgressIndicator();
  return Container(
    child: Center(child: landingWelcome()),
  );
}

Column landingWelcome() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Padding(
        padding: EdgeInsets.all(16.0),
        child: Icon(
          Icons.api,
          color: Colors.black,
        ),
      ),
      RichText(
        text: const TextSpan(
            text: "What can $appName teach you today?",
            style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w500)),
      )
    ],
  );
}

SizedBox youtubeEmbed(BuildContext context, String videoID, double startSeconds,
    double endSeconds) {
  final myController = YoutubePlayerController(
    params: const YoutubePlayerParams(
      mute: false,
      showControls: true,
      showFullscreenButton: true,
    ),
  );
  myController.loadVideoById(
      videoId: videoID, startSeconds: startSeconds, endSeconds: endSeconds);
  // videoId: 'grd-K33tOSM', startSeconds: 10, endSeconds: 20);
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
  return SizedBox(
    width: MediaQuery.of(context).size.width / 2,
    child: AspectRatio(
      aspectRatio: 16 / 9,
      child: YoutubePlayer(
        controller: myController,
        aspectRatio: 16 / 9,
      ),
    ),
  );
}

void onPromptFieldChanged(String val, Function mySetState) {
  val = val.trim();
  searchActive = val.isNotEmpty;
  mySetState();
}

Opacity searchBtn(Function func) {
  return Opacity(
    opacity: searchActive ? 1 : 0.2,
    child: IconButton(
      icon: const Icon(
        CupertinoIcons.paperplane,
        color: Colors.white,
      ),
      // icon: const Icon(Icons.arrow_forward, color: Colors.deepPurple),
      onPressed: () {
        searchActive ? func() : null;
      },
      style: IconButton.styleFrom(
          backgroundColor: Color.fromARGB(221, 34, 33, 33),
          fixedSize: const Size(36, 36),
          shape: const CircleBorder()),
    ),
  );
}

void searchInProgress() {}

void searchComplete() {}

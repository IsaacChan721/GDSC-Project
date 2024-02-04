import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:flutter/cupertino.dart';
import 'globals.dart';
// import 'carousel.dart';

List savedSessions = [];
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
  }

  if (videoIDs.isNotEmpty && !savedSessions.contains(videoIDs)) {

    // List<Widget> videoWidgets = [];
    // for (String vID in videoIDs) {
    //   videoWidgets.add(youtubeEmbed(vID, 0, 50));
    // }
    print('Save session');
    savedSessions.add(videoIDs);

    return Container(
        width: 800, child: youtubeEmbed(videoIDs[0].split('=')[1], 0, 40)
        // child: videoCarousel(videoWidgets),
        );
  }
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

SizedBox youtubeEmbed(String videoID, double startSeconds, double endSeconds) {
  final myController = YoutubePlayerController(
  params: const YoutubePlayerParams(
    mute: false,
    showControls: true,
    showFullscreenButton: true,
  ),
);
  myController.loadVideoById(
      videoId: videoID);
  return SizedBox(
    width: 600,
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
      onPressed: () {
        searchActive ? func() : null;
      },
      style: IconButton.styleFrom(
          backgroundColor: const Color.fromARGB(221, 34, 33, 33),
          fixedSize: const Size(36, 36),
          shape: const CircleBorder()),
    ),
  );
}

void searchInProgress() {}

void searchComplete() {}

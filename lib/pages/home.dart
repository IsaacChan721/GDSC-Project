import 'package:flutter/material.dart';
import 'components.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'globals.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userInput = '';
  final userInputTextController = TextEditingController();

  List videoIDs = [];

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
                  color: Colors.red[300],
                  height: 2.0))),
      body: Center(
          child: chatContainer(
              context: context,
              myController: userInputTextController,
              func: enterUserInput,
              videoIDs: videoIDs,
              mySetState: () {
                setState(() {});
              })),
      backgroundColor: Colors.white,
    );
  }

  Future<List> fetchData() async {
    final response = await http.get(Uri.http('127.0.0.1:8080', '/data'));
    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      return jsonBody as List;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<http.Response> sendPrompt(prompt) async {
    final response = await http.post(Uri.http('127.0.0.1:8080', '/send'),
        body: jsonEncode({"prompt": prompt}),
        encoding: Encoding.getByName("utf-8"));
    return response;
  }

  void enterUserInput() async {
    print('a');
    userInput = userInputTextController.text;
    if (userInput == '') return;
    setState(() {
      isSearching = true;
      searchActive = false;
    });
    await sendPrompt(userInput);
    videoIDs = await fetchData();
    print(videoIDs);
    userInputTextController.text = '';
    setState(() {
      isSearching = false;
      searchActive = false;
    });
  }
}

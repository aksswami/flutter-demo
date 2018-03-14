import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'Repo.dart';

class GithubPage extends StatefulWidget {
  @override
  createState() => new GithubPageState();
}

class GithubPageState extends State<GithubPage> {
  var _repos = <Repo>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);

  _getRepoList() async {
    var url = "https://api.github.com/users/aksswami/repos";
    var httpClient = new HttpClient();

    var result = <Repo>[];
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      request.headers.set(
          "Authorization", "token bbd182f4fd93af042412a32216908fb1e5f02931");
      var response = await request.close();
      print(response.statusCode);

      if (response.statusCode == HttpStatus.OK) {
        var json = await response.transform(UTF8.decoder).join();
        List<dynamic> data = JSON.decode(json);

        for (Map<String, dynamic> dat in data) {
          var repo = new Repo.fromJson(dat);
          result.add(repo);
          print(repo);
        }
      }
    } catch (exception) {
      result = <Repo>[];
      print(exception);
    }

    setState(() {
      _repos = result;
    });
  }

  @override
  void initState() {
    super.initState();
    _getRepoList();
  }

  Widget _buildSuggestions() {
    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _repos.length,
        itemBuilder: (context, i) {
          if (i.isOdd) return new Divider();
          final index = i ~/ 2;

          return _buildRow(_repos[index]);
        });
  }

  Widget _buildRow(Repo repo) {
    return new ListTile(
      title: new Text(
        repo.name,
        style: _biggerFont,
      ),
      subtitle: new Text(repo.description != null
          ? repo.description
          : "No description available"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("Github Repo viewer")),
      body: _buildSuggestions(),
    );
  }
}
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
  var _currentUserName = "aksswami";
  final _biggerFont = const TextStyle(fontSize: 18.0);

  _getRepoList() async {
    var url =
        "https://api.github.com/users/" + _currentUserName.toLowerCase().trim() + "/repos";
    var httpClient = new HttpClient();

    var result = <Repo>[];
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      request.headers.set(
          "Authorization", "token <ENTER your token here>");
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
      } else {
        showDialog(
          context: context,
          child: new AlertDialog(
            title: new Text("Error!"),
            content: new Text("Got response code ${response.statusCode}"),
          ),
        );
      }
    } catch (exception) {
      result = <Repo>[];
      print(exception);
      showDialog(
        context: context,
        child: new AlertDialog(
          title: new Text("Error!"),
          content: new Text("Exception ${exception.toString()}"),
        ),
      );
    }

    setState(() {
      _repos = result;
    });
  }

  void _handleSubmitted(String username) {
    _currentUserName = username;
    print(_currentUserName);
    _getRepoList();
  }

  @override
  void initState() {
    super.initState();
    _getRepoList();
  }

  Widget _buildSuggestions() {
    return new Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          new TextFormField(
            decoration: const InputDecoration(
              labelText: 'Github username to view his/her repos (ex: aksswami)',
            ),
            keyboardType: TextInputType.text,
            onFieldSubmitted: (String value) {
              _handleSubmitted(value);
            },
          ),
          const Divider(height: 1.0),
          new Expanded(
            child: new ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: _repos.length,
                itemBuilder: (context, i) {
                  if (i.isOdd) return new Divider();
                  final index = i ~/ 2;

                  return _buildRow(_repos[index]);
                }),
          )
        ]);
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

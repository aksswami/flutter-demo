import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'dart:convert';
import 'dart:io';
import 'Repo.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Startup Name Generator',
      home: new GithubPage(),
      theme: new ThemeData(
        primaryColor: Colors.white,

      ),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  createState() => new RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);

  Widget _buildSuggestions() {
    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return new Divider();

          final index = i ~/ 2;

          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }

          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return new ListTile(
      title: new Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) {
          final tiles = _saved.map((pair) {
            return new ListTile(
              title: new Text(
                pair.asPascalCase,
                style: _biggerFont,
              ),
            );
          });

          final divided = ListTile
              .divideTiles(
                context: context,
                tiles: tiles,
              )
              .toList();

          return new Scaffold(
            appBar: new AppBar(
              title: new Text("Saved Suggestions"),
            ),
            body: new ListView(children: divided),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Startup name generator"),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }
}


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
      request.headers.set("Authorization", "token bbd182f4fd93af042412a32216908fb1e5f02931");
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

//    if (!mounted) return;

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

          if (index >= _repos.length) {
//            _suggestions.addAll(generateWordPairs().take(10));

          }

          return _buildRow(_repos[index]);
        });
  }

  Widget _buildRow(Repo repo) {
    return new ListTile(
      title: new Text(
        repo.name,
        style: _biggerFont,
    ),
    );
  }

  @override
  Widget build(BuildContext context) {
//    _getRepoList();
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Github Repo viewer")
      ),
      body: _buildSuggestions(),
    );
  }
}

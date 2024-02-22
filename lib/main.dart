import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _scrollController = ScrollController();
  final _list = [];
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMore);
    _fetchData(_currentPage);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchData(int pageKey) async {
    final response =
        await http.get(Uri.parse('https://saavn.dev/search/songs?query=kun+faya+kun&page=$_currentPage&limit=10'));
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body)['data']['results'];
      _currentPage.printInfo();
      setState(() {
        _list.addAll(json);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  void _loadMore() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _currentPage++;
      _fetchData(_currentPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('API Pagination Example'),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: _list.length,
        itemBuilder: (BuildContext context, int index) {
          var data = _list[index];
          return ListTile(
            contentPadding: EdgeInsets.all(12),
            title: Text("${data['id']} - ${data['name']}"),
          );
        },
      ),
    );
  }
}

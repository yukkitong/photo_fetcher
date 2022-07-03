import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'photo.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const MyHome(),
    );
  }
}

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  List<Photo> photos = [];
  bool loading = false;
  int albumId = 1;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPhotos(albumId);
    _scrollController.addListener(() {
      print(_scrollController.position.maxScrollExtent);
      print(_scrollController.position.pixels);
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        albumId++;
        getPhotos(albumId);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> getPhotos(int albumId) async {
    if (albumId > 10) {
      return;
    }

    final String url =
        'https://jsonplaceholder.typicode.com/photos?albumId=$albumId';
    try {

      if (albumId == 1) {
        setState(() {
          loading = true;
        });
      }

      http.Response response = await http.get(Uri.parse(url));
      if (albumId == 1) {
        setState(() {
          loading = false;
        });
      }

      final items = json.decode(response.body);
      items.forEach((item) {
        photos.add(Photo.fromJson(item));
      });

      // 상단의 photos.add(Photo.fromJson(item)) 에서 받아온 데이터를 다시 화면에 리빌드 하기 위함.
      setState(() {});

    } catch (err) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.red[200],
            title: const Text('Failure'),
            content: const Text('Fail to get album data'),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Fetcher'),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        controller: _scrollController,
        itemCount: photos.length + 1,
        itemBuilder: (context, index) {
          if (index == photos.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: CircularProgressIndicator(),
              ),
            );
          }
          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Image.network(
                    photos[index].url,
                    width: double.infinity,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  Text(photos[index].title)
                ],
              ),
              Text(
                '${index + 1}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 60),
              ),
            ],
          );
        },
      ),
    );
  }
}

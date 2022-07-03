import 'package:flutter/material.dart';
import 'package:photo_fetcher/provider/photo_provider.dart';
import 'package:provider/provider.dart';

void main() => runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => PhotoProvider()),
    ],
    child: const MyApp(),
  )
);

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

  int albumId = 1;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final provider = context.read<PhotoProvider>();
    provider.fetchPhotos(albumId: albumId);

    _scrollController.addListener(() {
      print(_scrollController.position.maxScrollExtent);
      print(_scrollController.position.pixels);
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        albumId++;
        provider.fetchPhotos(albumId: albumId);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
    Widget build(BuildContext context) {
    final provider = context.watch<PhotoProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Fetcher'),
      ),
      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        controller: _scrollController,
        itemCount: provider.photos.length + 1,
        itemBuilder: (context, index) {
          if (index == provider.photos.length) {
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
                    provider.photos[index].url,
                    width: double.infinity,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  Text(provider.photos[index].title)
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

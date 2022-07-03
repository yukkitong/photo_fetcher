import 'package:flutter/material.dart';
import 'package:photo_fetcher/photo.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PhotoProvider extends ChangeNotifier {

    List<Photo> list = [];
    bool loading = false;
    bool hasMore = true;

    Future<List<Photo>> _makeRequest({
      required int id
    }) async {
      if (id > 10) {
        return [];
      }

      final String url = 'https://jsonplaceholder.typicode.com/photos?albumId=$id';
      try {
        http.Response response = await http.get(Uri.parse(url));
        final items = json.decode(response.body);
        final List<Photo> photos = [];
        items.forEach((item) {
          photos.add(Photo.fromJson(item));
        });
        return photos;
      } catch (err) {
        // ignore
      }
      return [];
    }

    fetchPhotos({ int? id }) async {
      id ??= 0;

      loading = true;
      notifyListeners();

      final photos = await _makeRequest(id: id);
      list = [ ...list, ...photos ];
      loading = false;
      notifyListeners();
    }
}
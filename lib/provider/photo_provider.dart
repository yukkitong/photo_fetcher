import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../photo.dart';


class PhotoProvider extends ChangeNotifier {
  List<Photo> photos = [];
  bool loading = false;
  String? error;

  fetchPhotos({ int? albumId }) async {
    albumId ??= 1;

    if (albumId > 10) {
      return;
    }

    final String url =
        'https://jsonplaceholder.typicode.com/photos?albumId=$albumId';
    try {
      if (albumId == 1) {
          loading = true;
          notifyListeners();
      }

      http.Response response = await http.get(Uri.parse(url));
      final items = json.decode(response.body);
      items.forEach((item) {
        photos.add(Photo.fromJson(item));
      });
      loading = false;
      notifyListeners();
    } catch (err) {
      error = err.toString();
      loading = false;
      notifyListeners();
    }
  }
}
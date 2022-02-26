import 'dart:convert';

import 'package:demo_app/db/database_helper.dart';
import 'package:demo_app/model/post_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart';

class PostNotifier extends ChangeNotifier {
  List<PostModel> list = [];

  PostNotifier() {
    getPostData();
  }

  getPostData() async {
    list.clear();
    List<PostModel> result = await SQLiteDbProvider.db.getAllPosts();
    if (result.isNotEmpty) {
      list.addAll(result);
      notifyListeners();
    } else {
      try {
        var response =
            await Dio().get('https://jsonplaceholder.typicode.com/posts');
        if (response.statusCode == 200) {
          List data = response.data;
          // store json data into list
          List<PostModel> posts =
              data.map((i) => PostModel.fromJson(i)).toList();
          posts.forEach((element) {
            SQLiteDbProvider.db.insert(element);
          });
          list.addAll(posts);
          notifyListeners();
        }
        print(response);
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> addFavourite(PostModel model) async {
    var index = list.indexOf(model);
    if (index >= 0) {
      list[index].fav = model.fav == 0 ? 1 : 0;
      await SQLiteDbProvider.db.update(model);
      notifyListeners();
    }
  }

  void delete(PostModel model) async {
    var index = list.indexOf(model);
    if (index >= 0) {
      await SQLiteDbProvider.db.delete(model);
      list.remove(model);
      notifyListeners();
    }
  }
}

import 'package:demo_app/db/database_helper.dart';
import 'package:demo_app/model/post_model.dart';
import 'package:demo_app/post_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({Key? key}) : super(key: key);

  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final nameController = TextEditingController();
  final desController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Posts"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 8, top: 15, right: 8, bottom: 10),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name',
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              controller: desController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Description',
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
              child: Text('Save'),
              onPressed: () {
                var name = nameController.text.trim().toString();
                var des = desController.text.trim().toString();
                if (name.isNotEmpty && des.isNotEmpty) {
                  savePost(name, des);
                }
              },
            )
          ],
        ),
      ),
    );
  }

  void savePost(String name, String des) async {
    PostModel? model = await SQLiteDbProvider.db.getLastPosts();
    var id = model?.id ?? 0;
    PostModel postModel =
        PostModel(userId: model?.userId, id: id + 1, title: name, body: des, fav: 1);
    await SQLiteDbProvider.db.insert(postModel);
    Navigator.pop(context, true);
  }
}

import 'package:demo_app/add_post.dart';
import 'package:demo_app/post_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PostNotifier>(builder: (context, viewModel, child) {
      return Scaffold(
          appBar: AppBar(
            title: const Text("Posts"),
            actions: [
              IconButton(
                  onPressed: () async {
                    var result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddPostPage()),
                    );
                    if (result) {
                      viewModel.getPostData();
                    }
                  },
                  icon: const Icon(Icons.edit))
            ],
          ),
          body: ListView.builder(
            itemCount: viewModel.list.length,
            itemBuilder: (context, index) {
              var model = viewModel.list[index];
              return Dismissible(
                key: Key(model.id.toString()),
                background: slideRightBackground(),
                secondaryBackground: slideLeftBackground(),
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.endToStart) {
                    viewModel.delete(model);
                  } else {
                    viewModel.delete(model);
                  }
                },
                child: ListTile(
                  title: Text('${model.title}'),
                  subtitle: Text('${model.title}'),
                  trailing: IconButton(
                    icon: Icon(model.isFavourite
                        ? Icons.favorite
                        : Icons.favorite_border),
                    onPressed: () {
                      viewModel.addFavourite(model);
                    },
                  ),
                ),
              );
            },
          ));
    });
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Delete",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

  Widget slideRightBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Edit",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }
}

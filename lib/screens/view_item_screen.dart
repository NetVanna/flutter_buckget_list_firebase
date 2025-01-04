import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ViewItemScreen extends StatefulWidget {
  const ViewItemScreen(
      {super.key,
      required this.title,
      required this.imageUrl,
      required this.index});

  final String title;
  final String imageUrl;
  final int index;

  @override
  State<ViewItemScreen> createState() => _ViewItemScreenState();
}

class _ViewItemScreenState extends State<ViewItemScreen> {
  void deleteData() async {
    Navigator.pop(context);
    try {
      var response = await Dio().delete(
          "https://flutterapitest123-56c2f-default-rtdb.firebaseio.com/bucketlist/${widget.index}.json");
      Navigator.pop(context, "refresh");
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void markAsCompleted() async {
    Map<String, dynamic> data = {
      "complete": true,
    };
    try {
      var response = await Dio().patch(
          "https://flutterapitest123-56c2f-default-rtdb.firebaseio.com/bucketlist/${widget.index}.json",
          data: data);
      if (mounted) {
        Navigator.pop(context, "refresh");
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              if (value == 1) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Are you sure to delete?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () {
                          deleteData();
                        },
                        child: const Text("Confirm"),
                      ),
                    ],
                  ),
                );
              }
              if (value == 2) {
                markAsCompleted();
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                  value: 1,
                  child: Text("Delete"),
                ),
                const PopupMenuItem(
                  value: 2,
                  child: Text("Mark as Completed"),
                ),
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Image.network(
                widget.imageUrl ?? "",
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}

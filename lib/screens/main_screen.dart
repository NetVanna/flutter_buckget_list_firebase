import 'package:buckget_list/screens/add_bucket_screen.dart';
import 'package:buckget_list/screens/view_item_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<dynamic> bucketDataList = [];
  bool isLoading = true;

  Future<void> getData() async {
    try {
      setState(() {
        isLoading = true;
      });

      var response = await Dio().get(
          "https://flutterapitest123-56c2f-default-rtdb.firebaseio.com/bucketlist.json");

      if (response.data is List) {
        // Filter out invalid elements and those where "complete" is true
        bucketDataList = response.data
            .where((element) =>
                element != null &&
                element is Map &&
                (element["complete"] == null || element["complete"] == false))
            .toList();
      } else {
        bucketDataList = [];
      }

      setState(() {});
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching data: $e");
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bucket List"),
        actions: [
          InkWell(
            onTap: getData,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.refresh),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddBucketScreen(
                newIndex: bucketDataList.length,
              ),
            ),
          ).then((value) {
            if (value == "refresh") {
              getData();
            }
          });
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          getData();
        },
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : bucketDataList.isEmpty
                ? const Center(
                    child: Text(
                      "No data in bucket list",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: bucketDataList.length,
                    itemBuilder: (context, index) {
                      var data = bucketDataList[index];
                      if (data is! Map) {
                        return const SizedBox(); // Skip invalid data
                      }

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewItemScreen(
                                  title: data['item'] ?? 'No Title',
                                  imageUrl: data['image'] ?? '',
                                  index: index,
                                ),
                              ),
                            ).then((value) {
                              if (value == "refresh") {
                                getData();
                              }
                            });
                          },
                          title: Text(
                            data['item'] ?? 'No Title',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          leading: data['image'] != null
                              ? CircleAvatar(
                                  backgroundImage: NetworkImage(data['image']),
                                )
                              : const CircleAvatar(
                                  child: Icon(Icons.image),
                                ),
                          trailing: Text(
                            "\$${data['cost'] ?? '0.00'}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}

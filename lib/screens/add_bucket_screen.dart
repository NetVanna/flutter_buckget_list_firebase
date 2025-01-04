import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AddBucketScreen extends StatefulWidget {
  const AddBucketScreen({super.key, required this.newIndex});

  final int newIndex;

  @override
  State<AddBucketScreen> createState() => _AddBucketScreenState();
}

class _AddBucketScreenState extends State<AddBucketScreen> {
  void addData() async {
    Map<String, dynamic> data = {
      "item": itemController.text,
      "cost": costController.text,
      "image": imageUrlController.text,
      "complete": false
    };
    try {
      var response = await Dio().patch(
          "https://flutterapitest123-56c2f-default-rtdb.firebaseio.com/bucketlist/${widget.newIndex}.json",
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

  TextEditingController itemController = TextEditingController();
  TextEditingController costController = TextEditingController();
  TextEditingController imageUrlController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Bucket List"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "This Item can't be empty";
                  } else if (value.length < 3) {
                    return "This item must be more than 3 characters";
                  }
                  return null;
                },
                controller: itemController,
                decoration: InputDecoration(
                  label: const Text("Item"),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "This field can't be empty";
                  } else if (double.tryParse(value) == null) {
                    return "Please enter a valid number";
                  }
                  return null;
                },
                controller: costController,
                decoration: InputDecoration(
                    label: const Text("Estimated Cost"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
                keyboardType:
                    TextInputType.number, // Suggests a numeric keyboard
              ),
              const SizedBox(height: 15),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "This Item can't be empty";
                  } else if (value.length < 3) {
                    return "This item must be more than 3 characters";
                  }
                  return null;
                },
                controller: imageUrlController,
                decoration: InputDecoration(
                    label: const Text("Image Url"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          addData();
                        }
                      },
                      child: const Text(
                        "Add Data",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'dart:io';
// import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class EditPostScreen extends StatefulWidget {
  final String postId;
  final Map<String, dynamic> postData;

  const EditPostScreen(
      {Key? key,
      required this.postId,
      required this.postData,
      required DataSnapshot snapshot})
      : super(key: key);

  @override
  _EditPostScreenState createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.postData['PTitel'];
    _descriptionController.text = widget.postData['PDescription'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text('Edit Post'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      print(widget.postId);
                      // Update post in Firebase
                      DatabaseReference ref = FirebaseDatabase.instance
                          .ref('Post/Post List')
                          .child(widget.postId.toString());

                      await ref.update({
                        'PTitel': _titleController.text,
                        'PDescription': _descriptionController.text,
                      });

                      Navigator.pop(context, {});
                    }
                  },
                  child: const Text('Update Post'),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      print(widget.postId);
                      // Update post in Firebase
                      DatabaseReference ref = FirebaseDatabase.instance
                          .ref('Post/Post List')
                          .child(widget.postId.toString());

                      await ref.remove();

                      Navigator.pop(context, {});
                    }
                  },
                  child: const Text('Delete post'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

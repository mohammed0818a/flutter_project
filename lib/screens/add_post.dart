import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_database/firebase_database.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:project_flutter/components/round_bottom.dart';
import 'package:project_flutter/screens/Home_screen.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

bool ShowSpinner = false;

class _AddPostScreenState extends State<AddPostScreen> {
  final PostRef = FirebaseDatabase.instance.reference().child('Post');
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  File? _image;
  String? _image_name;
  final picker = ImagePicker();

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  Future getImageGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _image_name = pickedFile.name;
      } else {
        print('No Image selected');
      }
    });
  }

  Future getCameraImege() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _image_name = pickedFile.name;
      } else {
        print('No Image selected');
      }
    });
  }

  void dialog(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            content: SizedBox(
                height: 120,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        getCameraImege();
                        Navigator.pop(context);
                      },
                      child: const ListTile(
                        leading: Icon(Icons.camera),
                        title: Text('Camera'),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        getImageGallery();
                        Navigator.pop(context);
                      },
                      child: const ListTile(
                        leading: Icon(Icons.photo_library),
                        title: Text('Gallery'),
                      ),
                    )
                  ],
                )),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: ShowSpinner,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: const Text('Add your Jop', style: TextStyle(fontSize: 25)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(children: [
              InkWell(
                onTap: () {
                  dialog(context);
                },
                child: Center(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * .2,
                    width: MediaQuery.of(context).size.width * 1,
                    child: _image != null
                        ? ClipRRect(
                            child: Image.file(_image!.absolute,
                                height: 10, width: 10, fit: BoxFit.cover),
                          )
                        : Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10)),
                            height: 100,
                            width: 100,
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.blue,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      controller: titleController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        hintText: 'Enter Post Title',
                        border: OutlineInputBorder(),
                        hintStyle: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.normal),
                        labelStyle: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.normal),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      controller: descriptionController,
                      keyboardType: TextInputType.text,
                      minLines: 1,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        labelText: 'Decoration',
                        hintText: 'Enter Post Decoration',
                        border: OutlineInputBorder(),
                        hintStyle: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.normal),
                        labelStyle: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.normal),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              RoundButton(
                  title: 'Upload',
                  color: Colors.indigo,
                  onPress: () async {
                    setState(() {
                      ShowSpinner = true;
                    });
                    try {
                      int date = DateTime.now().microsecondsSinceEpoch;
                      firebase_storage.Reference ref = firebase_storage
                          .FirebaseStorage.instance
                          .ref('/blogapp$date$_image_name');
                      UploadTask uploadTask = ref.putFile(File(_image!.path));

                      final snapshot =
                          await uploadTask.whenComplete(() => null);
                      final url = await snapshot.ref.getDownloadURL();
                      final User? user = _auth.currentUser;
                      
                      PostRef.child('Post List').child(date.toString()).set({
                        'PID': date.toString(),
                        'PImage': url,
                        'PTime': date.toString(),
                        'PTitel': titleController.text.toString(),
                        'PDescription': descriptionController.text.toString(),
                        'UEmail': user!.email.toString(),
                        'UId': user.uid.toString(),
                      }).then((value) {
                        toastMessage('Post Published');
                        setState(() {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen()));
                          ShowSpinner = false;
                        });
                      }).onError((error, stackTrace) {
                        toastMessage(error.toString());
                        setState(() {
                          ShowSpinner = false;
                        });
                      });
                    } catch (e) {
                      setState(() {
                        ShowSpinner = false;
                      });
                      toastMessage(e.toString());
                    }
                  })
            ]),
          ),
        ),
      ),
    );
  }

  void toastMessage(String message) {
    Fluttertoast.showToast(
        msg: message.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 16.0);
  }
}

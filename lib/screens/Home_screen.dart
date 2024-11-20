// import 'dart:developer';
// import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:project_flutter/screens/EditPost.dart';
import 'package:project_flutter/screens/add_post.dart';
import 'package:project_flutter/screens/option_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final dbRef = FirebaseDatabase.instance.ref();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  TextEditingController searchController = TextEditingController();
  String search = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff9fafc),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.indigo,
                ),
                child: Text('Jop App',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ))),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('about us'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.indigo,
                      title: Text(
                        'welcome in our app thes app for serch for any thing you want abaout work and job and you can add your work here to have'
                        ' costumers\n'
                        '____________________________________________________________________________\n'
                        '\nthes app created by eng:Mohamed Abdalaziz and eng:Mohamed ali Naseb and eng: Ahmeda Ali Bushnaf',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text(
                            'OK',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('sing out'),
              onTap: () async {
                await _firebaseAuth.signOut();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => OptionScreen()));
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text('Home', style: TextStyle(fontSize: 25)),
        centerTitle: true,
        actions: [
          InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddPostScreen()));
              },
              child: Icon(Icons.add)),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 400.0, // Change the width as needed
              height: 35.0, // Change the height as needed
              child: TextFormField(
                controller: searchController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'searh for post by Titel',
                  hintStyle: TextStyle(
                    fontSize: 15,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 20.0), // Change the padding as needed

                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (String Value) {
                  search = Value;
                },
              ),
            ),
            Expanded(
                child: FirebaseAnimatedList(
              query: dbRef.root.child('Post/Post List'),
              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                String tempTitel = snapshot.child('PTitel').value.toString();
                if (searchController.text.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              DatabaseReference ref = FirebaseDatabase.instance
                                  .ref('Post/Post List')
                                  .child(snapshot.key.toString());
                              DatabaseEvent event = await ref.once();
                              var email = event.snapshot.child('UEmail').value;
                              var currentUser =
                                  FirebaseAuth.instance.currentUser!.email;
                              currentUser == email
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditPostScreen(
                                          postId: snapshot.key!,
                                          postData: {
                                            'PTitel': snapshot
                                                .child('PTitel')
                                                .value
                                                .toString(),
                                            'PDescription': snapshot
                                                .child('PDescription')
                                                .value
                                                .toString(),
                                          },
                                          snapshot: snapshot,
                                        ),
                                      ),
                                    ).then((updatedData) {
                                      if (updatedData != null) {
                                        // Update post in your list using updatedData['postId'] and updatedData['newTitle'] and updatedData['newDescription']

                                        // Here's a simplified example (replace with your actual logic):
                                        final updatedPostId =
                                            updatedData['postId'];
                                        dbRef.child(updatedPostId).update({
                                          // Update the post in Firebase
                                          'PTitel': updatedData['newTitle'],
                                          'PDescription':
                                              updatedData['newDescription'],
                                        });

                                        // Update local data store or UI to reflect the changes (implementation depends on your app)
                                      }
                                    })
                                  : Container();
                            },
                            child: Container(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: FadeInImage.assetNetwork(
                                  fit: BoxFit.cover,
                                  width: MediaQuery.of(context).size.width * 1,
                                  height:
                                      MediaQuery.of(context).size.height * .25,
                                  placeholder: 'images/blogger-saingtulum.png',
                                  image:
                                      snapshot.child('PImage').value.toString(),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              snapshot.child('PTitel').value.toString(),
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              snapshot.child('PDescription').value.toString(),
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.normal),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (tempTitel
                    .toLowerCase()
                    .contains(searchController.text.toString())) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // FadeInImage.assetNetwork(
                          //   placeholder: 'images/Bloggar logo.png',
                          //   image: snapshot.child('PImage').value.toString(),
                          // ),
                          GestureDetector(
                            onTap: () async {
                              DatabaseReference ref = FirebaseDatabase.instance
                                  .ref('Post/Post List')
                                  .child(snapshot.key.toString());
                              DatabaseEvent event = await ref.once();
                              var email = event.snapshot.child('UEmail').value;
                              var currentUser =
                                  FirebaseAuth.instance.currentUser!.email;
                              currentUser == email
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditPostScreen(
                                          postId: snapshot.key!,
                                          postData: {
                                            'PTitel': snapshot
                                                .child('PTitel')
                                                .value
                                                .toString(),
                                            'PDescription': snapshot
                                                .child('PDescription')
                                                .value
                                                .toString(),
                                          },
                                          snapshot: snapshot,
                                        ),
                                      ),
                                    ).then((updatedData) {
                                      if (updatedData != null) {
                                        // Update post in your list using updatedData['postId'] and updatedData['newTitle'] and updatedData['newDescription']

                                        // Here's a simplified example (replace with your actual logic):
                                        final updatedPostId =
                                            updatedData['postId'];
                                        dbRef.child(updatedPostId).update({
                                          // Update the post in Firebase
                                          'PTitel': updatedData['newTitle'],
                                          'PDescription':
                                              updatedData['newDescription'],
                                        });

                                        // Update local data store or UI to reflect the changes (implementation depends on your app)
                                      }
                                    })
                                  : Container();
                            },
                            child: Container(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: FadeInImage.assetNetwork(
                                  fit: BoxFit.cover,
                                  width: MediaQuery.of(context).size.width * 1,
                                  height:
                                      MediaQuery.of(context).size.height * .25,
                                  placeholder: 'images/blogger-saingtulum.png',
                                  image:
                                      snapshot.child('PImage').value.toString(),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              snapshot.child('PTitel').value.toString(),
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              snapshot.child('PDescription').value.toString(),
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.normal),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ))
          ],
        ),
      ),
    );
  }
}

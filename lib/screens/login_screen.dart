import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:project_flutter/components/round_bottom.dart';
import 'package:project_flutter/screens/Home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool ShowSpinnner = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String email = "", password = "";

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: ShowSpinnner,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: const Text('Login'),
          automaticallyImplyLeading: false,
          //backwordsCompatibility: false
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Login',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            hintText: 'Email',
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder()),
                        onChanged: (String Value) {
                          email = Value;
                        },
                        validator: (Value) {
                          return Value!.isEmpty ? 'enter email' : null;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: TextFormField(
                          controller: passwordController,
                          keyboardType: TextInputType.emailAddress,
                          obscureText: true,
                          decoration: const InputDecoration(
                              hintText: 'password',
                              labelText: 'password',
                              prefixIcon: Icon(Icons.lock),
                              border: OutlineInputBorder()),
                          onChanged: (String Value) {
                            password = Value;
                          },
                          validator: (Value) {
                            return Value!.isEmpty ? 'enter password' : null;
                          },
                        ),
                      ),
                      RoundButton(
                          title: 'Login',
                          color: Colors.indigo,
                          onPress: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                ShowSpinnner = true;
                              });
                              try {
                                final User =
                                    await _auth.signInWithEmailAndPassword(
                                        email: email.toString().trim(),
                                        password: password.toString().trim());

                                // ignore: unnecessary_null_comparison
                                if (User != null) {
                                  print('sucess');
                                  toastMessage('User successfully login');
                                  setState(() {
                                    ShowSpinnner = false;
                                  });
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const HomeScreen()));
                                }
                              } catch (e) {
                                print(e.toString());
                                toastMessage(e.toString());
                                setState(() {
                                  ShowSpinnner = false;
                                });
                              }
                            }
                          })
                    ],
                  ),
                ),
              )
            ],
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
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 16.0);
  }
}


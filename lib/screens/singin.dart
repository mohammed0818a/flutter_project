import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:project_flutter/components/round_bottom.dart';
import 'package:project_flutter/screens/Home_screen.dart';

class SingIn extends StatefulWidget {
  const SingIn({Key? key}) : super(key: key);

  @override
  State<SingIn> createState() => _SingInState();
}

class _SingInState extends State<SingIn> {
  FirebaseAuth _auth = FirebaseAuth.instance;
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
          title: const Text('Create Account'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Add Account',
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
                          title: 'Register',
                          color: Colors.indigo,
                          onPress: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                ShowSpinnner = true;
                              });
                              try {
                                final User =
                                    await _auth.createUserWithEmailAndPassword(
                                        email: email.toString().trim(),
                                        password: password.toString().trim());

                                if (User != null) {
                                  print('sucess');
                                  toastMessage('User successfully created');
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const HomeScreen()));
                                  setState(() {
                                    ShowSpinnner = false;
                                  });
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => LoginScreen()));
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
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}

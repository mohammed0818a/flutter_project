import 'package:flutter/material.dart';
import 'package:project_flutter/components/round_bottom.dart';
import 'package:project_flutter/screens/login_screen.dart';
import 'package:project_flutter/screens/singin.dart';

class OptionScreen extends StatefulWidget {
  const OptionScreen({super.key});

  @override
  State<OptionScreen> createState() => _OptionScreenState();
}

class _OptionScreenState extends State<OptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Image(image: AssetImage('images/blue_blogger.png')),
              const SizedBox(
                height: 30,
              ),
              RoundButton(
                title: 'Login',
                color: Colors.indigo,
                onPress: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()));
                },
              ),
              const SizedBox(
                height: 30,
              ),
              RoundButton(
                title: 'create Account',
                color: Colors.indigo,
                onPress: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const SingIn()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

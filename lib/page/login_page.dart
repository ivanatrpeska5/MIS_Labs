import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mis_labs/page/register_page.dart';

import '../auth/auth.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  static const String id = "loginPage";

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool hasError = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void signIn() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() => errorMessage = 'Please fill all input fields.');
      return;
    }

    try {
      await Auth()
          .signInWithEmailAndPassword(
          _emailController.text, _passwordController.text)
          .then((value) => {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => HomePage()))
      });
    } on FirebaseAuthException catch (e) {
      hasError = true;
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _title() => const Text('Exams');

  Widget _entryField(String title, TextEditingController controller,
      {bool isPassword = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 10),
          TextField(
            controller: controller,
            obscureText: isPassword,
            decoration: const InputDecoration(
                border: InputBorder.none,
                fillColor: Color(0xfff3f3f4),
                filled: true),
          )
        ],
      ),
    );
  }

  Widget _errorMessage() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      alignment: Alignment.center,
      child: Text(errorMessage!,
          style: const TextStyle(color: Colors.red, fontSize: 13)),
    );
  }

  Widget _submitButton() {
    return ElevatedButton(
        onPressed: signIn,
        child: const Text('Login', style: TextStyle(fontSize: 20)));
  }

  Widget _registerLink() {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          const TextSpan(
              text: "Don't have account? ", style: TextStyle(color: Colors.black)),
          TextSpan(
            text: 'Register here.',
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.deepPurpleAccent,
                decoration: TextDecoration.none),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterPage()));
              },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
          child: _title(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Login', style: TextStyle(fontSize: 30)),
              _entryField('E-mail', _emailController),
              _entryField('Password', _passwordController, isPassword: true),
              _errorMessage(),
              _submitButton(),
              const SizedBox(height: 20),
              _registerLink(),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/screens/auth_page.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool isChecked = true;

  void signUserUp() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => AuthPage(),
        ),
        (Route<dynamic> route) => false,
      );
    } on FirebaseException catch (e) {
      if (e.code == 'email-already-in-use') {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Email already in use"),
            );
          },
        );
      } else if (e.code == 'invalid-email') {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Invalid Email"),
            );
          },
        );
      } else if (e.code == 'weak-password') {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Password must be at least 6 characters"),
            );
          },
        );
      } else {
        // FirebaseAuth.instance.signOut();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              Image.asset(
                "lib/assets/carpool.png",
                height: 100,
                width: 100,
              ),
              const SizedBox(height: 10),
              const Text('Welcome!',
                  style: TextStyle(
                      fontSize: 45,
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text('We are happy to have you here'),
              const SizedBox(height: 20),
              Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: Form(
                      key: _formKey,
                      child: Column(children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Name',
                              hintText: 'Jacob Smith'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Email',
                              hintText: '****@eng.asu.edu.eg'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          obscureText: true,
                          controller: _passwordController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Password',
                              hintText: 'Invisibilty Cloak'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a valid Password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 5),
                        CheckboxListTile(
                            title: Text("Remember me",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w400)),
                            value: isChecked,
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked = value!;
                              });
                            }),
                        const SizedBox(height: 15),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(55),
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40))),
                            onPressed: () {
                              signUserUp();
                            },
                            child: const Text('Sign Up')),
                        const SizedBox(height: 15),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(55),
                                backgroundColor: Colors.grey[300],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40))),
                            onPressed: () {},
                            child: const Text('Sign Up with Google',
                                style: TextStyle(color: Colors.black))),
                        Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                                margin: const EdgeInsets.only(top: 20),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Do you have an account?",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.grey[600],
                                              fontWeight: FontWeight.w400)),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AuthPage(),
                                              ),
                                              (Route<dynamic> route) => false,
                                            );
                                          },
                                          child: const Text('Log In',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w400)))
                                    ])))
                      ]))),
            ])),
      ),
    );
  }
}

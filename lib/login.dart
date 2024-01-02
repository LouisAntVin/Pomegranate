import 'package:flutter/material.dart';
import 'package:pomegranate/Util/authentication.dart';
import 'package:pomegranate/branch.dart';
import 'package:pomegranate/signup.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF30303B),
      body: ListView(
        padding: EdgeInsets.all(8.0),
        children: <Widget>[
          SizedBox(height: 80),
          // logo
          Column(
            children: [
              Image.asset(
                'assets/images/pome logo.png',
                height: 200,
              ),
              const Text(
                'Welcome back!',
                style: TextStyle(fontSize: 38, color: Colors.redAccent),
              ),
            ],
          ),

          const SizedBox(
            height: 50,
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: LoginForm(),
          ),

          const SizedBox(height: 20),

          Row(
            children: <Widget>[
              const SizedBox(width: 30),
              const Text('New here ? ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.redAccent)),
              GestureDetector(
                onTap: () {
                  // Navigator.pushNamed(context, '/signup');
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Signup()));
                },
                child: const Text('Get Registered Now!!',
                    style: TextStyle(fontSize: 20, color: Colors.red)),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  String? email;
  String? password;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          // email
          TextFormField(
            // initialValue: 'Input text',
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelStyle: TextStyle(color: Colors.white),
              prefixIcon: Icon(Icons.email_outlined, color: Colors.white),
              labelText: 'Email',
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.redAccent, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.white, width: 0.5),
              ),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            onSaved: (val) {
              email = val;
            },
          ),
          const SizedBox(
            height: 20,
          ),

          // password
          TextFormField(
            // initialValue: 'Input text',
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelStyle: TextStyle(color: Colors.white),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.white, width: 0.5),
              ),
              labelText: 'Password',
              prefixIcon: Icon(Icons.lock_outline, color: Colors.white),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.redAccent, width: 2),
              ),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white),
              ),
            ),
            obscureText: _obscureText,
            onSaved: (val) {
              password = val;
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),

          SizedBox(height: 30),

          SizedBox(
            height: 54,
            width: 184,
            child: ElevatedButton(
              onPressed: () {
                // Respond to button press

                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  AuthenticationHelper()
                      .signIn(email: email!, password: password!)
                      .then((result) {
                    if (result == null) {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Branch()));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          result,
                          style: TextStyle(fontSize: 16),
                        ),
                      ));
                    }
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(24.0),
                  ),
                ),
              ),
              child: Text(
                'Login',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

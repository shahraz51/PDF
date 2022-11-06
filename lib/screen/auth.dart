import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class auth extends StatefulWidget {
  const auth({super.key});

  @override
  State<auth> createState() => _authState();
}

class _authState extends State<auth> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.chat,
                size: 150,
              ),
              Text(
                "Wechat",
                style: Theme.of(context).textTheme.headline1,
              ),
              const SizedBox(height: 20),
              form(),
              const SizedBox(height: 80),
              Text(
                "Made with ❤️ by shahraz",
                style: GoogleFonts.raleway(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class form extends StatefulWidget {
  @override
  State<form> createState() => _formState();
}

class _formState extends State<form> {
  final formkey = GlobalKey<FormState>();
  final confirm = TextEditingController();
  var email = "";
  var password = "";
  var islogin = true;
  void onsubmeted() async {
    if (formkey.currentState!.validate()) {
      formkey.currentState!.save();
      UserCredential auth;
      var errormsg = "";
      try {
        if (islogin) {
          auth = await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: email, password: password);
        } else {
          auth = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: email, password: password);
        }
      } on FirebaseAuthException catch (error) {
        errormsg = error.message.toString();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(errormsg)));
      } catch (error) {
        errormsg = "please check network ";
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(errormsg)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: 350,
      width: size.width * (0.8),
      child: Form(
          key: formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  label: const Text("Email"),
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "please enter email address";
                  }
                },
                onSaved: (newValue) {
                  email = newValue.toString();
                },
              ),
              TextFormField(
                controller: confirm,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  label: const Text("password"),
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "please enter password";
                  }
                },
                onSaved: (newValue) {
                  password = newValue.toString();
                },
              ),
              if (!islogin)
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    label: const Text("Confirm Password"),
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "please enter confirm password";
                      // ignore: unrelated_type_equality_checks
                    } else if (value != confirm.text) {
                      return "password not confirmed";
                    }
                    return null;
                  },
                ),
              ElevatedButton(
                  onPressed: () {
                    onsubmeted();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    fixedSize: const Size(300, 20),
                  ),
                  child: Text(islogin ? "Login" : "Sigin up")),
              TextButton(
                  onPressed: () {
                    setState(() {
                      islogin = !islogin;
                    });
                  },
                  child: Text(islogin ? "Or create an account" : "Log in"))
            ],
          )),
    );
  }
}

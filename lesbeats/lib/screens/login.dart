import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bi.dart';
import 'package:lesbeats/screens/forgotpassword.dart';
import 'package:lesbeats/screens/home/home.dart';
import 'package:lesbeats/screens/signup.dart';
import 'package:lesbeats/widgets/responsive.dart';
import 'package:wc_form_validators/wc_form_validators.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../main.dart';

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key});

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isLoggin = false;
  bool _obscureText = true;

  Future<String> login() async {
    setState(() {
      _isLoggin = true;
    });
    try {
      await auth.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);

      setState(() {
        _isLoggin = false;
      });
      return "Success";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.showSnackbar(const GetSnackBar(
          backgroundColor: Color(0xff264653),
          duration: Duration(seconds: 5),
          borderRadius: 30,
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          icon: Icon(
            Icons.error_outline,
            color: Colors.white,
          ),
          message: "There is no user corresponding this email",
        ));
      } else if (e.code == 'user-disabled') {
        Get.showSnackbar(const GetSnackBar(
          backgroundColor: Color(0xff264653),
          borderRadius: 30,
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          icon: Icon(
            Icons.error_outline,
            color: Colors.white,
          ),
          message: "This account has been diabled. Please contact support.",
        ));
      } else if (e.code == 'wrong-password') {
        Get.showSnackbar(const GetSnackBar(
          duration: Duration(seconds: 3),
          backgroundColor: Color(0xff264653),
          borderRadius: 30,
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          icon: Icon(
            Icons.error_outline,
            color: Colors.white,
          ),
          message: "Wrong password",
        ));
      } else {
        Get.showSnackbar(GetSnackBar(
          duration: const Duration(seconds: 3),
          backgroundColor: const Color(0xff264653),
          borderRadius: 30,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          icon: const Icon(
            Icons.error_outline,
            color: Colors.white,
          ),
          message: e.code,
        ));
      }
      setState(() {
        _isLoggin = false;
      });
    }

    return "";
  }

  Future<String> _googleSignin() async {
    setState(() {
      _isLoggin = true;
    });
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      setState(() {
        _isLoggin = false;
      });

      if (auth.currentUser != null) {
        final String photoUrl =
            await storage.ref("/users/placeholder.jpg").getDownloadURL();

        await auth.currentUser!.updatePhotoURL(photoUrl);
        final QuerySnapshot result = await db
            .collection('users')
            .where('uid', isEqualTo: auth.currentUser!.uid)
            .get();
        if (result.docs.isEmpty) {
          db.collection('users').doc(auth.currentUser!.uid).set({
            "uid": auth.currentUser!.uid,
            "full name": auth.currentUser!.displayName,
            "username": auth.currentUser!.displayName,
            "email": auth.currentUser!.email,
            "photoUrl": auth.currentUser!.photoURL,
            "isVerified": false,
            "created at": DateTime.now()
          });
        }
      }

      return "Success";
    } catch (e) {
      Get.showSnackbar(GetSnackBar(
        duration: const Duration(seconds: 3),
        backgroundColor: const Color(0xff264653),
        borderRadius: 30,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        icon: const Icon(
          Icons.error_outline,
          color: Colors.white,
        ),
        message: e.toString(),
      ));
    }

    setState(() {
      _isLoggin = false;
    });

    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Animate(
                    effects: const [FadeEffect(), SlideEffect()],
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 30),
                      height: Get.height * 0.4,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image:
                                  AssetImage("assets/images/wave-haikei.png"))),
                    ),
                  ),
                  Animate(
                    effects: const [SlideEffect()],
                    delay: 600.ms,
                    child: Image(
                        height: 200,
                        width: screenSize(context).width * 0.4,
                        image: const AssetImage("assets/images/lesbeats.png")),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    Animate(
                      effects: const [
                        FadeEffect(duration: Duration(seconds: 1)),
                      ],
                      delay: 800.ms,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 50,
                            child: TextFormField(
                              controller: _emailController,
                              validator: Validators.compose([
                                Validators.required('Email is required'),
                                Validators.email('Invalid email address'),
                              ]),
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(
                                    RegExp(r"\s\b|\b\s"))
                              ],
                              decoration: const InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black12),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                label: Text("Enter your email"),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Animate(
                      effects: const [FadeEffect(), SlideEffect()],
                      delay: 1000.ms,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 50,
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: _obscureText,
                              validator: Validators.compose([
                                Validators.required('Password is required'),
                              ]),
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _obscureText = !_obscureText;
                                      });
                                    },
                                    icon: Icon(_obscureText
                                        ? Icons.remove_red_eye_rounded
                                        : Icons.remove_red_eye_outlined)),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                enabledBorder: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black12),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                label: const Text("Enter your password"),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Animate(
                      effects: const [FadeEffect()],
                      delay: 1300.ms,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.to((() => const ForgotPassword()),
                                  transition: Transition.downToUp,
                                  duration: const Duration(milliseconds: 750));
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Forget password?",
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.blue),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Animate(
                      effects: const [FadeEffect(), SlideEffect()],
                      delay: 1600.ms,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              fixedSize: const Size.fromHeight(50),
                              elevation: 0,
                              backgroundColor: Theme.of(context).primaryColor),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              login().then((value) {
                                if (value == "Success") {
                                  Get.off(
                                    (() => const MyHomePage()),
                                  );
                                }
                              });
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _isLoggin
                                  ? const SizedBox(
                                      height: 16,
                                      width: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          Colors.white,
                                        ),
                                      ),
                                    )
                                  : const Text(
                                      "Login",
                                      style: TextStyle(fontSize: 18),
                                    )
                            ],
                          )),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Animate(
                effects: const [FadeEffect()],
                delay: 2000.ms,
                child: Column(
                  children: [
                    const Text("or login in using"),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Animate(
                          effects: const [FadeEffect()],
                          delay: const Duration(milliseconds: 1200),
                          child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                fixedSize: const Size(100, 40),
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                              ),
                              onPressed: () {
                                _googleSignin().then((value) {
                                  if (value == "Success") {
                                    Get.to(() => const MyHomePage());
                                  }
                                });
                              },
                              child: Iconify(
                                Bi.google,
                                color: Theme.of(context).primaryColor,
                              )),
                        ),
                        // Animate(
                        //   effects: const [FadeEffect()],
                        //   delay: const Duration(milliseconds: 1200),
                        //   child: OutlinedButton(
                        //       style: OutlinedButton.styleFrom(
                        //         fixedSize: const Size(100, 40),
                        //         shape: const RoundedRectangleBorder(
                        //             borderRadius:
                        //                 BorderRadius.all(Radius.circular(10))),
                        //       ),
                        //       onPressed: () {},
                        //       child: Iconify(
                        //         Bi.facebook,
                        //         color: Theme.of(context).primaryColor,
                        //       )),
                        // )
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Animate(
                effects: const [FadeEffect()],
                delay: 2300.ms,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    InkWell(
                      onTap: () {
                        Get.to(() => const MySignupPage(),
                            transition: Transition.downToUp,
                            duration: const Duration(seconds: 1));
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Signup",
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.blue),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

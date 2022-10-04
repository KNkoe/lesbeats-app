import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bi.dart';
import 'package:lesbeats/screens/home/home.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

import '../main.dart';

class MySignupPage extends StatefulWidget {
  const MySignupPage({super.key});

  @override
  State<MySignupPage> createState() => _MySignupPageState();
}

class _MySignupPageState extends State<MySignupPage> {
  final PageController _pageController = PageController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isRegistering = false;
  bool _obscureText = true;

  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _currentPage = 0;
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.toInt();
      });
    });
  }

  @override
  void dispose() {
    _confirmController.dispose();
    _passwordController.dispose();
    _pageController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Future<String> register() async {
    setState(() {
      _isRegistering = true;
    });
    try {
      UserCredential result = await auth.createUserWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);

      final userData = <String, dynamic>{
        "uid": result.user!.uid,
        "full name": _nameController.text,
        "username": _usernameController.text,
        "email": _emailController.text,
        "photoUrl": "gs://lesbeats-d6411.appspot.com/images/placeholder.png",
        "isVerified": false,
        "created at": DateTime.now()
      };

      User? user = result.user;

      if (user != null) {
        user.updateDisplayName(_usernameController.text);
        user.updatePhotoURL(
            "gs://lesbeats-d6411.appspot.com/images/placeholder.png");
        db.collection("users").doc(user.uid).set(userData);
      }

      setState(() {
        _isRegistering = false;
      });
      return "Success";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Get.showSnackbar(const GetSnackBar(
          duration: Duration(seconds: 3),
          backgroundColor: Color(0xff264653),
          borderRadius: 30,
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          icon: Icon(
            Icons.error_outline,
            color: Colors.white,
          ),
          message: "Please provide a stronger password",
        ));
      } else if (e.code == 'email-already-in-use') {
        Get.showSnackbar(const GetSnackBar(
          duration: Duration(seconds: 3),
          backgroundColor: Color(0xff264653),
          borderRadius: 30,
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          icon: Icon(
            Icons.error_outline,
            color: Colors.white,
          ),
          message: "An account already exists for that email.",
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
        _isRegistering = false;
      });
    }

    return "";
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SmoothPageIndicator(
                      controller: _pageController,
                      count: 2,
                      onDotClicked: ((index) => _pageController.animateToPage(
                          index,
                          duration: const Duration(seconds: 1),
                          curve: Curves.ease)),
                      effect: SlideEffect(
                          spacing: 20,
                          radius: 4.0,
                          dotWidth: 24.0,
                          dotHeight: 16.0,
                          paintStyle: PaintingStyle.stroke,
                          strokeWidth: 1.5,
                          dotColor: Colors.black12,
                          activeDotColor: Theme.of(context).primaryColor)),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    "Sign up for free!",
                    style: TextStyle(fontSize: 20, color: Colors.black54),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: Get.height * 0.3,
                    child: PageView(
                      controller: _pageController,
                      allowImplicitScrolling: false,
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 50,
                                child: TextFormField(
                                  keyboardType: TextInputType.name,
                                  validator: (value) => value!.isEmpty
                                      ? "Please enter your full name"
                                      : null,
                                  controller: _nameController,
                                  decoration: const InputDecoration(
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black12),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    label: Text("Enter your full name"),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                height: 50,
                                child: TextFormField(
                                  keyboardType: TextInputType.name,
                                  validator: Validators.compose([
                                    (value) => value!.isEmpty
                                        ? "Please enter your username"
                                        : null,
                                    (value) => value!.contains(" ")
                                        ? "User name must not contain spaces"
                                        : null
                                  ]),
                                  controller: _usernameController,
                                  decoration: const InputDecoration(
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black12),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    label: Text("Enter your username"),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                height: 50,
                                child: TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _emailController,
                                  validator: Validators.compose([
                                    Validators.required(
                                        'Please enter your email'),
                                    Validators.email('Invalid email address'),
                                  ]),
                                  decoration: const InputDecoration(
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black12),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    label: Text("Enter your email"),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  SizedBox(
                                    height: 50,
                                    child: TextFormField(
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      validator: Validators.compose([
                                        Validators.required(
                                            'Please enter your password'),
                                        Validators.minLength(
                                            6, "Password too short")
                                      ]),
                                      obscureText: _obscureText,
                                      controller: _passwordController,
                                      decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                _obscureText = !_obscureText;
                                              });
                                            },
                                            icon: Icon(_obscureText
                                                ? Icons.remove_red_eye_rounded
                                                : Icons
                                                    .remove_red_eye_outlined)),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never,
                                        enabledBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black12),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        label:
                                            const Text("Enter your password"),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  SizedBox(
                                    height: 50,
                                    child: TextFormField(
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      validator: Validators.compose([
                                        ((value) =>
                                            value != _passwordController.text
                                                ? "Passwords to not match"
                                                : null),
                                        Validators.required(
                                            'Please confirm your password'),
                                        Validators.minLength(
                                            6, "Password too short")
                                      ]),
                                      obscureText: _obscureText,
                                      controller: _confirmController,
                                      decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                _obscureText = !_obscureText;
                                              });
                                            },
                                            icon: Icon(_obscureText
                                                ? Icons.remove_red_eye_rounded
                                                : Icons
                                                    .remove_red_eye_outlined)),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never,
                                        enabledBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black12),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        label:
                                            const Text("Confirm your password"),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              OutlinedButton.icon(
                                  icon: Icon(
                                    Icons.arrow_back,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    fixedSize: Size(Get.width, 50),
                                    elevation: 0,
                                  ),
                                  onPressed: () {
                                    _pageController.previousPage(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        curve: Curves.ease);
                                  },
                                  label: Text(
                                    "Back",
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 20),
                    child: Column(
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                fixedSize: const Size.fromHeight(50),
                                elevation: 0,
                                backgroundColor:
                                    Theme.of(context).primaryColor),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                if (_currentPage == 0) {
                                  _pageController.nextPage(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.ease);
                                } else if (_currentPage == 1) {
                                  register().then((value) {
                                    if (value == "Success") {
                                      Get.showSnackbar(const GetSnackBar(
                                        duration: Duration(seconds: 3),
                                        backgroundColor: Color(0xff264653),
                                        borderRadius: 30,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 30),
                                        icon: Icon(
                                          Icons.check,
                                          color: Colors.white,
                                        ),
                                        message: "Welcome",
                                      ));
                                      Get.to(() => const MyHomePage());
                                    }
                                  });
                                }
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _isRegistering
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
                                    : Text(
                                        _currentPage == 0
                                            ? "Continue"
                                            : "Register",
                                        style: const TextStyle(fontSize: 18),
                                      )
                              ],
                            )),
                        const SizedBox(
                          height: 30,
                        ),
                        Column(
                          children: [
                            const Text("or register in using"),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                OutlinedButton(
                                    style: ButtonStyle(
                                      fixedSize: MaterialStateProperty.all(
                                          const Size(100, 40)),
                                      shape: MaterialStateProperty.all(
                                          const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)))),
                                    ),
                                    onPressed: () {},
                                    child: Iconify(
                                      Bi.google,
                                      color: Theme.of(context).primaryColor,
                                    )),
                                OutlinedButton(
                                    style: ButtonStyle(
                                      fixedSize: MaterialStateProperty.all(
                                          const Size(100, 40)),
                                      shape: MaterialStateProperty.all(
                                          const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)))),
                                    ),
                                    onPressed: () {},
                                    child: Iconify(
                                      Bi.facebook,
                                      color: Theme.of(context).primaryColor,
                                    ))
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Already have an account? "),
                            InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.blue),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

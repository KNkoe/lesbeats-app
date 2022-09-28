import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bi.dart';
import 'package:lesbeats/screens/forgotpassword.dart';
import 'package:lesbeats/screens/home/home.dart';
import 'package:lesbeats/screens/signup.dart';
import 'package:lesbeats/widgets/theme.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

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
              Animate(
                effects: const [FadeEffect(), SlideEffect()],
                delay: 1000.ms,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 30),
                  height: Get.height * 0.2,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(100))),
                  child: Image(
                      height: 400,
                      width: Get.width * 0.6,
                      image: const AssetImage("assets/images/lesbeats.png")),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    Animate(
                      effects: const [
                        FadeEffect(duration: Duration(seconds: 1)),
                      ],
                      delay: 1300.ms,
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
                      delay: 1500.ms,
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
                      delay: 1800.ms,
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
                      delay: 2000.ms,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              fixedSize: const Size.fromHeight(50),
                              elevation: 0,
                              backgroundColor: Theme.of(context).cardColor),
                          onPressed: () async {
                            Get.off(
                              (() => const MyHomePage()),
                            );
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
                delay: 2300.ms,
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
                                color: Theme.of(context).cardColor,
                              )),
                        ),
                        Animate(
                          effects: const [FadeEffect()],
                          delay: const Duration(milliseconds: 1200),
                          child: OutlinedButton(
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
                                color: Theme.of(context).cardColor,
                              )),
                        )
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
                            transition: Transition.rightToLeft,
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

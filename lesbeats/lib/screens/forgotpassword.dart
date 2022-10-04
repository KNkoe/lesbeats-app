import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lesbeats/main.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isSubmitting = false;

  Future<String> resetPassword() async {
    setState(() {
      _isSubmitting = true;
    });
    try {
      await auth.sendPasswordResetEmail(email: _emailController.text);

      setState(() {
        _isSubmitting = false;
      });

      return "Success";
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        Get.showSnackbar(const GetSnackBar(
          duration: Duration(seconds: 3),
          backgroundColor: Color(0xff264653),
          borderRadius: 30,
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          icon: Icon(
            Icons.error_outline,
            color: Colors.white,
          ),
          message: "There is no user corresponding this email",
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
        _isSubmitting = false;
      });
    }

    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black54,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Password Reset",
                style: TextStyle(fontSize: 20, color: Colors.black54),
              ),
              const SizedBox(
                height: 30,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Email"),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 50,
                    child: TextFormField(
                      validator: Validators.compose([
                        Validators.required('Email is required'),
                        Validators.email('Invalid email address'),
                      ]),
                      controller: _emailController,
                      decoration: const InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black12),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        label: Text("Enter your email"),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      fixedSize: const Size.fromHeight(50),
                      elevation: 0,
                      backgroundColor: Theme.of(context).primaryColor),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      resetPassword().then((value) {
                        if (value == "Success") {
                          debugPrint("Print fail");

                          Get.showSnackbar(const GetSnackBar(
                            backgroundColor: Color(0xff264653),
                            borderRadius: 30,
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 30),
                            icon: Icon(
                              Icons.check,
                              color: Colors.white,
                            ),
                            title: "Password reset link sent",
                            message: "Please check your email",
                          ));
                        }
                      });
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _isSubmitting
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text(
                              "Submit",
                              style: TextStyle(fontSize: 18),
                            )
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

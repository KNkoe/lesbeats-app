import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
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
                      setState(() {
                        _isSubmitting = true;
                      });

                      setState(() {
                        _isSubmitting = false;
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

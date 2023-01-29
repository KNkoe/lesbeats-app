import "package:flutter/material.dart";
import 'package:lesbeats/main.dart';
import 'package:lesbeats/services/payment.dart';
import 'package:lesbeats/widgets/format.dart';
import 'package:lesbeats/widgets/responsive.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

showcheckout(BuildContext context, String title, double price, String id,
    String uid, String producer) {
  showBottomSheet(
      context: context,
      builder: ((context) => CheckOutScreen(
            id: id,
            uid: uid,
            price: price,
            title: title,
            producer: producer,
          )));
}

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen(
      {super.key,
      required this.id,
      required this.price,
      required this.uid,
      required this.title,
      required this.producer});
  final String id;
  final String uid;
  final String title;
  final double price;
  final String producer;

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  bool _isCollapsed = false;
  bool _isOTPsent = false;
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: (!_isCollapsed)
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                      const Text("Payment method"),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _isCollapsed = true;
                          });
                        },
                        child: Container(
                            height: 60,
                            width: screenSize(context).width * 0.8,
                            decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                    transform: GradientRotation(2.53073),
                                    colors: [
                                      Color(0xffcacaca),
                                      Color(0xfff0f0f0)
                                    ]),
                                borderRadius: BorderRadius.circular(50),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Color(0xffbebebe),
                                      offset: Offset(20, 20),
                                      blurRadius: 60),
                                  BoxShadow(
                                      color: Color(0xffffffff),
                                      offset: Offset(-20, -20),
                                      blurRadius: 60)
                                ]),
                            child: Image.asset("assets/images/chapreone.png")),
                      ),
                      const SizedBox(),
                    ])
              : Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.clear))
                        ],
                      ),
                      Column(
                        children: [
                          const Text("Payment information"),
                          const SizedBox(
                            height: 40,
                          ),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Title: ",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    widget.title,
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Producer: ",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    widget.producer,
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Price: ",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "M ${widget.price}",
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  )
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          (!_isOTPsent)
                              ? SizedBox(
                                  height: 50,
                                  width: screenSize(context).width * 0.8,
                                  child: TextFormField(
                                    keyboardType: TextInputType.phone,
                                    validator: Validators.compose([
                                      Validators.required(
                                          "Please enter your mobile number"),
                                      (value) => value!.length < 8
                                          ? "Please enter a valid phone numer"
                                          : null
                                    ]),
                                    controller: _phoneNumberController,
                                    decoration: const InputDecoration(
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never,
                                      enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black12),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      label: Text("Enter your phone number"),
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  height: 50,
                                  width: screenSize(context).width * 0.8,
                                  child: TextFormField(
                                    keyboardType: TextInputType.phone,
                                    validator: Validators.compose([
                                      Validators.required("Please enter OTP"),
                                    ]),
                                    controller: _otpController,
                                    decoration: const InputDecoration(
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never,
                                      enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black12),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      label: Text("Enter OTP"),
                                    ),
                                  ),
                                ),
                          const SizedBox(
                            height: 40,
                          ),
                          if (_isOTPsent)
                            OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                    foregroundColor:
                                        Theme.of(context).primaryColor,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    fixedSize: Size(
                                        screenSize(context).width * 0.8, 50)),
                                onPressed: () {
                                  setState(() {
                                    _isOTPsent = false;
                                  });
                                },
                                icon: const Icon(Icons.arrow_back),
                                label: const Text("Back")),
                          const SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  fixedSize: Size(
                                      screenSize(context).width * 0.8, 50)),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    String apiKey = "";
                                    String clientSecret = "";
                                    await db
                                        .collection("miscellaneous")
                                        .doc("AQmd8k0dJdqDmliNYBa1")
                                        .get()
                                        .then((value) {
                                      apiKey = value.get("api_key");
                                      clientSecret = value.get("client_secret");
                                    });

                                    PaymentAPI paymentAPI =
                                        PaymentAPI(apiKey, clientSecret);

                                    paymentAPI.generateChecksum(
                                        generateRandomString(8),
                                        auth.currentUser!.uid,
                                        widget.price,
                                        _phoneNumberController.text);
                                  } catch (e) {
                                    debugPrint(e.toString());
                                  }
                                }
                              },
                              child: const Text("Send OTP")),
                          if (_isOTPsent)
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    fixedSize: Size(
                                        screenSize(context).width * 0.8, 50)),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {}
                                },
                                child: const Text("Checkout"))
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                )),
    );
  }
}

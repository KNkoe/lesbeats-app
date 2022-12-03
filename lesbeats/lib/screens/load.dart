import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

class MyLoadingPage extends StatefulWidget {
  const MyLoadingPage({super.key});

  @override
  State<MyLoadingPage> createState() => _MyLoadingPageState();
}

class _MyLoadingPageState extends State<MyLoadingPage> {
  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: const [ShimmerEffect(duration: Duration(seconds: 1))],
      onComplete: ((controller) {
        controller.repeat();
      }),
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 30,
                width: 50,
                decoration: const BoxDecoration(
                    color: Colors.black12, shape: BoxShape.circle),
              ),
              const SizedBox(
                width: 20,
              ),
              Container(
                height: 30,
                width: Get.width * 0.6,
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(20)),
              )
            ],
          ),
          SizedBox(
            height: Get.height * 0.2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 30,
                width: 40,
                decoration: const BoxDecoration(
                    color: Colors.black12, shape: BoxShape.rectangle),
              ),
              const SizedBox(
                width: 20,
              ),
              Container(
                height: 30,
                width: Get.width * 0.6,
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(20)),
              )
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 30,
                width: 40,
                decoration: const BoxDecoration(
                    color: Colors.black12, shape: BoxShape.circle),
              ),
              const SizedBox(
                width: 20,
              ),
              Container(
                height: 30,
                width: Get.width * 0.6,
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(20)),
              )
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 30,
                width: 40,
                decoration: const BoxDecoration(
                    color: Colors.black12, shape: BoxShape.circle),
              ),
              const SizedBox(
                width: 20,
              ),
              Container(
                height: 30,
                width: Get.width * 0.6,
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(20)),
              )
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 30,
                width: 40,
                decoration: const BoxDecoration(
                    color: Colors.black12, shape: BoxShape.circle),
              ),
              const SizedBox(
                width: 20,
              ),
              Container(
                height: 30,
                width: Get.width * 0.6,
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(20)),
              )
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 30,
                width: 40,
                decoration: const BoxDecoration(
                    color: Colors.black12, shape: BoxShape.circle),
              ),
              const SizedBox(
                width: 20,
              ),
              Container(
                height: 30,
                width: Get.width * 0.6,
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(20)),
              )
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 30,
                width: 40,
                decoration: const BoxDecoration(
                    color: Colors.black12, shape: BoxShape.circle),
              ),
              const SizedBox(
                width: 20,
              ),
              Container(
                height: 30,
                width: Get.width * 0.6,
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(20)),
              )
            ],
          ),
        ],
      ),
    );
  }
}

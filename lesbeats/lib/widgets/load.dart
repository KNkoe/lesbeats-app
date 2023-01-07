import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'responsive.dart';

class LoadTrack extends StatelessWidget {
  const LoadTrack({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Animate(
          effects: const [ShimmerEffect(duration: Duration(seconds: 1))],
          onComplete: ((controller) {
            controller.repeat();
          }),
          child: Row(
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
                width: screenSize(context).width * 0.6,
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(20)),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ChatLoading extends StatelessWidget {
  const ChatLoading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Animate(
          effects: const [ShimmerEffect(duration: Duration(seconds: 1))],
          onComplete: ((controller) {
            controller.repeat();
          }),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 20,
                    width: 20,
                    decoration: const BoxDecoration(
                        color: Colors.black12, shape: BoxShape.circle),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Container(
                    height: 20,
                    width: screenSize(context).width * 0.8,
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(20)),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 8,
                width: screenSize(context).width * 0.3,
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(20)),
              )
            ],
          ),
        ),
      ),
    );
  }
}

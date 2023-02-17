import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../widgets/responsive.dart';

class Load extends StatelessWidget {
  const Load({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [1, 1, 1, 1]
                .map((e) => Padding(
                      padding: const EdgeInsets.all(20),
                      child: Animate(
                        effects: const [
                          ShimmerEffect(duration: Duration(seconds: 1))
                        ],
                        onComplete: ((controller) {
                          controller.repeat();
                        }),
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: const BoxDecoration(
                              color: Colors.black12, shape: BoxShape.circle),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [1, 1, 1, 1, 1]
              .map((e) => Padding(
                    padding: const EdgeInsets.all(20),
                    child: Animate(
                      effects: const [
                        ShimmerEffect(duration: Duration(seconds: 1))
                      ],
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
                  ))
              .toList(),
        ),
      ],
    );
  }
}

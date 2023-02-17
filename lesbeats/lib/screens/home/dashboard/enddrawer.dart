import 'package:flutter/material.dart';
import 'package:lesbeats/widgets/responsive.dart';

class CustomEndDrawer extends StatefulWidget {
  const CustomEndDrawer({
    Key? key,
  }) : super(key: key);

  @override
  State<CustomEndDrawer> createState() => _CustomEndDrawerState();
}

class _CustomEndDrawerState extends State<CustomEndDrawer> {
  double minprice = 0;
  double maxprice = 1000;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: screenSize(context).width * 0.5,
      elevation: 0,
      child: Column(
        children: [
          DrawerHeader(
              child: Text(
            "Filter by",
            style: Theme.of(context).textTheme.headline6,
          )),
          Column(
            children: [
              Text(
                "Price",
                style: Theme.of(context).textTheme.subtitle1,
              ),
              RangeSlider(
                labels: RangeLabels(minprice.toString(), maxprice.toString()),
                divisions: 1000,
                max: 1000,
                onChanged: ((value) {
                  setState(() {
                    minprice = value.start;
                    maxprice = value.end;
                  });
                }),
                values: RangeValues(minprice, maxprice),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [Text("Free"), Text("R1000")],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

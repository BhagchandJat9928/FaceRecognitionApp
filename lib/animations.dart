import 'package:flutter/material.dart';

class Animations extends StatefulWidget {
  const Animations({Key? key}) : super(key: key);

  @override
  State<Animations> createState() => _AnimationsState();
}

class _AnimationsState extends State<Animations> {
  var toggle = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 20),
            decoration: BoxDecoration(
                color: toggle ? Colors.blue : Colors.red,
                border: Border.all(
                    width: 1, color: Colors.green, style: BorderStyle.solid),
                borderRadius: BorderRadius.all(Radius.circular(11))),
            curve: Curves.easeInCirc,
            height: toggle ? 100 : 40,
            width: toggle ? 100 : 40,
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  toggle = !toggle;
                });
              },
              child: Text("Change Size"))
        ],
      ),
    );
  }
}

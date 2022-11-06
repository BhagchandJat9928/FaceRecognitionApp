import 'package:flutter/material.dart';

class NewList extends StatefulWidget {
  const NewList({Key? key, required this.list}) : super(key: key);
  final List<dynamic> list;
  @override
  State<NewList> createState() => _NewListState(list);
}

class _NewListState extends State<NewList> {
  List<dynamic> list = [];
  _NewListState(this.list);

  @override
  Widget build(BuildContext context) {
    print(list.length);
    return list.isEmpty
        ? Container(
            color: Colors.white70,
            child: Center(
              child: const CircularProgressIndicator(),
            ),
          )
        : ListView.builder(
            scrollDirection: Axis.vertical,
            physics: PageScrollPhysics(),
            itemCount: list.length,
            itemBuilder: (context, position) {
              return Image(
                image: list.elementAt(position),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * .40,
              );
            });
  }
}

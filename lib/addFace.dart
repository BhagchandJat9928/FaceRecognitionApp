import 'dart:convert';

import 'package:demoproject/addImages.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddFace extends StatefulWidget {
  const AddFace({Key? key}) : super(key: key);

  @override
  State<AddFace> createState() => _AddFaceState();
}

class _AddFaceState extends State<AddFace> {
  var controller = TextEditingController();
  var idcontroller = TextEditingController();
  var emailcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        margin: EdgeInsets.symmetric(horizontal: 10),
        semanticContainer: false,
        color: Colors.lightBlue,
        shadowColor: Colors.purple,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                  labelText: "Name",
                  fillColor: Colors.green,
                  alignLabelWithHint: true,
                  hintText: "Enter your Name",
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.black,
                          width: 1,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
              keyboardType: TextInputType.text,
              autofocus: false,
              autocorrect: true,
              style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
              controller: emailcontroller,
              decoration: const InputDecoration(
                  labelText: "Email",
                  fillColor: Colors.green,
                  alignLabelWithHint: true,
                  hintText: "Enter your Email",
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.black,
                          width: 1,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
              controller: idcontroller,
              decoration: const InputDecoration(
                  labelText: "Id",
                  fillColor: Colors.green,
                  alignLabelWithHint: true,
                  hintText: "Enter your Id",
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.black,
                          width: 1,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () async {
                  var name = controller.value.text;
                  var email = emailcontroller.value.text;
                  var id = idcontroller.value.text;
                  //   User user = User(id, name, email, false);

                  final http.Response response = await http.post(
                      Uri.parse(
                          "https://springmongo.azurewebsites.net/adduser"),
                      headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                      },
                      body: jsonEncode(<String, String>{
                        "id": id,
                        "name": name,
                        "email": email,
                        "active": false.toString()
                      }));

                  print(response.statusCode);
                  if (response.statusCode == 200) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const AddImages()));
                  }
                },
                child: Text("Add"))
          ],
        ),
      ),
    );
  }
}

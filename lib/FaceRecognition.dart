import 'dart:convert';

import 'package:demoproject/present.dart';
import 'package:demoproject/user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'addImages.dart';

class FaceRecognition extends StatefulWidget {
  const FaceRecognition({Key? key}) : super(key: key);

  @override
  State<FaceRecognition> createState() => _FaceRecognitionState();
}

class _FaceRecognitionState extends State<FaceRecognition> {
  List<TableRow> list = [
    const TableRow(children: [Text("Name"), Text("Id"), Text("Time")])
  ];
  late dynamic userlist;

  List<User> listus = [User("Id", "Name", "Email", true)];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    userlist = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      userlist = fetchData();
    });
    /* GifImage image = GifImage(
      image: NetworkImage(
          'https://cutewallpaper.org/21/1920-x-1080-gif/1920x1080-Wallpapercartoon-Wallpapers-Driverlayer-Search-.gif'),
      controller: gifController,
    );*/

    return Scaffold(
      appBar: AppBar(
        title: Text("Face Recognition"),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Colors.green,
        ),
        child: Flex(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          direction: Axis.vertical,
          children: [
            Flexible(
              fit: FlexFit.loose,
              child: Stack(
                fit: StackFit.loose,
                children: [
                  Positioned(
                      top: 100,
                      left: 40,
                      right: 210,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      Present(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                const begin = Offset(0.0, 1.0);
                                const end = Offset.zero;
                                final tween = Tween(begin: begin, end: end);

                                const curve = Curves.easeInOutCubic;
                                final curveAnimation = CurvedAnimation(
                                    parent: animation, curve: curve);
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              }));
                        },
                        child: Text("Present"),
                      )),
                  Positioned(
                      top: 100,
                      left: 200,
                      right: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const AddImages(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                const begin = Offset(0.0, 1.0);
                                const end = Offset.zero;
                                final tween = Tween(begin: begin, end: end);

                                const curve = Curves.easeInOutCubic;
                                final curveAnimation = CurvedAnimation(
                                    parent: animation, curve: curve);
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              }));
                        },
                        child: Text("Add User"),
                      )),
                ],
              ),
            ),
            const Flexible(
              fit: FlexFit.loose,
              child: Divider(
                thickness: 2,
                height: 5,
                color: Colors.black,
                indent: 3,
              ),
            ),
            Flexible(
              fit: FlexFit.loose,
              /*child: Table(
                defaultColumnWidth: const FlexColumnWidth(double.minPositive),
                children: list.map((e) => e).toList(),
                border: TableBorder.all(
                    color: Colors.green,
                    width: 1,
                    style: BorderStyle.solid,
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
              ),*/
              child: FutureBuilder<List<User>>(
                future: userlist,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    print(snapshot.data);

                    return ListView.separated(
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Text(snapshot.data!.elementAt(index).id),
                            title: Text(snapshot.data!.elementAt(index).name),
                            trailing:
                                Text(snapshot.data!.elementAt(index).email),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Divider(
                            height: 1,
                            thickness: 1,
                            color: Colors.green,
                          );
                        },
                        itemCount: snapshot.data!.length);

                    /* StreamBuilder(
                stream: json.decode(http
                    .get(Uri.parse('https://springmongo.azurewebsites.net/'))
                    .toString()),
                builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.hasData) {
                    Map<String, dynamic> map = snapshot.data!.elementAt(0);
                    User user = User.fromJson(map);
                    print(user);

                    return Container(
                      child: Text(user.email),
                    );*/
                    /*Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(snapshot.data!.id),
                        SizedBox(
                          width: 2,
                        ),
                        Text(snapshot.data!.name),
                        SizedBox(
                          width: 2,
                        ),
                        Text(snapshot.data!.email),
                        SizedBox(
                          width: 2,
                        ),
                      ],
                    );*/
                  } else if (snapshot.hasError) {
                    print(snapshot.error);
                    return Column(
                      children: [
                        Text('${snapshot.error}'),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                userlist = fetchData();
                              });
                            },
                            child: Text("Reload"))
                      ],
                    );
                  }

                  // By default, show a loading spinner.
                  return const CircularProgressIndicator();
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<List<User>> fetchData() async {
    final response =
        await http.get(Uri.parse('https://springmongo.azurewebsites.net/'));

    print(
        "${response.statusCode} data  ${response.body.length}  list ${listus.toString().length}");

    if (response.statusCode == 200) {
      listus = [User("Id", "Name", "Email", true)];

      List<dynamic> values = await json.decode((response.body));
      for (dynamic val in values) {
        Map<String, dynamic> map = val;
        listus.add(User.fromJson(map));
      }

      return listus;
    } else {
      throw Exception('Failed to load album');
    }
  }
}

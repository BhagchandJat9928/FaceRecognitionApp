import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var current = 0;
  double top = 10;
  double bottom = 5;
  List<Image> list = [
    Image.network(
      "https://thumbs.dreamstime.com/z/beautiful-rain-forest-ang-ka-nature-trail-doi-inthanon-national-park-thailand-36703721.jpg",
      fit: BoxFit.cover,
    ),
    Image.network(
      "https://thumbs.dreamstime.com/z/tiger-isolated-white-clipping-path-32370986.jpg",
      fit: BoxFit.cover,
    ),
    Image.network(
      "https://thumbs.dreamstime.com/z/heo-suwat-waterfall-cave-khao-yai-national-park-thailand-45585881.jpg",
      fit: BoxFit.cover,
    ),
    Image.network(
      "https://thumbs.dreamstime.com/b/waterfall-landscape-background-beautiful-nature-outdoor-photography-thailand-green-rain-forest-jungle-trees-bushes-fresh-42009143.jpg",
      fit: BoxFit.cover,
    ),
    Image.network(
      "https://thumbs.dreamstime.com/b/vaioaga-waterfall-la-beusnita-national-park-romania-31453358.jpg",
      fit: BoxFit.cover,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello'),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  CircleAvatar(
                    backgroundColor: Colors.red,
                    maxRadius: 40,
                    minRadius: 30,
                    child: Image(
                      image: AssetImage('login.jpg'),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Hello world")
                ],
              ),
            ),
            ListTile(
              title: const Text("hellow riir"),
              tileColor: Colors.blueAccent,
            )
          ],
        ),
      ),
      body: current == 0 || current == 2
          ? SingleChildScrollView(
              child: Column(
                children: [
                  Home(),
                  CarouselSlider(
                      items: list.map((e) {
                        return Container(
                          child: e,
                        );
                      }).toList(),
                      options: CarouselOptions(
                        aspectRatio: 2.0,
                        initialPage: 0,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        autoPlayInterval: Duration(seconds: 3),
                        scrollDirection: Axis.horizontal,
                      )),
                  SizedBox(height: 5),
                  ImageSlideshow(
                      indicatorColor: Colors.red,
                      isLoop: true,
                      autoPlayInterval: 1000,
                      children: list.map((e) => e).toList()),
                ],
              ),
            )
          : Shop(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.red,
        iconSize: 30,
        selectedItemColor: Colors.pink,
        currentIndex: current,
        onTap: (position) {
          setState(() {
            current = position;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.red,
            ),
            label: "home",
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.shop,
                color: Colors.purple,
              ),
              label: "shop"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.grade,
                color: Colors.red,
              ),
              label: "star"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.help,
                color: Colors.orange,
              ),
              label: "Help"),
        ],
      ),
    );
  }

  Widget Home() {
    return Container(
      child: Center(
        child: const Text('Home'),
      ),
      color: Colors.blue,
    );
  }

  Widget Shop() {
    return Container(
      child: Center(
        child: const Text('Home'),
      ),
      color: Colors.purple,
    );
  }
}

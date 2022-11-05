import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:demoproject/FaceRecognition.dart';
import 'package:demoproject/main.dart';
import 'package:demoproject/permissionhandle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as imageLib;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class AddImages extends StatefulWidget {
  const AddImages({Key? key}) : super(key: key);

  @override
  State<AddImages> createState() => _AddImagesState();
}

class _AddImagesState extends State<AddImages> {
  XFile? imageFile;
  bool isPermissioned = false;
  bool storage = false;
  CameraController cameraController =
      CameraController(cameras[1], ResolutionPreset.max);
  List<Uint8List> list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    permission();
    cameraController.initialize().asStream();
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      print(cameraController.value.isInitialized);
    });

    cameraController.value.isInitialized
        ? cameraController.startImageStream((image) => savePicture(image))
        : cameraController.initialize().then((value) {
            cameraController.startImageStream((image) => savePicture(image));
          });
    cameraController.lockCaptureOrientation(DeviceOrientation.portraitUp);

    Future.delayed(Duration(seconds: 10)).then((value) {
      cameraController.value.isInitialized
          ? cameraController.stopImageStream()
          : null;

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => FaceRecognition()));
    });

    return cameraController.value.isInitialized
        ? MaterialApp(
            home: CameraPreview(
            cameraController,
            child: Icon(Icons.camera),
          ))
        : Container(
            color: Colors.white,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  cameraController.initialize().asStream();
                },
                child: Text("Initialize"),
              ),
            ));
  }

  Future<void> permission() async {
    PermissionHandle handle = PermissionHandle(Permission.camera);
    PermissionHandle st = PermissionHandle(Permission.manageExternalStorage);
    if (await handle.checkPermission()) {
      setState(() {
        isPermissioned = true;
      });
    } else {
      setState(() {
        isPermissioned = false;
      });
    }

    if (await st.checkPermission()) {
      setState(() {
        storage = true;
      });
    } else {
      setState(() {
        storage = false;
      });
    }
  }

  Future<void> savePicture(CameraImage image) async {
    imageLib.Image img = ImageUtils().convertYUV420ToImage(image);
    list.add(img.getBytes(format: imageLib.Format.rgba));

    print("$img  ravan");
    try {
      Directory? directory = await getExternalStorageDirectory();
      print(directory?.path);
      Directory dir = Directory("${directory!.path}/images_and");

      File file = File("${dir.path}/$img");

      file.writeAsBytes(img.getBytes(format: imageLib.Format.rgba));
      print(file.path);
    } on CameraException catch (e) {
      print(e.toString());
      return;
    }
  }
}

class ImageUtils {
  /// Converts a [CameraImage] in YUV420 format to [imageLib.Image] in RGB format
  imageLib.Image convertYUV420ToImage(CameraImage cameraImage) {
    final int width = cameraImage.width;
    final int height = cameraImage.height;

    final int uvRowStride = cameraImage.planes[1].bytesPerRow;
    final int? uvPixelStride = cameraImage.planes[1].bytesPerPixel;

    final image = imageLib.Image(width, height);

    for (int w = 0; w < width; w++) {
      for (int h = 0; h < height; h++) {
        final int uvIndex =
            uvPixelStride! * (w / 2).floor() + uvRowStride * (h / 2).floor();
        final int index = h * width + w;

        final y = cameraImage.planes[0].bytes[index];
        final u = cameraImage.planes[1].bytes[uvIndex];
        final v = cameraImage.planes[2].bytes[uvIndex];

        image.data[index] = ImageUtils().yuv2rgb(y, u, v);
      }
    }
    return image;
  }

  /// Convert a single YUV pixel to RGB
  int yuv2rgb(int y, int u, int v) {
    // Convert yuv pixel to rgb
    int r = (y + v * 1436 / 1024 - 179).round();
    int g = (y - u * 46549 / 131072 + 44 - v * 93604 / 131072 + 91).round();
    int b = (y + u * 1814 / 1024 - 227).round();

    // Clipping RGB values to be inside boundaries [ 0 , 255 ]
    r = r.clamp(0, 255);
    g = g.clamp(0, 255);
    b = b.clamp(0, 255);

    return 0xff000000 |
        ((b << 16) & 0xff0000) |
        ((g << 8) & 0xff00) |
        (r & 0xff);
  }
}

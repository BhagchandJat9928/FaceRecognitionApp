import 'dart:io';

import 'package:camera/camera.dart';
import 'package:demoproject/FaceRecognition.dart';
import 'package:demoproject/main.dart';
import 'package:demoproject/permissionhandle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as imageLib;
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
  bool _cameraInitialized = false;
  CameraController cameraController =
      CameraController(cameras[1], ResolutionPreset.medium);

  initializeCamera() async {
    cameraController.initialize().then((value) {
      cameraController.startImageStream((image) {
        savePicture(image);
        setState(() {
          _cameraInitialized = true;
        });
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    permission();
    initializeCamera();
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      print(_cameraInitialized);
    });

    cameraController.lockCaptureOrientation(DeviceOrientation.portraitUp);

    Future.delayed(Duration(seconds: 7)).then((value) {
      _cameraInitialized ? cameraController.stopImageStream() : null;
      _cameraInitialized = false;
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => FaceRecognition()));
    });

    return _cameraInitialized
        ? AspectRatio(
            aspectRatio: cameraController.value.aspectRatio,
            child: CameraPreview(
              cameraController,
              child: Icon(Icons.camera),
            ))
        : Container(
            color: Colors.white,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  initializeCamera();
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

    print("$img  ravan");
    try {
      saveFile(img);
    } on CameraException catch (e) {
      print(e.toString());
      return;
    }
  }

  Future<void> saveFile(imageLib.Image img) async {
    if (await Permission.manageExternalStorage.isGranted) {
      String path = storages[0].rootDir;
      Directory directory = Directory("$path/imageDir");
      directory.createSync(recursive: true);
      print(directory.path);

      File file = File("${directory.path}/${img.toString()}");
      file.createSync(recursive: true);
      file.writeAsBytes(img.getBytes(format: imageLib.Format.rgba));
      print(file.path);
    } else {
      Permission.manageExternalStorage.request();
      saveFile(img);
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

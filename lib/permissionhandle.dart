import 'package:permission_handler/permission_handler.dart';

class PermissionHandle {
  Permission permission;

  PermissionHandle(this.permission);

  Future<bool> checkPermission() async {
    if (await permission.isGranted) {
      return true;
    } else {
      var request = await permission.request();
      if (request == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }
}

import 'package:evfinder/Controller/map_camera_controller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationPermissionController {
  var mapController = MapCameraController();
  Position? position;

  Future<bool> permission() async {
    Map<Permission, PermissionStatus> status = await [Permission.location].request(); // 위치 권한 요청
    if (await Permission.location.isGranted) {
      //허용 시
      // mapController.onInit();
      return Future.value(true);
    } else {
      //거부 시
      return Future.value(false);
    }
  }

  permissionCheck() async {
    //권한 상태 확인(허용이면 넘어가고, 거부면 권한 요청)
    if (await Permission.location.status == PermissionStatus.granted) {
      // position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      // Get.offAndToNamed(AppRoutes.login);
    } else {
      permission();
    }
  }

  Future<Position?> getCurrentLocation() async {
    try {
      position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      return position;
    } catch (e) {
      print('위치 가져오기 실패: $e');
      return null;
    }
  }

  // 동기적으로 position에 접근하는 getter
  Position? get currentPosition => position;
}

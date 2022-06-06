import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:realtime_textrecognition/ui/home.dart';


late List<CameraDescription> cameras;
Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp( new MaterialApp(
    home: camera_realtime_access(),
  ));
}

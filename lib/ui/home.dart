import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:realtime_textrecognition/main.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
class camera_realtime_access extends StatefulWidget {
  const camera_realtime_access({ Key? key }) : super(key: key);

  @override
  State<camera_realtime_access> createState() => _camera_realtime_accessState();
}

class _camera_realtime_accessState extends State<camera_realtime_access> {
  CameraController? controller;
  int _index =0;
  final textdetector = TextRecognizer();
  String recognizedString ="";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initializeCamera();
  }
  Future _initializeCamera () async{
    controller = CameraController(cameras[_index], ResolutionPreset.medium);
    controller!.initialize().then((_) async{
      if(!mounted){
        return ;
      }
      await controller!.startImageStream((CameraImage image) => _processCameraImage(image));
      setState(() {

      });

    }).catchError((e){
      print(e);
    });
  }
  Future _processCameraImage(CameraImage image) async{
    InputImage inputImage = InputImage.fromBytes(bytes: image.planes[0].bytes, inputImageData: InputImageData(size: Size(image.width.toDouble(),image.height.toDouble()), imageRotation: InputImageRotation.rotation90deg, inputImageFormat: InputImageFormat.bgra8888, planeData: image.planes.map((Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList()));
    final RecognizedText recognizedtext = await textdetector.processImage(inputImage);
    for (TextBlock block in recognizedtext.blocks){
      recognizedString = block.text + "";
    }
    setState(() {
      
    });
    textdetector.close();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Real Time camera !!!")),
      body: SingleChildScrollView(child: Column(children:[
        CameraPreview(controller!),
        ElevatedButton(onPressed: (){
          _index = (_index+1)%2;
          controller = CameraController(cameras[_index], ResolutionPreset.medium);
          controller!.initialize().then((_)async{
            await controller!.startImageStream((CameraImage image) => _processCameraImage(image));
            setState(() {
              
            });
          });
        }, child: Text("Rotate Camera")),
        Text("${recognizedString}",textAlign: TextAlign.center,)
      ],)),
    );
  }
}
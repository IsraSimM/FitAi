/*import 'package:camera/camera.dart';



final camera = _cameras[_cameraIndex];
_controller = CameraController(
camera,
// Set to ResolutionPreset.high. Do NOT set it to ResolutionPreset.max because for some phones does NOT work.
ResolutionPreset.medium,
enableAudio: false,
imageFormatGroup: Platform.isAndroid
? ImageFormatGroup.yuv420
    : ImageFormatGroup.bgra8888,
);


final _orientations = {
DeviceOrientation.portraitUp: 0,
DeviceOrientation.landscapeLeft: 90,
DeviceOrientation.portraitDown: 180,
DeviceOrientation.landscapeRight: 270,
}
InputImageRotation? rotation;
if (Platform.isIOS) {
rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
} else if (Platform.isAndroid) {
var rotationCompensation =
_orientations[_controller!.value.deviceOrientation];
if (rotationCompensation == null) return null;
if (camera.lensDirection == CameraLensDirection.front) {
// front-facing
rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
} else {
// back-facing
rotationCompensation =
(sensorOrientation - rotationCompensation + 360) % 360;
}
rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
// print('rotationCompensation: $rotationCompensation');
}
if (rotation == null) return null;
// print('final rotation: $rotation');*/
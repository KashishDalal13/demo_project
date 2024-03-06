import 'dart:io';
import 'dart:typed_data';
import 'package:demo_project/signature.dart';
import 'package:flutter/material.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignaturePadExample(),
    );
  }
}

// class ImageCropperApp extends StatefulWidget {
//   @override
//   _ImageCropperAppState createState() => _ImageCropperAppState();
// }

// class _ImageCropperAppState extends State<ImageCropperApp> {
//   Uint8List? _image; 
//   File? selectedImage;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.deepPurple[100],
//       body: Center(
//         child: Stack(
//           children: [
//             _image != null ?
//              CircleAvatar(
//               radius: 100,
//               backgroundImage: MemoryImage(_image!),
//             ):
//             const CircleAvatar(
//               radius: 100,
//               backgroundImage: NetworkImage(
//                   "https://pbs.twimg.com/media/Eu7e3mQVgAImK2o.png"),
//             ),
//             Positioned(
//               bottom: -0,
//               left: 140,
//               child: IconButton(
//                 onPressed: () {
//                   ShowImagePickerOption(context);
//                 },
//                 icon: const Icon(Icons.add_a_photo),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void ShowImagePickerOption(BuildContext context) {
//     showModalBottomSheet(
//         backgroundColor: Colors.blue[100],
//         context: context,
//         builder: (builder) {
//           return Padding(
//             padding: const EdgeInsets.all(18.0),
//             child: SizedBox(
//               width: MediaQuery.of(context).size.width,
//               height: MediaQuery.of(context).size.height / 4.5,
//               child: Row(children: [
//                 Expanded(
//                   child: InkWell(
//                     onTap: () {
//                       _pickImagefromGallery();
//                     },
//                     child: const SizedBox(
//                       child: Column(
//                         children: [Icon(Icons.image, size: 70,), Text("Gallery")],
//                       ),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: InkWell(
//                     onTap: () {
//                       _pickImagefromCamera();
//                     },
//                     child: const SizedBox(
//                       child: Column(
//                         children: [Icon(Icons.camera_alt, size: 70,), Text("Camera")],
//                       ),
//                     ),
//                   ),
//                 ),
//               ]),
//             ),
//           );
//         },);
//   }
//   Future _pickImagefromGallery() async {
//     final returnImage = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if(returnImage == null) return;
//     setState(() {
//       selectedImage = File(returnImage.path);
//       _image = File(returnImage.path).readAsBytesSync();
//     });
//     Navigator.of(context).pop();
//   }
//   Future _pickImagefromCamera() async {
//     final returnImage = await ImagePicker().pickImage(source: ImageSource.camera);
//     if(returnImage == null) return;
//     setState(() {
//       selectedImage = File(returnImage.path);
//       _image = File(returnImage.path).readAsBytesSync();
//     });
//     Navigator.of(context).pop();
//   }
// }
  

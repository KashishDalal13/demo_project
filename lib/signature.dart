import 'dart:typed_data';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
// Import the new share_plus dependency
import 'package:share_plus/share_plus.dart';

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

class SignaturePadExample extends StatefulWidget {
  @override
  _SignaturePadExampleState createState() => _SignaturePadExampleState();
}

class _SignaturePadExampleState extends State<SignaturePadExample> {
  late SignatureController _controller;
  late Color _selectedColor;
  double _penStrokeWidth = 5;

  @override
  void initState() {
    super.initState();
    _controller = SignatureController(
      penStrokeWidth: _penStrokeWidth,
      penColor: Colors.black, // Set initial color
    );
    _selectedColor = Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signature Pad Example'),
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: Signature(
                controller: _controller,
                height: double.infinity,
                backgroundColor: Colors.white, // Set background color
              ),
            ),
          ),
          Container(
            color: Colors.grey[200],
            child: Column(
              children: [
                Slider(
                  value: _penStrokeWidth,
                  min: 1,
                  max: 20,
                  onChanged: (value) {
                    setState(() {
                      _penStrokeWidth = value;
                      _updatePenSettings();
                    });
                  },
                  label: _penStrokeWidth.round().toString(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    DropdownButton<Color>(
                      value: _selectedColor,
                      onChanged: (color) {
                        setState(() {
                          _selectedColor = color!;
                          _updatePenSettings();
                        });
                      },
                      items: [
                        DropdownMenuItem(
                          value: Colors.black,
                          child: Text('Black'),
                        ),
                        DropdownMenuItem(
                          value: Colors.blue,
                          child: Text('Blue'),
                        ),
                        DropdownMenuItem(
                          value: Colors.red,
                          child: Text('Red'),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _controller.clear(); // Clear the content
                        });
                      },
                      child: Text('Clear'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final signatureBytes = await _controller.toPngBytes();
                        final signaturePath =
                        await saveSignatureAsImage(signatureBytes!);
                        // Call the new method for sharing
                        await shareSignatureImage(signaturePath);
                      },
                      child: Text('Save & Share'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _updatePenSettings() {
    _controller = SignatureController(
      penStrokeWidth: _penStrokeWidth,
      penColor: _selectedColor,
    );
  }

  Future<String> saveSignatureAsImage(Uint8List signatureBytes) async {
    final appDir = await getApplicationDocumentsDirectory();
    final signaturePath = path.join(appDir.path, 'signature.png');

    final File file = File(signaturePath);
    await file.writeAsBytes(signatureBytes);

    await ImageGallerySaver.saveFile(signaturePath);

    return signaturePath;
  }

  // Define the new method for sharing using the share_plus package
  Future<void> shareSignatureImage(String imagePath) async {
    try {
      await Share.shareFiles([imagePath], text: 'Check out my signature!');
    } catch (e) {
      print('Error sharing signature: $e');
    }
  }
}

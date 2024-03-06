import 'dart:typed_data';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
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
                border: Border.all(color: Colors.black), // Set border color
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Signature(
                  controller: _controller,
                  height: double.infinity,
                  backgroundColor: Colors.white, // Set background color
                ),
              ),
            ),
          ),
          Container(
            color: Colors.grey[200],
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                      // Call the new method for saving in the gallery
                      await saveToGallery(signaturePath);
                    },
                    child: Text('Save to Gallery'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final signatureBytes = await _controller.toPngBytes();
                      final signaturePath =
                      await saveSignatureAsImage(signatureBytes!);
                      await shareSignature(signaturePath);
                    },
                    child: Text('Share'),
                  ),
                ],
              ),
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

    return signaturePath;
  }

  Future<void> saveToGallery(String imagePath) async {
    try {
      await ImageGallerySaver.saveFile(imagePath);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signature saved to gallery')),
      );
    } catch (e) {
      print('Error saving signature: $e');
    }
  }

  Future<void> shareSignature(String signaturePath) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Share Signature'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await shareAsImage(signaturePath);
                    Navigator.of(context).pop();
                  },
                  child: Text('Share as Image'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await shareAsPdf(signaturePath);
                    Navigator.of(context).pop();
                  },
                  child: Text('Share as PDF'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> shareAsImage(String signaturePath) async {
    try {
      await Share.shareFiles([signaturePath], text: 'Check out my signature!');
    } catch (e) {
      print('Error sharing signature as image: $e');
    }
  }

  Future<void> shareAsPdf(String signaturePath) async {
    final pdf = pw.Document();
    final image = pw.MemoryImage(File(signaturePath).readAsBytesSync());

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Image(image),
          );
        },
      ),
    );

    final Uint8List pdfBytes = await pdf.save();
    final tempDir = await getTemporaryDirectory();
    final pdfPath = path.join(tempDir.path, 'signature.pdf');
    final pdfFile = File(pdfPath);
    await pdfFile.writeAsBytes(pdfBytes);

    try {
      await Share.shareFiles([pdfPath], text: 'Check out my signature PDF!');
    } catch (e) {
      print('Error sharing signature as PDF: $e');
    }
  }
}

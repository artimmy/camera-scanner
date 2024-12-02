// WORKING !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Document Scanner',
      home: DocumentScannerPage(),
    );
  }
}

class DocumentScannerPage extends StatefulWidget {
  const DocumentScannerPage({super.key});

  @override
  DocumentScannerPageState createState() => DocumentScannerPageState();
}

class DocumentScannerPageState extends State<DocumentScannerPage> {
  final List<File> _images = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() {
        _images.add(File(pickedImage.path));
      });
    }
  }

  Future<String> _getDownloadsFolder() async {
    if (Platform.isAndroid) {
      final directory = Directory('/storage/emulated/0/Download');
      if (await directory.exists()) {
        return directory.path;
      } else {
        throw Exception('Downloads folder not found');
      }
    } else if (Platform.isIOS) {
      // On iOS, you may not have direct access to a "Downloads" folder.
      final directory = await getApplicationDocumentsDirectory();
      return directory.path;
    } else {
      throw Exception('Unsupported platform');
    }
  }

  Future<void> _generatePdf() async {
    final pdf = pw.Document();

    for (var image in _images) {
      final imageFile = pw.MemoryImage(image.readAsBytesSync());
      pdf.addPage(pw.Page(
        build: (pw.Context context) => pw.Center(
          child: pw.Image(imageFile),
        ),
      ));
    }

    try {
      final downloadsFolder = await _getDownloadsFolder();
      final outputFile = File('$downloadsFolder/scanned_document.pdf');
      await outputFile.writeAsBytes(await pdf.save());

      debugPrint('PDF saved to ${outputFile.path}');
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Scanner'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _images.isEmpty
                ? const Center(child: Text('No images scanned.'))
                : ListView.builder(
                    itemCount: _images.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.file(_images[index]),
                      );
                    },
                  ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Scan Document'),
              ),
              ElevatedButton(
                onPressed: _images.isNotEmpty ? _generatePdf : null,
                child: const Text('Generate PDF'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

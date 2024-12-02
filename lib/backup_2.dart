// Working BACKUP

import 'dart:async';
import 'dart:io';

import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<String> _pictures = [];

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: _onPressed,
                child: const Text("Add Pictures"),
              ),
              ElevatedButton(
                onPressed: _generatePdf,
                child: const Text("Generate PDF"),
              ),
              for (var picture in _pictures) Image.file(File(picture))
            ],
          ),
        ),
      ),
    );
  }

  void _onPressed() async {
    List<String> pictures;
    try {
      pictures = await CunningDocumentScanner.getPictures() ?? [];
      if (!mounted) return;
      setState(() {
        _pictures = pictures;
      });
    } catch (exception) {
      // Handle exception here
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

    for (var image in _pictures) {
      final file = File(image);
      final imageFile = pw.MemoryImage(file.readAsBytesSync());
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
}

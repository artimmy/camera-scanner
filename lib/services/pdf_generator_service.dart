import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfGeneratorService {
  final BuildContext context;
  const PdfGeneratorService({
    required this.context,
  });

  Future<String> _getDownloadsFolder() async {
    if (Platform.isAndroid) {
      final directory = Directory('/storage/emulated/0/Download');
      if (await directory.exists()) {
        return directory.path;
      } else {
        throw Exception('Downloads folder not found');
      }
    } else if (Platform.isIOS) {
      final directory = await getApplicationDocumentsDirectory();
      return directory.path;
    } else {
      throw Exception('Unsupported platform');
    }
  }

  Future<void> generatePdf(List<String> pictures) async {
    final pdf = pw.Document();

    for (var image in pictures) {
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
      final now = DateTime.timestamp().toLocal();
      final outputFile = File('$downloadsFolder/scanned_document_$now.pdf');
      await outputFile.writeAsBytes(await pdf.save());

      _message('PDF saved to ${outputFile.path}');
    } catch (e) {
      _message('Error saving PDF: $e');
    }
  }

  void _message(String data) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(data),
    ));
  }
}

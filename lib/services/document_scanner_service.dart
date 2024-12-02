import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:flutter/material.dart';

class DocumentScannerService {
  static Future<List<String>> scanDocuments() async {
    try {
      final pictures = await CunningDocumentScanner.getPictures() ?? [];
      return pictures;
    } catch (exception) {
      // Log or handle exception
      debugPrint(exception.toString());
      return [];
    }
  }
}

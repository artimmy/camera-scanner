import 'dart:io';

import 'package:flutter/material.dart';

import '../services/document_scanner_service.dart';
import '../services/pdf_generator_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> _pictures = [];
  bool _isGeneratingPdf = false;

  Future<void> _addPictures() async {
    final pictures = await DocumentScannerService.scanDocuments();
    if (!mounted) return;
    setState(() {
      _pictures = pictures;
    });
  }

  Future<void> _generatePdf(BuildContext context) async {
    setState(() {
      _isGeneratingPdf = true;
    });
    var pdfGeneratorService = PdfGeneratorService(context: context);
    await pdfGeneratorService.generatePdf(_pictures);
    setState(() {
      _isGeneratingPdf = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Scanner'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: Column(
        children: [
          if (_pictures.isEmpty)
            Expanded(
              child: Center(
                child: Text(
                  "No pictures added yet.",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            )
          else
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: _pictures.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemBuilder: (context, index) {
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Image.file(
                      File(_pictures[index]),
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            onPressed: _addPictures,
            label: const Text("Add Pictures"),
            icon: const Icon(Icons.add_photo_alternate),
            backgroundColor: Colors.indigo,
          ),
          const SizedBox(height: 12.0),
          FloatingActionButton.extended(
            onPressed: () => _generatePdf(context),
            label: _isGeneratingPdf
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : const Text("Generate PDF"),
            icon: const Icon(Icons.picture_as_pdf),
            backgroundColor: _isGeneratingPdf ? Colors.grey : Colors.indigo,
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "Add pictures to generate a PDF",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[700],
          ),
        ),
      ),
    );
  }
}
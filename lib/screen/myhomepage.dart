import 'dart:io';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:http/http.dart' as http;

class Myhomepage extends StatefulWidget {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  @override
  State<Myhomepage> createState() => _MyhomepageState();
}

class _MyhomepageState extends State<Myhomepage> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
      PDFDocument? doc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          ElevatedButton(
              onPressed: () async {
                final path = await FlutterDocumentPicker.openDocument();
                File file = File(path!);
                firebase_storage.UploadTask? task = await uploadfile(file);
              },
              child: const Text("pick up pdf")),
          ElevatedButton(
              onPressed: () async {
                await downloadURLExample();
                Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => viewPDF(doc!)),
    );
              },
              child: const Text("view pdf"))
        ]),
      ),
    );
  }

  Future<firebase_storage.UploadTask?>? uploadfile(File file) async {
    if (file == null) {
      return null;
    }
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('files')
        .child('/some-file.pdf');
    final metadata = firebase_storage.SettableMetadata(
        contentType: 'file/pdf',
        customMetadata: {'picked-file-path': file.path});
    firebase_storage.UploadTask uploadTask =
        ref.putData(await file.readAsBytes(), metadata);
    return Future.value(uploadTask);
  }

  Future<void> downloadURLExample() async {
    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref('files/some-file.pdf')
        .getDownloadURL();
    PDFDocument doc1 = await PDFDocument.fromURL(downloadURL);
    doc=doc1;
    
  }
}

class viewPDF extends StatefulWidget {
  PDFDocument doc;
  viewPDF(this.doc);

  @override
  State<viewPDF> createState() => _viewPDFState();
}

class _viewPDFState extends State<viewPDF> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      margin: EdgeInsets.all(10.0),
      child: PDFViewer(
        document: widget.doc,
        zoomSteps: 1,
        lazyLoad: false,
      ),
    );
  }
}

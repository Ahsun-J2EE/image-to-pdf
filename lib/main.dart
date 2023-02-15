import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

void main() {
  runApp( MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState()=> _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final picker = ImagePicker();
  final pdf= pw.Document();
  File? _image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Image to PDF'),
      actions: [
        IconButton(
            onPressed: (){
              createPDF();
              savePDF();
            },
            icon: Icon(Icons.picture_as_pdf))
      ],),
      floatingActionButton: FloatingActionButton(
        onPressed: getImageFromGallery,
        child: Icon(Icons.add),
      ),
      body: _image !=null
          ?Container(
           height: 400,
            width: double.infinity,
            child: Image.file(
              _image!,fit: BoxFit.cover,
            ),)
          :Container(),
    );
  }

  void getImageFromGallery() async{
    final pickedFile= await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if(pickedFile != null){
        _image=File(pickedFile.path);
      }else{
        print('No image selected');
      }
    });
  }

  void createPDF() async{
    final image =pw.MemoryImage(_image!.readAsBytesSync());
    pdf.addPage(
        pw.Page(pageFormat: PdfPageFormat.a4, build: (pw.Context context){
          return pw.Center(child: pw.Image(image));
        }));
  }

  void savePDF() async{
    try{
    final dir= await getApplicationSupportDirectory();
    final file= File('${dir?.path}/habib.pdf');
    print('path:${dir}');
    await file.writeAsBytes(await pdf.save());
    showPrintedMessage('success', 'saved to documents');
    }catch(e){
      showPrintedMessage('error', e.toString());
    }
  }
  showPrintedMessage(String title, String msg){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}

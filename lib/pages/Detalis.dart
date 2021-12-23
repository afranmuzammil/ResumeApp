//import 'dart:html';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Details extends StatefulWidget {
  const Details({Key? key}) : super(key: key);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {

  Future<void> customLunch( String command) async {
    if (command !=null) {
      await launch(command);
    } else {
      print('could not launch $command');
    }
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).secondaryHeaderColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Details',
            style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70))
          // style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body:  SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              //image
              Text(
                "Full name",
                style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87)),
              ),
              const SizedBox(height: 5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "ContactNO:  ",
                    style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87)),
                  ),
                  TextButton(
                    onPressed: () => customLunch(
                      "tel:",
                    ),
                    child: const Text(
                      "Call",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: TextButton.styleFrom(
                      primary: Colors.black26,
                      backgroundColor: Colors.blue,
                      onSurface: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5.0),
              Text(
                "Gender",
                style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87)),
              ),
              const SizedBox(height: 5.0),
              Text("Address :  ",
                  style: GoogleFonts.poppins(
                      textStyle:
                      const TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
              const SizedBox(height: 5.0),
              //resume
              ElevatedButton(
                onPressed: () async{
                  print("pressed");
                  await openFile(
                  url:'https://firebasestorage.googleapis.com/v0/b/resume-app-36441.appspot.com/o/files%2Ftutorial.pdf?alt=media&token=7151cf8b-9953-4ba7-8363-484285884f61',
                  fileName:'tutorial.pdf',
                );
                },
                  child:const Text("Download & Open"),
              )
            ],
          )
        ) ,
      ),
    );
  }

  Future openFile({required String url, String? fileName}) async {
    final file = await downloadFile(url,fileName!);
    print("from fille ${file==null}");
    if(file==null) return;
    print('path:${file.path}');
    OpenFile.open(file.path);
  }
  Future<File?> downloadFile(String url, String name)async {

    final appStorage = await getApplicationDocumentsDirectory();
    final file = File('${appStorage.path}/$name');


    try {
      final response = await Dio().get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          receiveTimeout: 0,
        ),
      );
     // print("from fille $url");
      final raf = file.openSync(mode: FileMode.write);
      print("hello : ${file == null}");
      raf.writeFromSync(response.data);
      await raf.close();

      return file;
    }catch(e){
      print(" in file down $e");
      return null;
    }
  }



}

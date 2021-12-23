//import 'dart:html';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Details extends StatefulWidget {
  final String docID;
  const Details({Key? key,required this.docID}) : super(key: key);

  @override
  _DetailsState createState() => _DetailsState(docID);
}

class _DetailsState extends State<Details> {

  String docID;
  _DetailsState(this.docID);

  @override
  void initState() {
    _getData();
    //foo();

    // _ad = BannerAd(
    //     adUnitId: AdHelper.bannerAdUnitId,
    //     request: AdRequest(),
    //     size: AdSize.banner,
    //     listener: AdManagerBannerAdListener(onAdLoaded: (_) {
    //       print("Banner AD Called");
    //       setState(() {
    //         isloaded = true;
    //       });
    //     }, onAdFailedToLoad: (_, error) {
    //       print("Ad faild to Load with error : $error");
    //     }));
    //_ad.load();

    super.initState();
  }
  var userData;
  DocumentSnapshot? data;
  Future<DocumentSnapshot> _getData() async{
    DocumentSnapshot variable = await FirebaseFirestore.instance
        .collection("Personal Details")
        .doc(docID)
        .get().then((value) { return foo(value); });
    // setState(() {
    //   data = variable;
    // });
    data = variable;
    return data!;
  }
  Future<DocumentSnapshot> foo(data) async{
   // await Future.delayed(const Duration(seconds: 0)).then((value) => {userData = data});
    userData = data;
    //  var userData = await _getData();
    // print(" on: ${userData["Address"]}");
    return userData;
  }
  value(values){
    if (data != null){
      // print("${data["$values"]}");
      return data!["$values"];
    }
    else {
      return " none";
    }

  }


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
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Personal Details")
              .snapshots(),
          builder: (BuildContext context,  AsyncSnapshot<QuerySnapshot>  snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  //  valueColor: animation,
                  backgroundColor: Colors.white,
                ),
              );
            }
            else if (snapshot.hasError) {
              print("e :${snapshot.error}");
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    //Text('Error: '),
                    Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text('Error: '),
                    )
                  ],
                ),
              );
            }
            return SingleChildScrollView(
              child: FutureBuilder(
                future: _getData(),
                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
                  if(snapshot.hasData){
                    return Column(
                      children: [
                        //image
                        Text(
                          "${userData["FirstName"]} ${userData["LastName"]} ",
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
                              "ContactNO: ${userData["Mobile"]} ",
                              style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87)),
                            ),
                            TextButton(
                              onPressed: () => customLunch(
                                "tel:${userData["Mobile"]}",
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
                          "Gender : ${userData["Gender"]}",
                          style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87)),
                        ),
                        const SizedBox(height: 5.0),
                        Text("Address : ${userData["Address"]} ",
                            style: GoogleFonts.poppins(
                                textStyle:
                                const TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
                        const SizedBox(height: 5.0),
                        //resume
                        ElevatedButton(
                          onPressed: () async{
                            print(" on: ${userData["Address"]}");
                            await openFile(
                              url:'${userData["ResumeUrl"]}',
                              fileName:'file.pdf',
                            );
                          },
                          child:const Text("Download & Open"),
                        )
                      ],
                    );
                  }else if(snapshot.hasError){
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 60,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Text('Error: ${snapshot.error}'),
                          )
                        ],
                      ),
                    );
                  }
                  else{
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          SizedBox(
                            child: CircularProgressIndicator(
                             // valueColor: animation,
                              backgroundColor: Colors.white,
                              strokeWidth: 5,
                            ),
                            width: 60,
                            height: 60,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: Text('Loading data...'),
                          )
                        ],
                      ),
                    );
                  }
                }
                ,

              )
            );
          }
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

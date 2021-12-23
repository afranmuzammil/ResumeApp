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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Details',
            style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54))
          // style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
       // elevation: 0,
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
                    return Container(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 30.0),
                           CircleAvatar(
                            radius: 70,
                            backgroundColor:  Colors.black54,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(65),
                                child: Image(
                                    image: NetworkImage("${userData["ImageUrl"]}",),
                                  width: 130,
                                  height: 130,
                                  fit: BoxFit.fill,
                                )),
                          ),
                          //image
                          const Divider(
                            height: 40,
                            thickness: 4,
                            color: Colors.black54,
                            // indent: 20,
                            //  endIndent: 20,
                          ),
                          Text(
                            "${userData["FirstName"]} ${userData["LastName"]} ".toUpperCase(),
                            style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54)),
                          ),
                          const Divider(
                            height: 40,
                            thickness: 4,
                            color: Colors.black54,
                            // indent: 10,
                            // endIndent: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "ContactNO :    ${userData["Mobile"]} ",
                                style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87)),
                              ),
                             // const VerticalDivider(),
                              ElevatedButton(
                                onPressed: () => customLunch(
                                      "tel:${userData["Mobile"]}",
                                    ),
                                child: const Icon(Icons.call_rounded, color: Colors.white),
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(8),
                                  primary: Colors.green, // <-- Button color
                                  onPrimary: Colors.white, // <-- Splash color
                                ),
                              ),

                              // TextButton(
                              //   onPressed: () => customLunch(
                              //     "tel:${userData["Mobile"]}",
                              //   ),
                              //   child: const Text(
                              //     "Call",
                              //     style: TextStyle(color: Colors.white),
                              //   ),
                              //   style: TextButton.styleFrom(
                              //     primary: Colors.black26,
                              //     backgroundColor: Colors.black54,
                              //     onSurface: Colors.grey,
                              //   ),
                              // ),
                            ],
                          ),
                          const Divider(
                            height: 20,
                            thickness: 1,
                            color: Colors.black54,
                            indent: 20,
                            endIndent: 20,
                          ),
                          Text(
                            "Gender : ${userData["Gender"]}",
                            style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87)),
                          ),
                        const Divider(
                          height: 20,
                          thickness: 1,
                          color: Colors.black54,
                          indent: 20,
                          endIndent: 20,
                        ),
                          Text("Address : ${userData["Address"]} ",
                              style: GoogleFonts.poppins(
                                  textStyle:
                                  const TextStyle(fontSize: 20, fontWeight: FontWeight.w500))),
                          const Divider(
                            height: 20,
                            thickness: 1,
                            color: Colors.black54,
                            indent: 20,
                            endIndent: 20,
                          ),
                          //resume
                          Text("Resume",
                              style: GoogleFonts.poppins(
                                  textStyle:
                                  const TextStyle(fontSize: 20, fontWeight: FontWeight.w500))),
                          const SizedBox(height: 20.0),
                          ElevatedButton(
                            onPressed: () async{
                              print(" on: ${userData["Address"]}");
                              await openFile(
                                url:'${userData["ResumeUrl"]}',
                                fileName:'file.pdf',
                              );
                            },
                            child:const Text("DOWNLOAD & OPEN"),
                            style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder(),
                              padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
                              primary: Colors.black54, // <-- Button color
                              onPrimary: Colors.white, // <-- Splash color
                            ),
                          )
                        ],
                      ),
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

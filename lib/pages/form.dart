import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class Forms extends StatefulWidget {
  const Forms({Key? key}) : super(key: key);

  @override
  _FormsState createState() => _FormsState();
}

class _FormsState extends State<Forms> {
  final ScrollController _controllerOne = ScrollController();
  final formKey = GlobalKey<FormState>();

  File ?userImage;
  final picker = ImagePicker();

  Future getImage() async {
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 65,
    );
    setState(() {
      userImage = File(image!.path);
    });
  }
  Future getImageCam() async {
    final image = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 65,
    );
    setState(() {
      userImage = File(image!.path);
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: const Icon(Icons.photo_library),
                      title: const Text('Photo Library'),
                      onTap: () {
                        getImage();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: const Icon(Icons.photo_camera),
                    title: const Text('Camera'),
                    onTap: () {
                      getImageCam();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  //controllers
  final FirstName = TextEditingController();
  final LastName =  TextEditingController();
  final Mobile =  TextEditingController();
  final Address =  TextEditingController();

  bool Male = false;
  bool Female = false;
  bool Others = false;

  bool uploadVisible = false;

  List Gender = [];



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).secondaryHeaderColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Form',
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: formKey ,
            child: Column(
              children: <Widget>[
                Column(
                  children: [
                    //fistname
                    TextFormField(
                      controller: FirstName,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        //border: InputBorder.none,
                          hintText: 'First Name*',
                          prefixIcon: Icon(Icons.person)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the appropriate details';
                        }
                        // else if (value != realId) {
                        //   return "please enter the right pass word";
                        // }
                        return null;
                      },
                    ),
                    //lastname
                    TextFormField(
                      controller: LastName,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        //border: InputBorder.none,
                          hintText: 'Last Name*',
                          prefixIcon: Icon(Icons.person)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the appropriate details';
                        }
                        // else if (value != realId) {
                        //   return "please enter the right pass word";
                        // }
                        return null;
                      },
                    ),
                    //mobile
                    TextFormField(
                      controller: Mobile,
                      keyboardType: TextInputType.number,
                      keyboardAppearance: Brightness.light,
                      decoration:const InputDecoration(
                        //border: InputBorder.none,
                          hintText: 'Contact No*',
                          prefixIcon: Icon(Icons.phone)),
                      validator: (value) {
                        if (value == null ||value.isEmpty) {
                          return 'Please enter the appropriate details';
                        }
                        // else if (value != realId) {
                        //   return "please enter the right pass word";
                        // }
                        return null;
                      },
                    ),
                    //Gender
                    const SizedBox(
                      height: 30.0,
                    ),
                    const Text(
                      'Gender*',
                      style: TextStyle(
                          fontSize: 20.0,
                         // backgroundColor: Colors.black12
                      ),
                      textAlign: TextAlign.left,
                    ),
                    //male
                    CheckboxListTile(
                      secondary: const Icon(Icons.male_outlined),
                      title: const Text('Male'),
                      //subtitle: Text('Ringing after 12 hours'),
                      value: Male,
                      onChanged: (bool? value) {
                        setState(() {
                          Male = value!;
                        });
                        if(Male==true){
                          Gender.add("Male");
                        }else if(value==false){
                          Gender.remove("Male");
                        }
                      },
                      // onChanged: (bool value) {
                      //   setState(() {
                      //     this.Male = value;
                      //   });
                      //   if (Male == true) {
                      //     typeOfInstitutionList.add("MADRSA");
                      //   } else if (valueMadrsa == false) {
                      //     typeOfInstitutionList.remove("MADRSA");
                      //   }
                      // },
                    ),
                    //female
                    CheckboxListTile(
                      secondary: const Icon(Icons.female_outlined),
                      title: const Text('Female'),
                      //subtitle: Text('Ringing after 12 hours'),
                      value: Female,
                      onChanged: (bool? value) {
                        setState(() {
                          Female = value!;
                        });
                        if(Female==true){
                          Gender.add("Female");
                        }else if(value==false){
                          Gender.remove("Female");
                        }
                      },
                    ),
                    //others
                    CheckboxListTile(
                      secondary: const Icon(Icons.transgender_outlined),
                      title: const Text('Others'),
                      //subtitle: Text('Ringing after 12 hours'),
                      value: Others,
                      onChanged: (bool? value) {
                        setState(() {
                          Others = value!;
                        });
                        if(Female==true){
                          Gender.add("Others");
                        }else if(value==false){
                          Gender.remove("Others");
                        }
                      },
                    ),
                    //Address
                    TextFormField(
                      controller: Address,
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      //Normal textInputField will be displayed
                      maxLines: 5,
                      decoration: const InputDecoration(
                        //border: InputBorder.none,
                        hintText: 'Address* ',
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 50.0, horizontal: 10.0),
                        prefixIcon: Icon(Icons.add_location_outlined),
                      ),
                      scrollPadding:
                      const EdgeInsets.symmetric(vertical: 50.0),
                      validator: (value) {
                        if (value == null ||value.isEmpty) {
                          return 'Please enter the appropriate details';
                        }
                        // else if (value != realId) {
                        //   return "please enter the right pass word";
                        // }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Column(
                      children: [
                        Center(
                          child: userImage == null
                              ? const Text(
                            "UPLOAD PLACE IMAGE",
                            style: TextStyle(
                                color: Colors.black54),
                          )
                              : Image.file(userImage!),
                        ),
                        Builder(
                          builder: (context) => TextButton.icon(
                            onPressed: () {
                              //getImage();
                              _showPicker(context);
                            },
                            icon: const Icon(
                              Icons.add_a_photo_outlined,
                              color: Colors.grey,
                            ),
                            label: const Text(
                              "Add pic*",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        Visibility(
                            visible: uploadVisible,
                            child: const Icon(
                              Icons.cloud_upload_rounded,
                              color: Colors.green,
                            )),
                      ],
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    //upload Image button
                    // Builder(
                    //   builder: (context) => TextButton(
                    //     // color: Theme.of(context).primaryColor,
                    //     style: TextButton.styleFrom(
                    //       primary: Colors.black26,
                    //       backgroundColor:
                    //       Theme.of(context).primaryColor,
                    //       onSurface: Colors.blue,
                    //     ),
                    //     onPressed: () async {
                    //       await uploadImageToFirebase(context);
                    //       await Future.delayed(Duration(seconds: 1));
                    //       print("upload done : $imageLink");
                    //       if (imageLink != null) {
                    //         setState(() {
                    //           uploadVisible = true;
                    //         });
                    //         ScaffoldMessenger.of(context)
                    //             .showSnackBar(
                    //           SnackBar(
                    //             content: Text("Image Uploaded"),
                    //           ),
                    //         );
                    //       } else {
                    //         ScaffoldMessenger.of(context)
                    //             .showSnackBar(
                    //           SnackBar(
                    //             content: Text(
                    //                 "Image Not upload try again"),
                    //           ),
                    //         );
                    //       }
                    //     },
                    //     child: Text('upload image',
                    //         style: TextStyle(color: Colors.white)),
                    //   ),
                    // ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    //resumeUpload
                    Column(
                      children: [
                        Center(
                          child: userImage == null
                              ? const Text(
                            "UPLOAD RESUME",
                            style: TextStyle(
                                color: Colors.black54),
                          )
                              : Image.file(userImage!),
                        ),
                        Builder(
                          builder: (context) => TextButton.icon(
                            onPressed: () {
                              //getImage();
                              //_showPicker(context);
                            },
                            icon: const Icon(
                              Icons.attach_file_outlined,
                              color: Colors.grey,
                            ),
                            label: const Text(
                              "Upload file",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    )

                  ],
                )
              ],
            ),
          ),
        ) ,
      ),
    );
  }
}

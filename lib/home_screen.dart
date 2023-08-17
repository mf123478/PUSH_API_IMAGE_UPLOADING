

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  File? image;
  final _picker = ImagePicker();
  bool showSpinner = false;

  Future getImage()async{

    final pickedImage = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    setState(() {

    });

    if(pickedImage != null){
      image = File(
        pickedImage.path
      );
    }else{
      print("No image Selected");
    }
  }


  Future<void> uploadImage()async{
    setState(() {
       showSpinner = true;
    });

    var stream = http.ByteStream(image!.openRead());
    stream.cast();

    var length = await image!.length();
    
    var uri = Uri.parse('https://fakestoreapi.com/products');

    final request = new http.MultipartRequest('POST', uri);

    request.fields['title'] = "Static Title";

    var multiPort = new http.MultipartFile(
      'image',
      stream,
      length
    );

    request.files.add(multiPort);

    var response = await request.send();
    print(response.stream.toString());
    if(response.statusCode == 200){
      setState(() {
        showSpinner = false;
      });
      print("Image Uploaded");
    }else{
      setState(() {
        showSpinner = false;
      });
      print('Failed');
    }
  }
  @override

  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Uploading Image"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            GestureDetector(
              onTap: (){
                getImage();
              },
              child: Container(
                child: image == null ? const Center(
                  child: Text("Pick Image"),
                ):
                  Container(
                    child: Center(
                      child: Image.file(
                        File(image!.path).absolute,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
              ),
            ),
            SizedBox(height: 20,),
            GestureDetector(
              onTap: (){
                uploadImage();
              },
              child: Container(
                color: Colors.blue,
                child: Center(child: Text('Upload')),
                height: 50,
                width: 150,
              ),
            )

          ],
        ),
      ),
    );
  }
}

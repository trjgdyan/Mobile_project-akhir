import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'dart:io';

class UploadImagess extends StatefulWidget {
  const UploadImagess({super.key});

  @override
  // _uploadState createState() => _uploadState();
  State<UploadImagess> createState() => _UploadState();
}

class _UploadState extends State<UploadImagess> {
  File? imageFile;

  // get http => null;

  Future getImage({required ImageSource source}) async {
    final file = await ImagePicker().pickImage(
      source: source,
      maxWidth: 640,
      maxHeight: 480,
      imageQuality: 70, //0 - 100
    );

    if (file?.path != null) {
      setState(() {
        imageFile = File(file!.path);
        // Navigator.pushNamed(context, '/print');
      });
    }
  }

  @override
  Future<void> _uploadImage() async {
    try {
      if (imageFile == null) {
        print('Please select an image first.');
        return;
      }

      String apiUrl = 'https://70ec-103-108-21-117.ngrok-free.app/upload';

      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.files
          .add(await http.MultipartFile.fromPath('img', imageFile!.path));
      request.headers['Content-Type'] =
          'image/jpeg'; // Adjust content type if needed

      try {
        var response = await request.send();
        if (response.statusCode == 200) {
          // Request successful
          print('Image uploaded successfully!');
          // Handle the response, if any
          // var responseData = await response.stream.toBytes();
          // var result = utf8.decode(responseData);
          // print(result);
        } else {
          // Request failed
          print('Failed to upload image. Status code: ${response.statusCode}');
        }
      } catch (error) {
        // Handle asynchronous errors
        print('Error sending request: $error');
      }
    } catch (error) {
      // Handle errors
      print('Error uploading image: $error');
    }
  }

  // @override

  // Future<void> _uploadImage() async {
  //   try {
  //     if (imageFile == null) {
  //       print('Please select an image first.');
  //       return;
  //     }

  //     String apiUrl = 'https://ee3c-114-6-31-174.ngrok-free.app/upload';

  //     var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
  //     request.files
  //         .add(await http.MultipartFile.fromPath('img', imageFile!.path));

  //     var response = await request.send();
  //     if (response.statusCode == 200) {
  //       // Request successful
  //       print('Image uploaded successfully!');
  //       // Handle the response, if any
  //       // var responseData = await response.stream.toBytes();
  //       // var result = utf8.decode(responseData);
  //       // print(result);
  //     } else {
  //       // Request failed
  //       print('Failed to upload image. Status code: ${response.statusCode}');
  //     }
  //   } catch (error) {
  //     // Handle errors
  //     print('Error uploading image: $error');
  //   }
  // }
  // Future<void> _uploadImage() async {
  //   try {
  //     if (imageFile == null) {
  //       print('Please select an image first.');
  //       return;
  //     }

  //     String apiUrl = 'https://ee3c-114-6-31-174.ngrok-free.app/upload';

  //     var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
  //     request.files.add(await http.MultipartFile.fromPath('img', imageFile!.path));

  //     var response = await request.send();
  //     if (response.statusCode == 200) {
  //       // Request successful
  //       print('Image uploaded successfully!');
  //       // Handle the response, if any
  //       // var responseData = await response.stream.toBytes();
  //       // var result = utf8.decode(responseData);
  //       // print(result);
  //     } else {
  //       // Request failed
  //       print('Failed to upload image. Status code: ${response.statusCode}');
  //     }
  //   } catch (error) {
  //     // Handle errors
  //     print('Error uploading image: $error');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Halaman Upload"),
      ),
      body: Container(
        color: Colors.pink[50],
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Column(
                children: [
                  Text(
                    "Drop Image Here",
                    style: TextStyle(fontSize: 30),
                  ),
                ],
              ),
              if (imageFile != null)
                Container(
                  width: 330,
                  height: 410,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    image: DecorationImage(
                      image: FileImage(imageFile!),
                      fit: BoxFit.cover,
                    ),
                    border: Border.all(width: 8, color: Colors.black),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                )
              else
                Container(
                  width: 330,
                  height: 410,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(width: 6, color: Colors.black12),
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: const Text(
                    'Image should appear here!',
                    style: TextStyle(fontSize: 20, color: Colors.pink),
                  ),
                ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => getImage(source: ImageSource.camera),
                      child: const CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.pink,
                        child: Icon(
                          Icons.camera_alt_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => getImage(source: ImageSource.gallery),
                      child: const CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.pink,
                        child: Icon(
                          Icons.insert_photo,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _uploadImage(),
                      child: const CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.pink,
                        child: Icon(
                          Icons.upload_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    //   body: Container(
    //     // alignment: Alignment.center,
    //     child: Column(
    //       children: [
    //         Container(
    //           margin: EdgeInsets.only(top: 10, bottom: 10),
    //           // alignment: Alignment.topCenter,
    //           child: const Text(
    //             'Select Image from :  ',
    //             style: TextStyle(fontSize: 20),
    //           ),
    //         ),
    //         Container(
    //           // margin: EdgeInsets.all(40),
    //           // alignment: Alignment.topCenter,
    //           child: Row(
    //             children: [
    //               Container(
    //                 // margin: EdgeInsets.only(right: 20),
    //                 // alignment: Alignment.center,
    //                 child: ElevatedButton(
    //                   onPressed: () {},
    //                   child: const Text('Camera'),
    //                 ),
    //               ),
    //               Container(
    //                 // alignment: Alignment.center,
    //                 child: ElevatedButton(
    //                   onPressed: () {},
    //                   child: const Text('Gallery'),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }

  // void getImage({required ImageSource source}) async {
  //   // final file = await ImagePicker().pickImage(
  //   //   source: source,
  //   //   maxWidth: 640,
  //   //   maxHeight: 480,
  //   //   imageQuality: 70, //0 - 100
  //   // );

  //   if (file?.path != null) {
  //     setState(() {
  //       imageFile = File(file!.path);
  //       Navigator.pushNamed(context, '/print');
  //     });
  //   }
  // }
}

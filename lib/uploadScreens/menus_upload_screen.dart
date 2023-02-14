import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_by_bike_users/global/global.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as storageRef;
import '../widgets/error_dialog.dart';
import '../widgets/progress_bar.dart';
import '../widgets/reuseable_widget.dart';

class MenusUploadScreen extends StatefulWidget {
  const MenusUploadScreen({Key? key}) : super(key: key);

  @override
  State<MenusUploadScreen> createState() => _MenusUploadScreenState();
}

class _MenusUploadScreenState extends State<MenusUploadScreen> {
  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();
  bool uploading = false;

  String uniqueIdName = DateTime.now().microsecondsSinceEpoch.toString();

  TextEditingController shortInfoController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  defaultScreen() {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(),
        ),
        title: Text('Add New Menu'),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [
            Colors.black12,
            Colors.white70,
          ],
          begin: FractionalOffset(0.0, 0.0),
          end: FractionalOffset(1.0, 1.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        )),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.add_photo_alternate,
                color: Colors.white,
                size: 200.0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: normalButton(
                  context,
                  'Add New Menu',
                  () {
                    takeImage(context);
                  },

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  takeImage(mContext) {
    return showDialog(
      context: mContext,
      builder: (context) {
        return SimpleDialog(
          title: const Text("Menu Image",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center),
          children: [
            SimpleDialogOption(
              onPressed: captureImageWithCamera,
              child: const Text(
                "Capture with Camera",
                style: TextStyle(color: Colors.black),
              ),
            ),
            SimpleDialogOption(
              onPressed: pickImageFromGallery,
              child: const Text(
                "Select from Gallery",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  captureImageWithCamera() async {
    Navigator.pop(context);

    imageXFile = await _picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 720,
      maxWidth: 1280,
    );

    setState(() {
      imageXFile;
    });
  }

  pickImageFromGallery() async {
    Navigator.pop(context);

    imageXFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 720,
      maxWidth: 1280,
    );

    setState(() {
      imageXFile;
    });
  }

  menusUploadFormScreen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Uploading New Menu",
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        actions: [
          TextButton(
            onPressed: () => uploading ? null : validateUploadForm(),
            //          onPressed: uploading ? null : validateUploadForm(),
            child: Text(
              'Add',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          uploading == true ? linearProgress() : const Text(''),
          SizedBox(
            height: 230,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  margin: EdgeInsets.all(17),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: FileImage(File(imageXFile!.path)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            title: Container(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.text_fields_outlined),
                  prefixIconColor: Colors.black,
                  labelText: "Title",
                  labelStyle:
                      const TextStyle(color: Colors.black38, fontSize: 13),
                  floatingLabelAlignment: FloatingLabelAlignment.start,
                  floatingLabelStyle: const TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                    borderSide: const BorderSide(color: Colors.black, width: 1),
                  ),
                  contentPadding: const EdgeInsets.all(15),
                ),
              ),
            ),
          ),

          ListTile(
            title: Container(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                controller: shortInfoController,
                decoration: InputDecoration(
                  labelText: "Menu Info",
                  prefixIcon: Icon(Icons.info_outline),
                  prefixIconColor: Colors.black,
                  labelStyle:
                      const TextStyle(color: Colors.black38, fontSize: 13),
                  floatingLabelAlignment: FloatingLabelAlignment.start,
                  floatingLabelStyle: const TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                    borderSide: const BorderSide(color: Colors.black, width: 1),
                  ),
                  contentPadding: const EdgeInsets.all(15),
                ),
              ),
            ),
          ),


        ],
      ),
    );
  }

  clearMenusUploadForm() {
    setState(
      () {
        shortInfoController.clear();
        titleController.clear();
        imageXFile = null;
      },
    );
  }

  validateUploadForm() async {
    setState(() {
      uploading = true;
    });

    if (imageXFile != null) {
      if (titleController.text.isNotEmpty &&
          shortInfoController.text.isNotEmpty) {
        //upload image
        String downloadUrl = await uploadImage(File(imageXFile!.path));
        //save info to firebase
        saveInfo(downloadUrl, shortInfoController.text, titleController.text);
      } else {
        showDialog(
            context: context,
            builder: (c) {
              return const ErrorDialog(
                message: "Please write title and info for menu",
              );
            });
      }
    } else {
      showDialog(
          context: context,
          builder: (c) {
            return const ErrorDialog(
              message: "Please pick an image for menu",
            );
          });
    }
  }

  uploadImage(mImageFile) async {
    storageRef.Reference reference =
        storageRef.FirebaseStorage.instance.ref().child("menus");
    storageRef.UploadTask uploadTask =
        reference.child('$uniqueIdName.jpg').putFile(mImageFile);
    storageRef.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(
      () {},
    );

    String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  @override
  Widget build(BuildContext context) {
    return imageXFile == null ? defaultScreen() : menusUploadFormScreen();
  }

  saveInfo(String downloadUrl, String text, String text2) {
    final ref = FirebaseFirestore.instance
        .collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .collection("menus");

    ref.doc(uniqueIdName).set({
      "menuID": uniqueIdName,
      "sellerUID": sharedPreferences!.getString("uid"),
      "menuInfo": shortInfoController.text.toString(),
      "menuTitle": titleController.text.toString(),
      "publishedDate": DateTime.now(),
      "status": "available",
      "thumbnailUrl": downloadUrl,
    });

    clearMenusUploadForm();

    setState(() {
      uniqueIdName = '';
      uploading = false;
    });
  }
}

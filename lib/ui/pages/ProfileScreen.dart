import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? profileImageURL;
  late String userName = '';
  late int userAge = 0;
  late int totalCaloriesLimit = 0;
  File? imageFile;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .get();

      setState(() {
        userName = snapshot['name'];
        userAge = snapshot['age'];
        totalCaloriesLimit = snapshot['totalCaloriesLimit'];
        profileImageURL = snapshot['profileImageURL'];
      });
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  void selectImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      cropImage(pickedFile);
    }
  }

  void cropImage(XFile file) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
        compressQuality: 20,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        sourcePath: file.path);
    if (croppedFile != null) {
      File? croppedImage = File(croppedFile.path);
      if (croppedImage != null) {
        setState(() {
          imageFile = croppedImage;
        });
        try {
          String uid = FirebaseAuth.instance.currentUser!.uid;
          Reference storageReference =
          FirebaseStorage.instance.ref().child('profile_images/$uid.jpg');

          // Upload the file to Cloud Storage
          UploadTask uploadTask = storageReference.putFile(croppedImage);

          // Get the download URL when the upload is complete
          String downloadURL = await (await uploadTask).ref.getDownloadURL();

          // Save the download URL to Firestore
          await FirebaseFirestore.instance
              .collection('Users') // Replace with your collection name
              .doc(uid) // Replace with the document ID (typically the user's UID)
              .update({'profileImageURL': downloadURL});

          setState(() {
            profileImageURL = downloadURL;
          });

          print('Profile image uploaded successfully!');
        } catch (error) {
          print('Error uploading profile image: $error');
        }
      }
    }
  }

  void showPhotoOptions() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Upload Profile Picture"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    selectImage(ImageSource.gallery);
                  },
                  leading: const Icon(Icons.browse_gallery),
                  title: const Text("Select from Gallery"),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    selectImage(ImageSource.camera);
                  },
                  leading: const Icon(Icons.camera_alt),
                  title: const Text("Take a photo"),
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 16, 89, 149),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CupertinoButton(
                onPressed: () {
                  showPhotoOptions();
                },
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: (profileImageURL != null)
                      ? NetworkImage(profileImageURL!)
                      : null,
                  child: (profileImageURL == null)
                      ? const Icon(
                    Icons.person,
                    size: 50,
                  )
                      : null,
                ),
              ),
              Text(userName,
                  style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Pacificio',
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
              Text('Age: $userAge',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18)),
              Text('Total Calories Limit: $totalCaloriesLimit',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18)),
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.white),
                    minimumSize: MaterialStateProperty.all<Size>(
                      Size(width, height * 0.06), // Dynamic height
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EditProfilePage()));
                  },
                  child: Row(
                    children: const [
                      Icon(
                        Icons.edit,
                        color: Color.fromRGBO(38, 47, 151, 1),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Edit Profile",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(38, 47, 151, 1),
                        ),
                      ),
                    ],
                  )),
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.white),
                    minimumSize: MaterialStateProperty.all<Size>(
                      Size(width, height * 0.06), // Dynamic height
                    ),
                  ),
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: ((context) => const AuthGate())));
                  },
                  child: const Row(
                    children: [
                      Icon(
                        Icons.logout,
                        color: Color.fromRGBO(208, 13, 22, 1),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Logout",
                        style: TextStyle(
                            fontSize: 18,
                            color: Color.fromRGBO(208, 13, 22, 1),
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

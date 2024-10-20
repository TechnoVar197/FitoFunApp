import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'userinfo.dart'; // Import UserInfoService

class EditProfileScreen extends StatefulWidget {
  final String? currentName;
  final int? currentAge;
  final int? currentCaloriesLimit;
  final String? currentProfileImageUrl;

  const EditProfileScreen({
    Key? key,
    this.currentName,
    this.currentAge,
    this.currentCaloriesLimit,
    this.currentProfileImageUrl, required Null Function(dynamic name, dynamic age, dynamic caloriesLimit, dynamic imageUrl) onUpdate,
  }) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _caloriesLimitController;
  File? _image;
  String? _imageUrl;

  final UserInfoService _userInfoService = UserInfoService(); // Instance of UserInfoService

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
    _ageController = TextEditingController(text: widget.currentAge?.toString());
    _caloriesLimitController = TextEditingController(text: widget.currentCaloriesLimit?.toString());
    _imageUrl = widget.currentProfileImageUrl;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage() async {
    if (_image == null) return null;

    final fileName = path.basename(_image!.path);
    final storageReference = FirebaseStorage.instance.ref().child('profile_images/$fileName');
    final uploadTask = storageReference.putFile(_image!);
    final snapshot = await uploadTask.whenComplete(() => {});
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  void _saveProfile() async {
    final imageUrl = await _uploadImage() ?? _imageUrl;
    // Use UserInfoService to update user data
    await _userInfoService.updateUserInfo(
      _nameController.text,
      int.tryParse(_ageController.text) ?? 0,
      int.tryParse(_caloriesLimitController.text) ?? 0,
      imageUrl,
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 60,
                backgroundImage: _image != null
                    ? FileImage(_image!) as ImageProvider
                    : (_imageUrl != null
                    ? NetworkImage(_imageUrl!) as ImageProvider
                    : null),
                child: _image == null && _imageUrl == null
                    ? const Icon(Icons.add_a_photo, size: 50)
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _caloriesLimitController,
              decoration: const InputDecoration(labelText: 'Calories Limit'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveProfile,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}

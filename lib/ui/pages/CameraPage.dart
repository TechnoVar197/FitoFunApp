import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';

class Camera extends StatefulWidget {
  const Camera ({super.key});

  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  bool _loading = true;
  File? _image;
  String? _resultMessage;


  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  Future<void> _requestPermission() async {
    await Permission.photos
        .request(); // Requesting gallery access permission for iOS
    await Permission.camera
        .request(); // Requesting camera access permission for Android and iOS
  }
  Widget _buildDialogResultContent() {
    List<Widget> dialogContent = [
      Text('$_resultMessage'),
    ];



    return Column(
      mainAxisSize: MainAxisSize.min, // To constrain the size of the column to its children
      crossAxisAlignment: CrossAxisAlignment.start,
      children: dialogContent,
    );
  }

  Future<void> classifyImage(File image) async {
    setState(() {
      _loading = true;
    });

    final bytes = await image.readAsBytes();
    final multipartFile = http.MultipartFile.fromBytes(
      'image',
      bytes,
      filename: 'captured_image.jpg',
    );

    try {
      final uri =
      Uri.parse('https://leafyyapi.azurewebsites.net/process-image');
      final request = http.MultipartRequest('POST', uri)
        ..files.add(multipartFile);

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        final jsonResponse = json.decode(responseString);

        final int classificationResult = jsonResponse['classification_result'];
        switch (classificationResult) {
          case 0:
            _resultMessage = 'Result Found \n Nitrogen Level is  High';
            break;
          case 1:
            _resultMessage = 'Result Found \n Nitrogen Level is Very High';
            break;
          case 2:
            _resultMessage = 'Result Found \n Nitrogen Level is Very Low';
            break;
          case 3:
            _resultMessage = 'Result Found \n Nitrogen Level is Medium';
            break;
          case 4:
            _resultMessage = 'Result Found \n Nitrogen Level is Low';
            break;
          default:
            _resultMessage = null;
            break;
        }
      } else {
        _resultMessage =
        'Failed to upload image. Status code: ${response.statusCode}';
      }
    } catch (e) {
      _resultMessage = 'Error during image capture or upload: $e';
    }

    setState(() {
      _loading = false;
    });

    if (_resultMessage != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Classification Result'),
            content: _buildDialogResultContent(), // Building the content based on condition
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> pickImage() async {
    // this function grabs the image from the camera
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _image = File(image.path);
        _loading = false; // Set loading to false when an image is selected
      });
      classifyImage(_image!);
    }
  }

  Future<void> pickGalleryImage() async {
    // this function grabs the image from the gallery
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
        _loading = false; // Set loading to false when an image is selected
      });
      classifyImage(_image!);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    double spaceBetweenButtons = screenWidth * 0.05;
    double spaceBetween = screenheight * 0.1;

    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(30),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 24),
              if (_image == null)
                SizedBox(
                  height: 250,
                  width: screenWidth, // Using full screen width for the image
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset(
                      'assets/cam.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              SizedBox(height:spaceBetween/5),
              if (_loading && _image == null) // Display if no image is selected and loading
                const Text(
                  'Take a Picture of your meal',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              if (_image != null) // Only display the image if it is not null
                SizedBox(
                  height: 250,
                  width: screenWidth, // Using full screen width for the image
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.file(
                      _image!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: pickImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey[600],
                    ),
                    child: const Text(
                      'Take A Photo',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(width: spaceBetweenButtons), // Dynamically set spacing
                  ElevatedButton(
                    onPressed: pickGalleryImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey[600],
                    ),
                    child: const Text(
                      'Pick From Gallery',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              SizedBox(height:spaceBetween/4),
              const SizedBox(height: 24),
              if (_resultMessage != null) // Display the result if it's not null
                Text(
                  '$_resultMessage',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    // Increased the font size for better readability
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ]
        ),
      ),
    );
  }
}
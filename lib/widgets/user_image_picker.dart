import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key, required this.onPickedImage});
  final void Function(File? pickedImage) onPickedImage;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _selectedImage;
  void _imagePicker() async{
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.camera,imageQuality: 50,maxWidth: 150,preferredCameraDevice: CameraDevice.front);

    if(pickedImage==null){
      return;
    }

    setState(() {
      _selectedImage = File(pickedImage.path);
    });
    widget.onPickedImage(_selectedImage);
    
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
           CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey,
            foregroundImage: _selectedImage != null ? FileImage(_selectedImage!) : null,
          ),
          TextButton.icon(
            onPressed: _imagePicker,
            icon: const Icon(Icons.camera_alt_outlined),
            label: const Text(
              'Add Image',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

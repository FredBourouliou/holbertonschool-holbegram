import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../methods/auth_methods.dart';
import 'home.dart';

class AddPicture extends StatefulWidget {
  final String email;
  final String password;
  final String username;

  const AddPicture({
    super.key,
    required this.email,
    required this.password,
    required this.username,
  });

  @override
  State<AddPicture> createState() => _AddPictureState();
}

class _AddPictureState extends State<AddPicture> {
  Uint8List? _image;
  bool _isLoading = false;

  void selectImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      Uint8List bytes = await file.readAsBytes();
      setState(() => _image = bytes);
    }
  }

  void selectImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.camera);
    if (file != null) {
      Uint8List bytes = await file.readAsBytes();
      setState(() => _image = bytes);
    }
  }

  Future<void> _signUp() async {
    setState(() => _isLoading = true);
    String res = await AuthMethode().signUpUser(
      email: widget.email,
      password: widget.password,
      username: widget.username,
      file: _image,
    );
    if (!mounted) return;
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(res == 'success' ? 'Success' : res)),
    );

    if (res == 'success') {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const Home()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 28),
              const Text(
                'Holbegram',
                style: TextStyle(fontFamily: 'Billabong', fontSize: 50),
              ),
              Image.asset(
                'assets/images/logo.webp',
                width: 80,
                height: 60,
              ),
              const SizedBox(height: 12),
              Text(
                'Hello, ${widget.username}',
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 4),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'Pick an image',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
              const SizedBox(height: 28),
              CircleAvatar(
                radius: 80,
                backgroundColor: Colors.grey.shade200,
                backgroundImage:
                    _image != null ? MemoryImage(_image!) : null,
                child: _image == null
                    ? const Icon(
                        Icons.person,
                        size: 100,
                        color: Colors.black54,
                      )
                    : null,
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: selectImageFromCamera,
                    iconSize: 40,
                    icon: const Icon(Icons.camera_alt),
                  ),
                  const SizedBox(width: 24),
                  IconButton(
                    onPressed: selectImageFromGallery,
                    iconSize: 40,
                    icon: const Icon(Icons.image),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  height: 48,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        const Color.fromARGB(218, 226, 37, 24),
                      ),
                    ),
                    onPressed: _isLoading ? null : _signUp,
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Next',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

// You might want to create this screen later for password changes
// import 'change_password_screen.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // Simulate loading existing user data
  @override
  void initState() {
    super.initState();
    // In a real app, you would fetch this from a user data model or backend
    _nameController.text = 'John Doe';
    _emailController.text = 'johndoe@example.com';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    // In a real app, send updated data to your backend
    // print('Saving changes: Name - ${_nameController.text}, Email - ${_emailController.text}');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully!')),
    );
    // Optionally pop back after saving
    // Navigator.of(context).pop();
  }

  void _changeProfilePicture() {
    // In a real app, open image picker
    _pickImage();
    // print('Change profile picture tapped');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Image picker not implemented yet.')),
    );
  }

  File? _profileImage;
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Personal Information',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.center, // Center profile picture
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage:
                      _profileImage != null ? FileImage(_profileImage!) : null,
                  child:
                      _profileImage == null
                          ? const Icon(Icons.person, size: 40)
                          : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _changeProfilePicture,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                hintText: 'Enter your full name',
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 16.0,
                ),
              ),
              keyboardType: TextInputType.name,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email address',
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 16.0,
                ),
              ),
              keyboardType: TextInputType.emailAddress,
              readOnly:
                  true, // Email often not editable directly for security reasons
              style: TextStyle(
                color: Colors.grey[700],
              ), // Indicate it's read-only
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _saveChanges,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700, // Primary button color
                foregroundColor: Colors.white,
                minimumSize: const Size(
                  double.infinity,
                  50,
                ), // Full width button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Save Changes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                // Navigate to ChangePasswordScreen
                // Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePasswordScreen()));
                // print('Navigate to Change Password');
                // ScaffoldMessenger.of(context).showSnackBar(
                //   const SnackBar(content: Text('Change password screen not implemented yet.')),
                // );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue.shade700,
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text('Change Password'),
            ),
          ],
        ),
      ),
    );
  }
}

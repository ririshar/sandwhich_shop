import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/app_styles.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name is required')),
      );
      return;
    }
    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid email')),
      );
      return;
    }
    if (phone.isNotEmpty && !_isDigitsOnly(phone)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Phone must contain digits only')),
      );
      return;
    }

    final profile = {'name': name, 'email': email, 'phone': phone};
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile saved')),
    );
    Navigator.pop(context, profile);
  }

  bool _isDigitsOnly(String s) => RegExp(r'^\d+$').hasMatch(s);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: heading1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              key: const Key('profile_name'),
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              key: const Key('profile_email'),
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 12),
            TextField(
              key: const Key('profile_phone'),
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration:
                  const InputDecoration(labelText: 'Phone (digits only)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              key: const Key('profile_save'),
              onPressed: _saveProfile,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = 'Albari';
    _emailController.text = 'albari@example.com';
    _phoneController.text = '+8801 234 567 890';
    _addressController.text = 'Example Address, City, Country';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _showEditDialog(String field, TextEditingController controller) {
    showDialog(
      context: context,
      builder: (context) {
        String tempValue = controller.text;
        return AlertDialog(
          title: Text('Edit $field'),
          content: TextField(
            controller: TextEditingController(text: tempValue),
            onChanged: (value) {
              tempValue = value;
            },
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  controller.text = tempValue;
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Image
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[300],
              child: const Icon(Icons.person, size: 40, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            
            // User Info
            _buildEditableField('Name', _nameController),
            _buildEditableField('Email', _emailController),
            _buildEditableField('Phone', _phoneController),
            _buildEditableField('Address', _addressController),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(controller.text, style: const TextStyle(fontSize: 16)),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () => _showEditDialog(label, controller),
        ),
      ),
    );
  }
}
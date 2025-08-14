import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  final String? profileImage;
  final String userName;

  const ProfilePage({Key? key, this.profileImage, this.userName = "JC"}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? selectedProfileImage;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedProfileImage = widget.profileImage;
    _nameController.text = widget.userName;
    _statusController.text = "Hi! 我在使用 WhatsApp...";
  }

  Future<void> _pickProfileImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );

      if (image != null) {
        setState(() {
          selectedProfileImage = image.path;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile picture updated!'),
            backgroundColor: Color(0xFF25D366),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick image: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "個人資料",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.check, color: Color(0xFF25D366)),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Profile updated successfully!'),
                  backgroundColor: Color(0xFF25D366),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Picture Section
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickProfileImage,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: selectedProfileImage != null 
                              ? FileImage(File(selectedProfileImage!))
                              : null,
                          backgroundColor: selectedProfileImage == null ? Colors.grey[300] : null,
                          child: selectedProfileImage == null
                              ? Icon(Icons.person, color: Colors.grey[600], size: 50)
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Color(0xFF25D366),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: Icon(Icons.camera_alt, color: Colors.white, size: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "點擊以變更相片",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF25D366),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1),
            
            // Name Section
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "姓名",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF25D366),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "輸入姓名",
                      hintStyle: TextStyle(color: Colors.grey[400]),
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1),
            
            // About Section
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "關於",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF25D366),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: _statusController,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    maxLines: 3,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "輸入關於",
                      hintStyle: TextStyle(color: Colors.grey[400]),
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1),
            
            // Phone Number Section
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "電話號碼",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF25D366),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        "+852 1234 5678",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.chevron_right, color: Colors.grey[400]),
                    ],
                  ),
                ],
              ),
            ),
            Divider(height: 1),
            
            // Additional Options
            ListTile(
              leading: Icon(Icons.phone, color: Colors.grey[600]),
              title: Text(
                "我的電話號碼",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              subtitle: Text(
                "管理你的電話號碼",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.security, color: Colors.grey[600]),
              title: Text(
                "安全性",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              subtitle: Text(
                "兩步驟驗證、變更密碼",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.devices, color: Colors.grey[600]),
              title: Text(
                "已連結的裝置",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              subtitle: Text(
                "管理你的裝置",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

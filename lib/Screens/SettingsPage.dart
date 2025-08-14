import 'package:flutter/material.dart';
import 'dart:io';
import 'ProfilePage.dart';

class SettingsPage extends StatefulWidget {
  final String? profileImage;
  final String userName;

  const SettingsPage({Key? key, this.profileImage, this.userName = "JC"}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
          "設定",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // User Profile Section
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(
                      profileImage: widget.profileImage,
                      userName: widget.userName,
                    ),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: widget.profileImage != null 
                          ? FileImage(File(widget.profileImage!))
                          : null,
                      backgroundColor: widget.profileImage == null ? Colors.grey[300] : null,
                      child: widget.profileImage == null
                          ? Icon(Icons.person, color: Colors.grey[600], size: 30)
                          : null,
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.userName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Hi! 我在使用 WhatsApp...",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.grid_view, color: Colors.grey[600]),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.add_circle_outline, color: Colors.grey[600]),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
            Divider(height: 1),
            
            // Settings Menu Items
            _buildSettingsItem(
              icon: Icons.vpn_key,
              title: "帳戶",
              subtitle: "安全通知、變更號碼",
              onTap: () {},
            ),
            _buildSettingsItem(
              icon: Icons.lock,
              title: "私隱",
              subtitle: "封鎖聯絡人、自動刪除訊息",
              onTap: () {},
            ),
            _buildSettingsItem(
              icon: Icons.face,
              title: "虛擬替身",
              subtitle: "建立、編輯、個人頭像",
              onTap: () {},
            ),
            _buildSettingsItem(
              icon: Icons.chat_bubble_outline,
              title: "對話",
              subtitle: "主題、背景圖片、對話記錄",
              onTap: () {},
            ),
            _buildSettingsItem(
              icon: Icons.notifications,
              title: "通知",
              subtitle: "訊息、群組和來電鈴聲",
              onTap: () {},
            ),
            _buildSettingsItem(
              icon: Icons.storage,
              title: "儲存空間及數據",
              subtitle: "網絡使用情況、自動下載",
              onTap: () {},
            ),
            _buildSettingsItem(
              icon: Icons.accessibility,
              title: "無障礙",
              subtitle: "增強對比,動畫",
              onTap: () {},
            ),
            _buildSettingsItem(
              icon: Icons.language,
              title: "應用程式語言",
              subtitle: "繁體中文(香港)",
              onTap: () {},
            ),
            _buildSettingsItem(
              icon: Icons.help_outline,
              title: "幫助",
              subtitle: "幫助中心、聯絡我們、私隱政策",
              onTap: () {},
            ),
            _buildSettingsItem(
              icon: Icons.people,
              title: "邀請朋友",
              subtitle: "",
              onTap: () {},
            ),
            
            Divider(height: 1),
            
            // Meta Section
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "∞ Meta",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    "帳戶管理中心",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "控制你在WhatsApp、Facebook、Instagram等應用程式的體驗。",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "其他 Meta 旗下產品",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMetaApp("Instagram", Icons.camera_alt, Colors.purple),
                      _buildMetaApp("Facebook", Icons.facebook, Colors.blue),
                      _buildMetaApp("Threads", Icons.alternate_email, Colors.black),
                      _buildMetaApp("Meta AI App", Icons.circle, Colors.grey),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.grey[700], size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
      subtitle: subtitle.isNotEmpty ? Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[600],
        ),
      ) : null,
      trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
      onTap: onTap,
    );
  }

  Widget _buildMetaApp(String name, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        SizedBox(height: 8),
        Text(
          name,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

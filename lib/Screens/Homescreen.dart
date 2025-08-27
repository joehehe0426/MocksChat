import 'package:chatapp/Model/ChatModel.dart';
import 'package:chatapp/Model/MessageModel.dart';
import 'package:chatapp/Pages/CameraPage.dart';
import 'package:chatapp/Pages/ChatPage.dart';
import 'package:chatapp/Screens/EditModeScreen.dart';
import 'package:chatapp/Screens/ContactSelectionScreen.dart';
// import 'package:chatapp/database/DatabaseHelper.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'SettingsPage.dart';
import 'package:chatapp/database/MockDataLoader.dart';

// Constants for better maintainability
const _primaryColor = Color(0xFF075E54);
const _accentColor = Color(0xFF00C851);
const _lightGray = Color(0xFFF5F5F5);
const _darkGray = Color(0xFF757575);

class Homescreen extends StatefulWidget {
  const Homescreen({
    Key? key,
    this.chatmodels,
    this.sourchat,
  }) : super(key: key);
  final List<ChatModel>? chatmodels;
  final ChatModel? sourchat;

  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  int _selectedIndex = 0;
  List<ChatModel> _chatModels = [];
  ChatModel? _sourceChat;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      await _loadChatModelsFromMockData();
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      _errorMessage = '$e';
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadChatModelsFromMockData() async {
    List<ChatModel> models = await MockDataLoader.getMockChats();
    ChatModel sourceChat = ChatModel(
      name: "Me",
      isGroup: false,
      currentMessage: "Hello",
      time: "12:00",
      icon: "person.svg",
      id: 0,
      status: "Online",
      profileImage: "assets/profile_pictures/balram.jpg",
    );
    setState(() {
      _chatModels = models;
      _sourceChat = sourceChat;
    });
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircularProgressIndicator(color: _primaryColor),
          SizedBox(height: 20),
          Text('Loading chats...', style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 20),
            Text(
              _errorMessage ?? 'An unknown error occurred',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: _darkGray),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                foregroundColor: Colors.white,
              ),
              onPressed: _initializeData,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage(String? imagePath, {double radius = 25}) {
    if (imagePath == null || imagePath.isEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: Colors.grey[300],
        child: const Icon(Icons.person, color: _darkGray),
      );
    }
    return CircleAvatar(
      radius: radius,
      backgroundImage: FileImage(File(imagePath)),
      backgroundColor: Colors.grey[300],
    );
  }

  void _navigateToEditMode() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditModeScreen(
          chatModels: _chatModels,
          sourceChat: _sourceChat ?? ChatModel(name: "Me", id: 0),
        ),
      ),
    );
  }

  void _navigateToCamera() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CameraPage()),
    );
  }

  void _handleSearch() {}

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return _buildLoading();
    if (_errorMessage != null) return _buildError();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "WhatsApp",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: _primaryColor,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: _primaryColor),
            tooltip: 'Edit Mode',
            onPressed: () => _navigateToEditMode(),
          ),
          IconButton(
            icon: const Icon(Icons.camera_alt, color: _primaryColor),
            tooltip: 'Camera',
            onPressed: () => _navigateToCamera(),
          ),
          IconButton(
            icon: const Icon(Icons.search, color: _primaryColor),
            tooltip: 'Search',
            onPressed: () => _handleSearch(),
          ),
          _buildPopupMenu(),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildPopupMenu() {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: _primaryColor),
      onSelected: (value) {
        if (value == "Settings") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SettingsPage(
                profileImage: _sourceChat?.profileImage,
                userName: _sourceChat?.name ?? "JC",
              ),
            ),
          );
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          _buildMenuItem(Icons.group_add, "新群組", "New group"),
          _buildMenuItem(Icons.broadcast_on_personal, "新廣播", "New broadcast"),
          _buildMenuItem(Icons.web, "WhatsApp Web", "Whatsapp Web"),
          _buildMenuItem(Icons.star, "已加星標的訊息", "Starred messages"),
          _buildMenuItem(Icons.settings, "設定", "Settings"),
        ];
      },
    );
  }

  PopupMenuItem<String> _buildMenuItem(IconData icon, String text, String value) {
    return PopupMenuItem(
      child: Row(
        children: [
          Icon(icon, color: _primaryColor, size: 20),
          const SizedBox(width: 10),
          Text(text),
        ],
      ),
      value: value,
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return ChatPage(
          chatmodels: _chatModels,
          sourchat: _sourceChat,
        );
      case 1:
        return _buildStatusPage();
      case 2:
        return _buildCommunitiesPage();
      case 3:
        return _buildCallsPage();
      default:
        return ChatPage(
          chatmodels: _chatModels,
          sourchat: _sourceChat,
        );
    }
  }

  Widget _buildFloatingActionButton() {
    if (_selectedIndex == 0) {
      return FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ContactSelectionScreen(
                sourceChat: _sourceChat ?? ChatModel(name: "Me", id: 0),
              ),
            ),
          );
        },
        backgroundColor: _accentColor,
        elevation: 8,
        child: const Icon(
          Icons.chat,
          color: Colors.white,
          size: 28,
        ),
      );
    } else if (_selectedIndex == 1) {
      return FloatingActionButton(
        onPressed: () {},
        backgroundColor: _accentColor,
        elevation: 8,
        child: const Icon(
          Icons.camera_alt,
          color: Colors.white,
          size: 28,
        ),
      );
    } else if (_selectedIndex == 2) {
      return FloatingActionButton(
        onPressed: () {},
        backgroundColor: _accentColor,
        elevation: 8,
        child: const Icon(
          Icons.group_add,
          color: Colors.white,
          size: 28,
        ),
      );
    } else if (_selectedIndex == 3) {
      return FloatingActionButton(
        onPressed: () {},
        backgroundColor: _accentColor,
        elevation: 8,
        child: const Icon(
          Icons.call,
          color: Colors.white,
          size: 28,
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: _primaryColor,
      unselectedItemColor: Colors.grey[600],
      currentIndex: _selectedIndex,
      onTap: (index) => setState(() => _selectedIndex = index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Chats',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.camera_alt),
          label: 'Updates',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'Communities',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.call),
          label: 'Calls',
        ),
      ],
    );
  }

  Widget _buildStatusPage() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Status Section
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "動態",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _lightGray,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200] ?? Colors.grey),
                  ),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          _buildProfileImage(_sourceChat?.profileImage),
                          const Positioned(
                            bottom: 0,
                            right: 0,
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircleAvatar(
                                backgroundColor: Color(0xFF25D366),
                                child: Icon(Icons.add, color: Colors.white, size: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "新增動態",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "在 24 小時後自動刪除",
                              style: TextStyle(
                                fontSize: 14,
                                color: _darkGray,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Channels Section
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "頻道",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Text(
                        "探索",
                        style: TextStyle(
                          fontSize: 14,
                          color: _darkGray,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Channel items
                _buildChannelItem("八達通", "12:00", "13", Icons.credit_card, Colors.orange),
                _buildChannelItem("TVB", "19萬位追蹤者", "", Icons.tv, Colors.red),
                _buildChannelItem("星島頭條", "3.3萬位追蹤者", "", Icons.newspaper, Colors.blue),
                _buildChannelItem("TVB News 無綫新聞", "8.5萬位追蹤者", "", Icons.newspaper, Colors.green),
                _buildChannelItem("香港01 | HK01 - 新聞資訊", "31.4萬位追蹤者", "", Icons.info, Colors.blue),
                _buildChannelItem("惠康超級市場 Wellcom...", "5萬位追蹤者", "", Icons.shopping_cart, Colors.red),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChannelItem(String name, String subtitle, String badge, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: color,
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: _darkGray,
                  ),
                ),
              ],
            ),
          ),
          if (badge.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _accentColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                badge,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color.fromARGB(25, 0, 200, 81),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: _accentColor),
            ),
            child: const Text(
              "追蹤",
              style: TextStyle(
                fontSize: 14,
                color: _accentColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommunitiesPage() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Illustration
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(25, 0, 200, 81),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                      ),
                      child: const Stack(
                        children: [
                          Positioned(
                            top: 20,
                            left: 20,
                            child: Icon(
                              Icons.people_outline,
                              size: 30,
                              color: _accentColor,
                            ),
                          ),
                          Positioned(
                            top: 20,
                            right: 20,
                            child: Icon(
                              Icons.edit,
                              size: 25,
                              color: _accentColor,
                            ),
                          ),
                          Positioned(
                            bottom: 20,
                            left: 20,
                            child: Icon(
                              Icons.apple,
                              size: 25,
                              color: _accentColor,
                            ),
                          ),
                          Positioned(
                            bottom: 20,
                            right: 20,
                            child: SizedBox(
                              width: 25,
                              height: 25,
                              child: Stack(
                                children: [
                                  Icon(Icons.grid_4x4, size: 25, color: _accentColor),
                                  Positioned(
                                    top: 2,
                                    right: 2,
                                    child: Icon(Icons.close, size: 12, color: _accentColor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      "與社群保持連繫",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "社群可將成員集合在主題群組中,並方便他們接收管理員公告。你已加入的所有社群都會在此顯示。",
                      style: TextStyle(
                        fontSize: 16,
                        color: _darkGray,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        "查看社群範例 >",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: _accentColor,
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Center(
                child: Text(
                  "建立你的社群",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallsPage() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Create Call Link Section
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: _accentColor,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Icon(
                    Icons.link,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Create call link",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "Share a link for your WhatsApp call",
                        style: TextStyle(
                          fontSize: 14,
                          color: _darkGray,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Recent Calls Section
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: const [
                Text(
                  "Recent",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.grey[300],
                    child: const Icon(
                      Icons.directions_car,
                      color: _darkGray,
                      size: 30,
                    ),
                  ),
                  title: const Text(
                    "Micheal",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Row(
                    children: [
                      Icon(
                        index % 2 == 0 ? Icons.call_made : Icons.call_missed,
                        size: 16,
                        color: index % 2 == 0 ? _accentColor : Colors.red,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        index == 0 ? "35 minutes ago" : 
                        index == 1 ? "Today, 12:22" :
                        index == 2 ? "Yesterday, 23:39" :
                        index == 3 ? "Yesterday, 18:15" : "Yesterday, 14:30",
                        style: const TextStyle(
                          fontSize: 14,
                          color: _darkGray,
                        ),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.call, color: _accentColor),
                    onPressed: () {},
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

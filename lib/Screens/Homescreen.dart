import 'package:chatapp/Model/ChatModel.dart';
import 'package:chatapp/Model/MessageModel.dart';
import 'package:chatapp/Pages/CameraPage.dart';
import 'package:chatapp/Pages/ChatPage.dart';
import 'package:chatapp/Screens/EditModeScreen.dart';
import 'package:chatapp/Screens/ContactSelectionScreen.dart';
import 'package:chatapp/database/DatabaseHelper.dart';
import 'package:chatapp/database/DatabaseSeeder.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'SettingsPage.dart';

class Homescreen extends StatefulWidget {
  Homescreen({Key? key, this.chatmodels, this.sourchat}) : super(key: key);
  final List<ChatModel>? chatmodels;
  final ChatModel? sourchat;

  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  int _selectedIndex = 0;
  List<ChatModel> _chatModels = [];
  ChatModel? _sourceChat;
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeDatabaseAndLoadChats();
  }

  Future<void> _initializeDatabaseAndLoadChats() async {
    try {
      // Initialize database
      await _databaseHelper.database;
      
      // Check if database needs seeding
      if (await DatabaseSeeder.needsSeeding()) {
        await DatabaseSeeder.seedDatabase();
      }
      
      // Load chat models from database
      await _loadChatModelsFromDatabase();
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error initializing database: $e');
      // Fallback to passed parameters
      setState(() {
        _chatModels = widget.chatmodels ?? [];
        _sourceChat = widget.sourchat;
        _isLoading = false;
      });
    }
  }

  Future<void> _loadChatModelsFromDatabase() async {
    try {
      // Get all contacts from database (now includes profile images)
      List<Map<String, dynamic>> contacts = await _databaseHelper.getAllContacts();
      List<ChatModel> models = [];
      
      for (var contact in contacts) {
        int chatId = contact['id'];
        String name = contact['name'] ?? 'Unknown';
        String avatar = contact['avatar'] ?? 'person.svg';
        bool isGroup = avatar == 'group.svg';
        String? profileImage = contact['profileImage'];
        
        // Get the latest message for this contact
        List<MessageModel> messages = await _databaseHelper.getMessages(chatId);
        String lastMessage = name; // Default to contact name
        String lastTime = 'Now';
        
        if (messages.isNotEmpty) {
          lastMessage = messages.last.message ?? name;
          lastTime = messages.last.time ?? 'Now';
        }
        
        ChatModel chatModel = ChatModel(
          name: name,
          isGroup: isGroup,
          currentMessage: lastMessage,
          time: lastTime,
          icon: avatar,
          id: chatId,
          status: isGroup ? 'Group' : 'Online',
          profileImage: profileImage,
        );
        
        models.add(chatModel);
      }
      
      // Create source chat (current user)
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
      
      print('Loaded ${models.length} chat models from database');
      // Debug: Print profile images
      for (var model in models) {
        print('Contact: ${model.name}, ProfileImage: ${model.profileImage}');
      }
    } catch (e) {
      print('Error loading chat models from database: $e');
      // Fallback to passed parameters
      setState(() {
        _chatModels = widget.chatmodels ?? [];
        _sourceChat = widget.sourchat;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "WhatsApp",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF075E54),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Color(0xFF075E54)),
            tooltip: 'Edit Mode',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditModeScreen(
                    chatModels: _chatModels,
                    sourceChat: _sourceChat ?? ChatModel(name: "Me", id: 0),
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.camera_alt, color: Color(0xFF075E54)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CameraPage(),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.search, color: Color(0xFF075E54)),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Color(0xFF075E54)),
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
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(Icons.group_add, color: Color(0xFF075E54)),
                      SizedBox(width: 10),
                      Text("新群組"),
                    ],
                  ),
                  value: "New group",
                ),
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(Icons.broadcast_on_personal, color: Color(0xFF075E54)),
                      SizedBox(width: 10),
                      Text("新廣播"),
                    ],
                  ),
                  value: "New broadcast",
                ),
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(Icons.web, color: Color(0xFF075E54)),
                      SizedBox(width: 10),
                      Text("WhatsApp Web"),
                    ],
                  ),
                  value: "Whatsapp Web",
                ),
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(Icons.star, color: Color(0xFF075E54)),
                      SizedBox(width: 10),
                      Text("已加星標的訊息"),
                    ],
                  ),
                  value: "Starred messages",
                ),
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(Icons.settings, color: Color(0xFF075E54)),
                      SizedBox(width: 10),
                      Text("設定"),
                    ],
                  ),
                  value: "Settings",
                ),
              ];
            },
          )
        ],
      ),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text(
                      'Loading chats...',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              )
            : ChatPage(
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
        return _isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text(
                      'Loading chats...',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              )
            : ChatPage(
                chatmodels: _chatModels,
                sourchat: _sourceChat,
              );
    }
  }

  Widget _buildFloatingActionButton() {
    if (_selectedIndex == 0) {
      // Chat tab - show chat FAB
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
        backgroundColor: Color(0xFF00C851),
        elevation: 8,
        child: Icon(
          Icons.chat,
          color: Colors.white,
          size: 28,
        ),
      );
    } else if (_selectedIndex == 1) {
      // Status tab - show camera FAB
      return FloatingActionButton(
        onPressed: () {
          // Open camera for status
        },
        backgroundColor: Color(0xFF00C851),
        elevation: 8,
        child: Icon(
          Icons.camera_alt,
          color: Colors.white,
          size: 28,
        ),
      );
    } else if (_selectedIndex == 2) {
      // Communities tab - show community FAB
      return FloatingActionButton(
        onPressed: () {
          // Create new community
        },
        backgroundColor: Color(0xFF00C851),
        elevation: 8,
        child: Icon(
          Icons.group_add,
          color: Colors.white,
          size: 28,
        ),
      );
    } else if (_selectedIndex == 3) {
      // Calls tab - show call FAB
      return FloatingActionButton(
        onPressed: () {
          // Start new call
        },
        backgroundColor: Color(0xFF00C851),
        elevation: 8,
        child: Icon(
          Icons.call,
          color: Colors.white,
          size: 28,
        ),
      );
    }
    return SizedBox.shrink();
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: Color(0xFF075E54),
      unselectedItemColor: Colors.grey[600],
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Chats',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.camera_alt,
            color: _selectedIndex == 1 ? Color(0xFF075E54) : Colors.grey[600],
          ),
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
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "動態",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200] ?? Colors.grey),
                  ),
                  child: Row(
                    children: [
                                             Stack(
                         children: [
                           CircleAvatar(
                             radius: 25,
                                         backgroundImage: widget.sourchat?.profileImage != null && widget.sourchat!.profileImage!.isNotEmpty
                ? FileImage(File(widget.sourchat!.profileImage!))
                : null,
                             backgroundColor: widget.sourchat?.profileImage == null ? Colors.grey[300] : null,
                             child: widget.sourchat?.profileImage == null
                                 ? Icon(Icons.person, color: Colors.grey[600])
                                 : null,
                           ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: Color(0xFF25D366),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: Icon(Icons.add, color: Colors.white, size: 12),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                color: Colors.grey[600],
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
          Divider(height: 1),
          // Channels Section
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "頻道",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        "探索",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
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
      margin: EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: color,
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          if (badge.isNotEmpty)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Color(0xFF25D366),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                badge,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          SizedBox(width: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Color(0xFF25D366).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Color(0xFF25D366)),
            ),
            child: Text(
              "追蹤",
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF25D366),
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
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Community illustration
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Color(0xFF25D366).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 20,
                            left: 20,
                            child: Icon(
                              Icons.people_outline,
                              size: 30,
                              color: Color(0xFF25D366),
                            ),
                          ),
                          Positioned(
                            top: 20,
                            right: 20,
                            child: Icon(
                              Icons.edit,
                              size: 25,
                              color: Color(0xFF25D366),
                            ),
                          ),
                          Positioned(
                            bottom: 20,
                            left: 20,
                            child: Icon(
                              Icons.apple,
                              size: 25,
                              color: Color(0xFF25D366),
                            ),
                          ),
                          Positioned(
                            bottom: 20,
                            right: 20,
                            child: Container(
                              width: 25,
                              height: 25,
                              child: Stack(
                                children: [
                                  Icon(Icons.grid_4x4, size: 25, color: Color(0xFF25D366)),
                                  Positioned(
                                    top: 2,
                                    right: 2,
                                    child: Icon(Icons.close, size: 12, color: Color(0xFF25D366)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    Text(
                      "與社群保持連繫",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Text(
                      "社群可將成員集合在主題群組中,並方便他們接收管理員公告。你已加入的所有社群都會在此顯示。",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
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
            padding: EdgeInsets.all(20),
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: Color(0xFF25D366),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Center(
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
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(0xFF25D366),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Icon(
                    Icons.link,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1),
          // Recent Calls Section
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
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
                    child: Icon(
                      Icons.directions_car,
                      color: Colors.grey[600],
                      size: 30,
                    ),
                  ),
                  title: Text(
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
                        color: index % 2 == 0 ? Color(0xFF25D366) : Colors.red,
                      ),
                      SizedBox(width: 4),
                      Text(
                        index == 0 ? "35 minutes ago" : 
                        index == 1 ? "Today, 12:22" :
                        index == 2 ? "Yesterday, 23:39" :
                        index == 3 ? "Yesterday, 18:15" : "Yesterday, 14:30",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.call, color: Color(0xFF25D366)),
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

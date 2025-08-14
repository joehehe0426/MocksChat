import 'package:chatapp/CustomUI/ButtonCard.dart';
import 'package:chatapp/Model/ChatModel.dart';
import 'package:chatapp/Model/MessageModel.dart';
import 'package:chatapp/Screens/Homescreen.dart';
import 'package:chatapp/database/DatabaseHelper.dart';
import 'package:chatapp/database/DatabaseSeeder.dart';
import 'package:chatapp/config/MockDataConfig.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  ChatModel? sourceChat;
  List<ChatModel> chatmodels = [];
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  bool isLoading = true;

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
      
      // Load chat models from config
      await _loadChatModelsFromConfig();
      
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error initializing database: $e');
      // Fallback to default chat models
      _loadDefaultChatModels();
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadChatModelsFromConfig() async {
    List<ChatModel> models = [];
    
    for (var contact in MockDataConfig.contacts) {
      // Find the latest message for this contact
      String lastMessage = contact['name'] ?? 'Unknown';
      String lastTime = 'Now';
      
      // Try to get the latest message from database
      try {
        int chatId = contact['id'] ?? 0;
        if (chatId == 0) {
          // Generate ID based on position
          chatId = MockDataConfig.contacts.indexOf(contact) + 1;
        }
        
        List<MessageModel> messages = await _databaseHelper.getMessages(chatId);
        if (messages.isNotEmpty) {
          lastMessage = messages.last.message ?? contact['name'] ?? 'Unknown';
          lastTime = messages.last.time ?? 'Now';
        }
      } catch (e) {
        print('Error loading messages for ${contact['name']}: $e');
      }
      
      ChatModel chatModel = ChatModel(
        name: contact['name'],
        isGroup: contact['avatar'] == 'group.svg',
        currentMessage: lastMessage,
        time: lastTime,
        icon: contact['avatar'] ?? 'person.svg',
        id: MockDataConfig.contacts.indexOf(contact) + 1,
        status: contact['status'] ?? 'Online',
        profileImage: contact['profileImage'],
      );
      
      models.add(chatModel);
    }
    
    setState(() {
      chatmodels = models;
    });
  }

  void _loadDefaultChatModels() {
    // Fallback to original hardcoded models
    chatmodels = [
      ChatModel(
        name: "張小明",
        isGroup: false,
        currentMessage: "明天開會記得帶文件",
        time: "14:30",
        icon: "person.svg",
        id: 1,
        status: "在線",
      ),
      ChatModel(
        name: "李美玲",
        isGroup: false,
        currentMessage: "謝謝你的幫助！",
        time: "13:45",
        icon: "person.svg",
        id: 2,
        status: "最後上線 2 小時前",
      ),
      ChatModel(
        name: "王建國",
        isGroup: false,
        currentMessage: "項目進度如何？",
        time: "12:20",
        icon: "person.svg",
        id: 3,
        status: "最後上線 1 小時前",
      ),
      ChatModel(
        name: "陳雅婷",
        isGroup: false,
        currentMessage: "週末一起吃飯嗎？",
        time: "11:15",
        icon: "person.svg",
        id: 4,
        status: "在線",
      ),
      ChatModel(
        name: "劉志強",
        isGroup: false,
        currentMessage: "文件已發送",
        time: "10:30",
        icon: "person.svg",
        id: 5,
        status: "最後上線 30 分鐘前",
      ),
      ChatModel(
        name: "黃小華",
        isGroup: false,
        currentMessage: "會議改到下午3點",
        time: "09:45",
        icon: "person.svg",
        id: 6,
        status: "最後上線 1 小時前",
      ),
      ChatModel(
        name: "林志明",
        isGroup: false,
        currentMessage: "好的，沒問題",
        time: "昨天",
        icon: "person.svg",
        id: 7,
        status: "最後上線 昨天",
      ),
      ChatModel(
        name: "吳雅芳",
        isGroup: false,
        currentMessage: "生日快樂！🎉",
        time: "昨天",
        icon: "person.svg",
        id: 8,
        status: "最後上線 昨天",
      ),
      ChatModel(
        name: "Flutter 開發群組",
        isGroup: true,
        currentMessage: "張小明: 新的UI組件完成了",
        time: "14:25",
        icon: "groups.svg",
        id: 9,
        status: "群組 • 15 人",
      ),
      ChatModel(
        name: "公司公告群",
        isGroup: true,
        currentMessage: "管理員: 下週一全體會議",
        time: "13:00",
        icon: "groups.svg",
        id: 10,
        status: "群組 • 45 人",
      ),
      ChatModel(
        name: "朋友聚會群",
        isGroup: true,
        currentMessage: "李美玲: 週末去哪裡玩？",
        time: "12:30",
        icon: "groups.svg",
        id: 11,
        status: "群組 • 8 人",
      ),
    ];
  }
  
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text(
                'Loading chat history...',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }
    
    return Scaffold(
      body: chatmodels.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 20),
                  Text(
                    "No chats available",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Try restarting the app",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: chatmodels.length,
              itemBuilder: (contex, index) => InkWell(
                    onTap: () {
                      sourceChat = chatmodels[index];
                      List<ChatModel> remainingChats = List.from(chatmodels);
                      remainingChats.removeAt(index);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => Homescreen(
                                    chatmodels: remainingChats,
                                    sourchat: sourceChat!,
                                  )));
                    },
                    child: ButtonCard(
                      name: chatmodels[index].name,
                      icon: chatmodels[index].isGroup == true ? Icons.group : Icons.person,
                    ),
                  )),
    );
  }
}

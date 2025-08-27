import 'package:chatapp/CustomUI/ButtonCard.dart';
import 'package:chatapp/Model/ChatModel.dart';
import 'package:chatapp/Model/MessageModel.dart';
import 'package:chatapp/Screens/Homescreen.dart';
import 'package:chatapp/database/DatabaseHelper.dart';
import 'package:chatapp/database/DatabaseSeeder.dart';
import 'package:chatapp/config/MockDataConfig.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  ChatModel? sourceChat;
  List<ChatModel> chatModels = [];
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeChatData();
  }

  Future<void> _initializeChatData() async {
    try {
      // Initialize database connection
      await _databaseHelper.database;
      
      // Seed database if needed
      if (await DatabaseSeeder.needsSeeding()) {
        await DatabaseSeeder.seedDatabase();
      }
      
      // Load chat models from configuration
      await _loadChatModels();
      
    } catch (e, stackTrace) {
      debugPrint('Initialization error: $e\n$stackTrace');
      setState(() {
        errorMessage = 'Failed to load chats: ${e.toString().split(':').first}';
        _loadDefaultChatModels(); // Fallback to defaults
      });
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _loadChatModels() async {
    final List<ChatModel> models = [];
    
  for (final contact in MockDataConfig.contacts) {
      // Get contact ID or generate if missing
  final int contactIndex = MockDataConfig.contacts.indexOf(contact);
      final int chatId = contact['id'] ?? (contactIndex + 1);
      
      // Get latest message info from database
      String lastMessage = contact['name'] ?? 'Unknown';
      String lastTime = 'Now';
      
      try {
        final List<MessageModel> messages = await _databaseHelper.getMessages(chatId);
        if (messages.isNotEmpty) {
          lastMessage = messages.last.message ?? lastMessage;
          lastTime = messages.last.time ?? lastTime;
        }
      } catch (e) {
        debugPrint('Error loading messages for ${contact['name']}: $e');
        // Continue with default message info
      }
      
      // Create chat model
      models.add(ChatModel(
        name: contact['name'] ?? 'Unknown Contact',
        isGroup: contact['avatar'] == 'group.svg',
        currentMessage: lastMessage,
        time: lastTime,
        icon: contact['avatar'] ?? 'person.svg',
        id: chatId,
        status: contact['status'] ?? 'Online',
        profileImage: contact['profileImage'],
      ));
    }
    
    setState(() => chatModels = models);
  }

  void _loadDefaultChatModels() {
    // Fallback chat models when database fails
    chatModels = [
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
    ];
  }

  void _handleChatSelection(int index) {
    setState(() => sourceChat = chatModels[index]);
    final List<ChatModel> remainingChats = List.from(chatModels)..removeAt(index);
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Homescreen(
          chatmodels: remainingChats,
          sourchat: sourceChat!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Account'),
        backgroundColor: const Color(0xFF075E54),
        elevation: 0,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFF075E54)),
            SizedBox(height: 20),
            Text(
              'Loading chat history...',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      );
    }

    if (errorMessage != null) {
      _showErrorSnackbar();
    }

    if (chatModels.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.chat_bubble_outline,
                size: 80,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 20),
              Text(
                "No chats available",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Please try restarting the app",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _initializeChatData(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: chatModels.length,
      itemBuilder: (context, index) => InkWell(
        onTap: () => _handleChatSelection(index),
        borderRadius: BorderRadius.circular(8),
        child: ButtonCard(
          name: chatModels[index].name,
          icon: (chatModels[index].isGroup == true) ? Icons.group : Icons.person,
        ),
      ),
    );
  }

  void _showErrorSnackbar() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage!),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'Dismiss',
            textColor: Colors.white,
            onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
          ),
        ),
      );
    });
  }
}

import 'package:chatapp/CustomUI/CustomCard.dart';
import 'package:chatapp/Model/ChatModel.dart';
import 'package:chatapp/Model/MessageModel.dart';
import 'package:chatapp/database/DatabaseHelper.dart';
import 'package:chatapp/database/DatabaseSeeder.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  ChatPage({Key? key, this.chatmodels, this.sourchat}) : super(key: key);
  final List<ChatModel>? chatmodels;
  final ChatModel? sourchat;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<ChatModel> updatedChatModels = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    print('=== CHAT PAGE INIT STATE ===');
    _initializeDatabaseAndLoadMessages();
  }

  Future<void> _initializeDatabaseAndLoadMessages() async {
    try {
      // Initialize database without clearing data
      await _databaseHelper.database;
      print('Database initialized');
      
      // Check if database needs seeding
      if (await DatabaseSeeder.needsSeeding()) {
        await DatabaseSeeder.seedDatabase();
      }
      
      // Print current database contents for debugging
      await _databaseHelper.printDatabaseContents();
    } catch (e) {
      print('Error initializing database: $e');
    }
    
    // Load messages from database and original models
    await _loadLatestMessages();
  }



  @override
  void didUpdateWidget(ChatPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Refresh when widget updates
    _loadLatestMessages();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh when dependencies change (like returning from chat)
    _loadLatestMessages();
  }

  Future<void> _loadLatestMessages() async {
    setState(() {
      isLoading = true;
    });
    
    print('=== LOADING LATEST MESSAGES ===');
    print('Number of chat models: ${widget.chatmodels?.length ?? 0}');
    
    List<ChatModel> updatedModels = [];
    
    if (widget.chatmodels != null && widget.chatmodels!.isNotEmpty) {
      for (ChatModel chatModel in widget.chatmodels!) {
        print('Processing chat: ${chatModel.name} (ID: ${chatModel.id})');
        
        try {
          // Get the latest message from database for this chat
          List<MessageModel> messages = await _databaseHelper.getMessages(chatModel.id ?? 0);
          
          if (messages.isNotEmpty) {
            // Use the latest message from database
            MessageModel latestMessage = messages.last;
            print('📱 Latest DB message for ${chatModel.name}: ${latestMessage.message}');
            
            // Create updated chat model with latest message
            ChatModel updatedChat = ChatModel(
              name: chatModel.name,
              id: chatModel.id,
              currentMessage: latestMessage.message,
              time: latestMessage.time,
              icon: chatModel.icon,
              isGroup: chatModel.isGroup,
              status: chatModel.status,
              profileImage: chatModel.profileImage,
            );
            updatedModels.add(updatedChat);
          } else {
            // No messages in database, use original
            print('📱 No DB messages for ${chatModel.name}, using original: ${chatModel.currentMessage}');
            updatedModels.add(chatModel);
          }
        } catch (e) {
          print('Error loading messages for ${chatModel.name}: $e');
          // Fallback to original message
          updatedModels.add(chatModel);
        }
      }
    }
    
    print('Final updated models count: ${updatedModels.length}');
    for (var model in updatedModels) {
      print('Final message for ${model.name}: ${model.currentMessage}');
    }
    
    setState(() {
      updatedChatModels = updatedModels;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          // Refresh messages when returning to this screen
          await _loadLatestMessages();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
        children: [
          if (isLoading)
            Container(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 8),
                  Text('Loading latest messages...'),
                ],
              ),
            ),
          Expanded(
            child: (updatedChatModels.isEmpty && (widget.chatmodels?.isEmpty ?? true))
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
                          "開始聊天",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "點擊下方按鈕開始新的對話",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadLatestMessages,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: updatedChatModels.isNotEmpty ? updatedChatModels.length : (widget.chatmodels?.length ?? 0),
                      itemBuilder: (contex, index) => CustomCard(
                        chatModel: updatedChatModels.isNotEmpty ? updatedChatModels[index] : widget.chatmodels?[index] ?? ChatModel(name: "Unknown", id: 0),
                        sourchat: widget.sourchat,
                      ),
                    ),
                  ),
          ),
        ],
      ),
        ),
    );
  }
}

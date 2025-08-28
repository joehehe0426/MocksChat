import 'package:chatapp/CustomUI/CustomCard.dart';
import 'package:chatapp/Screens/IndividualPage.dart';
import 'package:chatapp/Model/ChatModel.dart';
// Database removed: using in-memory messages on ChatModel
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  ChatPage({Key? key, this.chatmodels, this.sourchat}) : super(key: key);
  final List<ChatModel>? chatmodels;
  final ChatModel? sourchat;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<ChatModel> updatedChatModels = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  print('=== CHAT PAGE INIT STATE ===');
  // no DB: just load from provided models
  _loadLatestMessages();
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
    
    print('=== LOADING LATEST MESSAGES (in-memory) ===');
    List<ChatModel> updatedModels = [];
    if (widget.chatmodels != null && widget.chatmodels!.isNotEmpty) {
      for (ChatModel chatModel in widget.chatmodels!) {
        print('Processing chat: ${chatModel.name} (ID: ${chatModel.id})');
        // Use last message from in-memory list if present
        final msgs = chatModel.messages ?? [];
        if (msgs.isNotEmpty) {
          final last = msgs.last;
          updatedModels.add(ChatModel(
            name: chatModel.name,
            id: chatModel.id,
            currentMessage: last.message,
            time: last.time,
            icon: chatModel.icon,
            isGroup: chatModel.isGroup,
            status: chatModel.status,
            profileImage: chatModel.profileImage,
            messages: msgs,
          ));
        } else {
          updatedModels.add(chatModel);
        }
      }
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
                      itemBuilder: (context, index) {
                        final chatModel = updatedChatModels.isNotEmpty
                            ? updatedChatModels[index]
                            : widget.chatmodels?[index] ?? ChatModel(name: "Unknown", id: 0);
                        return CustomCard(
                          chatModel: chatModel,
                          sourchat: widget.sourchat,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => IndividualPage(
                                  chatModel: chatModel,
                                  sourchat: widget.sourchat,
                                ),
                              ),
                            ).then((_) {
                              // reload latest messages when returning from the chat
                              _loadLatestMessages();
                            });
                          },
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
        ),
    );
  }
}

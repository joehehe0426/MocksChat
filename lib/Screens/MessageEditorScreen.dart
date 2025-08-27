import 'package:flutter/material.dart';
import 'package:chatapp/Model/ChatModel.dart';
import 'package:chatapp/Model/MessageModel.dart';
import 'package:chatapp/database/DatabaseHelper.dart';

class MessageEditorScreen extends StatefulWidget {
  final ChatModel chatModel;
  final ChatModel sourceChat;

  MessageEditorScreen({Key? key, required this.chatModel, required this.sourceChat}) : super(key: key);

  @override
  _MessageEditorScreenState createState() => _MessageEditorScreenState();
}

class _MessageEditorScreenState extends State<MessageEditorScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<MessageModel> _messages = [];
  bool _isLoading = true;
  bool _messagesEdited = false;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    try {
      int chatId = widget.chatModel.id ?? 0;
      List<MessageModel> dbMessages = await _databaseHelper.getMessages(chatId);
      
      // Clean up any messages with invalid types
      await _cleanupInvalidMessageTypes(chatId, dbMessages);
      
      if (dbMessages.isEmpty) {
        // Load default mock messages
        _addDefaultMessages();
        // Save to database
        for (MessageModel message in _messages) {
          await _databaseHelper.insertMessage(message, chatId);
        }
      } else {
        _messages = dbMessages;
      }
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading messages: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _cleanupInvalidMessageTypes(int chatId, List<MessageModel> messages) async {
    // This is a placeholder for cleaning up invalid message types
    // In a real app, you would update the database to fix invalid types
    print('Checking for invalid message types in chat $chatId');
    for (MessageModel message in messages) {
      if (message.type != "source" && message.type != "destination") {
        print('Found invalid message type: ${message.type}, will be handled by dropdown validation');
      }
    }
  }

  void _addDefaultMessages() {
    String chatName = widget.chatModel.name ?? '';
    
    if (chatName.contains("李美玲")) {
      _messages = [
        MessageModel(type: "destination", message: "謝謝你的幫助！", time: "13:45"),
        MessageModel(type: "source", message: "不客氣，應該的", time: "13:50"),
        MessageModel(type: "destination", message: "你真的幫了我很多", time: "13:55"),
        MessageModel(type: "source", message: "朋友之間互相幫助是應該的", time: "14:00"),
        MessageModel(type: "destination", message: "下次請你吃飯！", time: "14:05"),
      ];
    } else if (chatName.contains("John")) {
      _messages = [
        MessageModel(type: "destination", message: "Hi! How are you?", time: "10:00"),
        MessageModel(type: "source", message: "I'm good, thanks! How about you?", time: "10:05"),
        MessageModel(type: "destination", message: "Great! Ready for tomorrow's meeting?", time: "10:10"),
        MessageModel(type: "source", message: "Yes, I've prepared all the documents", time: "10:15"),
        MessageModel(type: "destination", message: "Perfect! See you then", time: "10:20"),
      ];
    } else {
      _messages = [
        MessageModel(type: "destination", message: "Hello!", time: "10:00"),
        MessageModel(type: "source", message: "Hi there! How's everything?", time: "10:05"),
        MessageModel(type: "destination", message: "All good, thanks!", time: "10:10"),
        MessageModel(type: "source", message: "Great to hear!", time: "10:15"),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
         return PopScope(
       onPopInvokedWithResult: (didPop, result) async {
         if (didPop) {
           Navigator.of(context).pop(_messagesEdited);
         }
       },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop(_messagesEdited);
            },
          ),
          title: Text('Edit Messages - ${widget.chatModel.name}', style: TextStyle(color: Colors.white)),
          backgroundColor: Color(0xFF075E54),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: _addNewMessage,
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              switch (value) {
                case 'clear':
                  _clearAllMessages();
                  break;
                case 'template':
                  _loadMessageTemplate();
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'clear', child: Text('Clear All Messages')),
              PopupMenuItem(value: 'template', child: Text('Load Template')),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  color: Colors.green[50],
                  child: Row(
                    children: [
                      Icon(Icons.info, color: Colors.green),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Tap messages to edit, long press to delete. Use + to add new messages.',
                          style: TextStyle(color: Colors.green[800]),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      final isSource = message.type == "source";
                      
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        child: Row(
                          mainAxisAlignment: isSource ? MainAxisAlignment.end : MainAxisAlignment.start,
                          children: [
                            if (!isSource) ...[
                              CircleAvatar(
                                radius: 12,
                                backgroundColor: Colors.grey[400],
                                child: Text('T', style: TextStyle(fontSize: 10, color: Colors.white)),
                              ),
                              SizedBox(width: 8),
                            ],
                            Flexible(
                              child: GestureDetector(
                                onTap: () => _editMessage(index),
                                onLongPress: () => _deleteMessage(index),
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: isSource ? Color(0xFFDCF8C6) : Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.grey[300] ?? Colors.grey),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        message.message ?? '',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(height: 4),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            message.time ?? '',
                                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                          ),
                                          SizedBox(width: 4),

                                          Icon(
                                            isSource ? Icons.person : Icons.person_outline,
                                            size: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            if (isSource) ...[
                              SizedBox(width: 8),
                              CircleAvatar(
                                radius: 12,
                                backgroundColor: Colors.blue[400],
                                child: Text('M', style: TextStyle(fontSize: 10, color: Colors.white)),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
      ),
    );
  }



  void _addNewMessage() {
    showDialog(
      context: context,
      builder: (context) => _MessageEditDialog(
        message: null,
        onSave: (newMessage) async {
          setState(() {
            _messages.add(newMessage);
            _messagesEdited = true;
          });
          
          // Save to database
          int chatId = widget.chatModel.id ?? 0;
          await _databaseHelper.insertMessage(newMessage, chatId);
          await _databaseHelper.updateChatSession(chatId, newMessage.message ?? '', newMessage.time ?? '');
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Message added and saved')),
            );
          }
        },
      ),
    );
  }

  void _editMessage(int index) {
    showDialog(
      context: context,
      builder: (context) => _MessageEditDialog(
        message: _messages[index],
        onSave: (updatedMessage) async {
          setState(() {
            _messages[index] = updatedMessage;
            _messagesEdited = true;
          });
          
          // Save the updated message to database
          int chatId = widget.chatModel.id ?? 0;
          
          // First, delete the old message and insert the new one
          // This is a simple approach - in a real app you'd want to update the specific message
          await _databaseHelper.deleteChatMessages(chatId);
          
          // Re-insert all messages with the updated one
          for (int i = 0; i < _messages.length; i++) {
            await _databaseHelper.insertMessage(_messages[i], chatId);
          }
          
          // Update the chat session
          if (_messages.isNotEmpty) {
            final lastMessage = _messages.last;
            await _databaseHelper.updateChatSession(chatId, lastMessage.message ?? '', lastMessage.time ?? '');
          }
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Message updated and saved')),
            );
          }
        },
      ),
    );
  }

  void _deleteMessage(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Message'),
        content: Text('Are you sure you want to delete this message?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              setState(() {
                _messages.removeAt(index);
                _messagesEdited = true;
              });
              
              // Save the updated message list to database
              int chatId = widget.chatModel.id ?? 0;
              await _databaseHelper.deleteChatMessages(chatId);
              
              // Re-insert all remaining messages
              for (int i = 0; i < _messages.length; i++) {
                await _databaseHelper.insertMessage(_messages[i], chatId);
              }
              
              // Update the chat session
              if (_messages.isNotEmpty) {
                final lastMessage = _messages.last;
                await _databaseHelper.updateChatSession(chatId, lastMessage.message ?? '', lastMessage.time ?? '');
              }
              
              Navigator.pop(context);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Message deleted and saved')),
                );
              }
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _clearAllMessages() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear All Messages'),
        content: Text('Are you sure you want to delete all messages in this conversation?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              int chatId = widget.chatModel.id ?? 0;
              await _databaseHelper.deleteChatMessages(chatId);
              await _databaseHelper.updateChatSession(chatId, '', '');
              setState(() {
                _messages.clear();
                _messagesEdited = true;
              });
                             Navigator.pop(context);
               if (mounted) {
                 ScaffoldMessenger.of(context).showSnackBar(
                   const SnackBar(content: Text('All messages cleared and saved')),
                 );
               }
            },
            child: Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _loadMessageTemplate() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Load Message Template'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Business Conversation'),
              onTap: () => _applyTemplate('business'),
            ),
            ListTile(
              title: Text('Casual Chat'),
              onTap: () => _applyTemplate('casual'),
            ),
            ListTile(
              title: Text('Family Chat'),
              onTap: () => _applyTemplate('family'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _applyTemplate(String templateType) async {
    List<MessageModel> templateMessages = [];
    
    switch (templateType) {
      case 'business':
        templateMessages = [
          MessageModel(type: "destination", message: "Good morning! Ready for the presentation?", time: "09:00"),
          MessageModel(type: "source", message: "Yes, all slides are prepared", time: "09:05"),
          MessageModel(type: "destination", message: "Great! The client will be here at 10 AM", time: "09:10"),
          MessageModel(type: "source", message: "Perfect, I'll be ready", time: "09:15"),
        ];
        break;
      case 'casual':
        templateMessages = [
          MessageModel(type: "destination", message: "Hey! What's up? 😊", time: "14:00"),
          MessageModel(type: "source", message: "Not much, just relaxing. You?", time: "14:05"),
          MessageModel(type: "destination", message: "Same here! Want to grab coffee later?", time: "14:10"),
          MessageModel(type: "source", message: "Sounds good! What time?", time: "14:15"),
        ];
        break;
      case 'family':
        templateMessages = [
          MessageModel(type: "destination", message: "Don't forget dinner at 7 PM", time: "16:00"),
          MessageModel(type: "source", message: "I'll be there! Should I bring anything?", time: "16:05"),
          MessageModel(type: "destination", message: "Just yourself! Mom is cooking your favorite", time: "16:10"),
          MessageModel(type: "source", message: "Awesome! Can't wait 😋", time: "16:15"),
        ];
        break;
    }
    
    // Save template messages to database
    int chatId = widget.chatModel.id ?? 0;
    await _databaseHelper.deleteChatMessages(chatId);
    
    // Insert all template messages
    for (int i = 0; i < templateMessages.length; i++) {
      await _databaseHelper.insertMessage(templateMessages[i], chatId);
    }
    
    // Update chat session
    if (templateMessages.isNotEmpty) {
      final lastMessage = templateMessages.last;
      await _databaseHelper.updateChatSession(chatId, lastMessage.message ?? '', lastMessage.time ?? '');
    }
    
    setState(() {
      _messages = templateMessages;
      _messagesEdited = true;
    });
    
         Navigator.pop(context);
     if (mounted) {
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text('$templateType template loaded and saved')),
       );
     }
  }
}

class _MessageEditDialog extends StatefulWidget {
  final MessageModel? message;
  final Function(MessageModel) onSave;

  _MessageEditDialog({required this.message, required this.onSave});

  @override
  _MessageEditDialogState createState() => _MessageEditDialogState();
}

class _MessageEditDialogState extends State<_MessageEditDialog> {
  late TextEditingController _messageController;
  late TextEditingController _timeController;
  String _messageType = "source";

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController(text: widget.message?.message ?? '');
    _timeController = TextEditingController(text: widget.message?.time ?? _getCurrentTime());
    // Ensure the message type is valid
    String messageType = widget.message?.type ?? "source";
    if (messageType != "source" && messageType != "destination") {
      messageType = "source"; // Default to source if invalid type
    }
    _messageType = messageType;
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    // Ensure _messageType is valid before building dropdown
    if (_messageType != "source" && _messageType != "destination") {
      _messageType = "source";
    }
    
    return AlertDialog(
      title: Text(widget.message == null ? 'Add Message' : 'Edit Message'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _messageController,
              decoration: InputDecoration(labelText: 'Message'),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _timeController,
              decoration: InputDecoration(labelText: 'Time (HH:MM)'),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text('Message from: '),
                Expanded(
                  child: DropdownButton<String>(
                    value: _messageType,
                    isExpanded: true,
                    items: [
                      DropdownMenuItem(value: "source", child: Text("Me")),
                      DropdownMenuItem(value: "destination", child: Text("Them")),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _messageType = value ?? "source";
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_messageController.text.isNotEmpty) {
              final newMessage = MessageModel(
                message: _messageController.text,
                time: _timeController.text,
                type: _messageType,
              );
              widget.onSave(newMessage);
              Navigator.pop(context);
            }
          },
          child: Text('Save'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _timeController.dispose();
    super.dispose();
  }
}

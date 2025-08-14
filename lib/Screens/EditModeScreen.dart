import 'package:flutter/material.dart';
import 'package:chatapp/Model/ChatModel.dart';
import 'package:chatapp/database/DatabaseHelper.dart';
import 'package:chatapp/Screens/MessageEditorScreen.dart';

class EditModeScreen extends StatefulWidget {
  final List<ChatModel> chatModels;
  final ChatModel sourceChat;

  EditModeScreen({Key? key, required this.chatModels, required this.sourceChat}) : super(key: key);

  @override
  _EditModeScreenState createState() => _EditModeScreenState();
}

class _EditModeScreenState extends State<EditModeScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<ChatModel> _editableChatModels = [];
  bool _presentationMode = false;

  @override
  void initState() {
    super.initState();
    _editableChatModels = List.from(widget.chatModels);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Mode', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF075E54),
        actions: [
          Switch(
            value: _presentationMode,
            onChanged: (value) {
              setState(() {
                _presentationMode = value;
              });
            },
            activeColor: Colors.white,
          ),
          Text('Present', style: TextStyle(color: Colors.white, fontSize: 12)),
          SizedBox(width: 16),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              switch (value) {
                case 'reset':
                  _resetToDefaults();
                  break;
                case 'templates':
                  _showTemplates();
                  break;
                case 'export':
                  _exportData();
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'reset', child: Text('Reset to Defaults')),
              PopupMenuItem(value: 'templates', child: Text('Load Templates')),
              PopupMenuItem(value: 'export', child: Text('Export Data')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          if (!_presentationMode) ...[
            Container(
              padding: EdgeInsets.all(16),
              color: Colors.blue[50],
              child: Row(
                children: [
                  Icon(Icons.info, color: Colors.blue),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Edit Mode: Tap contacts to edit messages, use + to add new contacts',
                      style: TextStyle(color: Colors.blue[800]),
                    ),
                  ),
                ],
              ),
            ),
          ],
          Expanded(
            child: ListView.builder(
              itemCount: _editableChatModels.length,
              itemBuilder: (context, index) {
                final chat = _editableChatModels[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: chat.isGroup == true ? Colors.green : Colors.blue,
                      child: Icon(
                        chat.isGroup == true ? Icons.group : Icons.person,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(chat.name ?? ''),
                    subtitle: Text(chat.currentMessage ?? ''),
                    trailing: _presentationMode ? null : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editContact(index),
                        ),
                        IconButton(
                          icon: Icon(Icons.message, color: Colors.green),
                          onPressed: () => _editMessages(chat),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteContact(index),
                        ),
                      ],
                    ),
                    onTap: _presentationMode ? null : () => _editMessages(chat),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: _presentationMode ? null : FloatingActionButton(
        onPressed: _addNewContact,
        backgroundColor: Color(0xFF00C851),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _editContact(int index) {
    final chat = _editableChatModels[index];
    showDialog(
      context: context,
      builder: (context) => _ContactEditDialog(
        chat: chat,
        onSave: (updatedChat) {
          setState(() {
            _editableChatModels[index] = updatedChat;
          });
        },
      ),
    );
  }

  void _editMessages(ChatModel chat) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MessageEditorScreen(
          chatModel: chat,
          sourceChat: widget.sourceChat,
        ),
      ),
    );
    
    // If messages were edited, show a notification
    if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Messages updated! The changes will be reflected when you open the chat.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _deleteContact(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Contact'),
        content: Text('Are you sure you want to delete this contact and all messages?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final chatId = _editableChatModels[index].id ?? 0;
              await _databaseHelper.deleteChatData(chatId);
              setState(() {
                _editableChatModels.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _addNewContact() {
    showDialog(
      context: context,
      builder: (context) => _ContactEditDialog(
        chat: null,
        onSave: (newChat) {
          setState(() {
            newChat.id = DateTime.now().millisecondsSinceEpoch;
            _editableChatModels.add(newChat);
          });
        },
      ),
    );
  }

  void _resetToDefaults() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reset to Defaults'),
        content: Text('This will restore the original chat list and clear all custom data. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              // Clear database
              for (var chat in _editableChatModels) {
                await _databaseHelper.deleteChatData(chat.id ?? 0);
              }
              
              // Reset to original data
              setState(() {
                _editableChatModels = _getDefaultChatModels();
              });
              
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Reset to defaults complete')),
              );
            },
            child: Text('Reset', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showTemplates() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Load Template'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Business Meeting'),
              onTap: () => _loadTemplate('business'),
            ),
            ListTile(
              title: Text('Casual Friends'),
              onTap: () => _loadTemplate('casual'),
            ),
            ListTile(
              title: Text('Family Group'),
              onTap: () => _loadTemplate('family'),
            ),
            ListTile(
              title: Text('Study Group'),
              onTap: () => _loadTemplate('study'),
            ),
          ],
        ),
      ),
    );
  }

  void _loadTemplate(String templateType) {
    // Implementation for loading different templates
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$templateType template loaded')),
    );
  }

  void _exportData() {
    // Implementation for exporting chat data
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Export functionality coming soon')),
    );
  }

  List<ChatModel> _getDefaultChatModels() {
    return [
      ChatModel(
        name: "John Smith",
        isGroup: false,
        currentMessage: "See you at the meeting tomorrow",
        time: "14:30",
        icon: "person.svg",
        id: 1,
        status: "Online",
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
      // Add more default contacts...
    ];
  }
}

class _ContactEditDialog extends StatefulWidget {
  final ChatModel? chat;
  final Function(ChatModel) onSave;

  _ContactEditDialog({required this.chat, required this.onSave});

  @override
  _ContactEditDialogState createState() => _ContactEditDialogState();
}

class _ContactEditDialogState extends State<_ContactEditDialog> {
  late TextEditingController _nameController;
  late TextEditingController _messageController;
  late TextEditingController _timeController;
  late TextEditingController _statusController;
  bool _isGroup = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.chat?.name ?? '');
    _messageController = TextEditingController(text: widget.chat?.currentMessage ?? '');
    _timeController = TextEditingController(text: widget.chat?.time ?? '');
    _statusController = TextEditingController(text: widget.chat?.status ?? '');
    _isGroup = widget.chat?.isGroup ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.chat == null ? 'Add Contact' : 'Edit Contact'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _messageController,
              decoration: InputDecoration(labelText: 'Last Message'),
            ),
            TextField(
              controller: _timeController,
              decoration: InputDecoration(labelText: 'Time'),
            ),
            TextField(
              controller: _statusController,
              decoration: InputDecoration(labelText: 'Status'),
            ),
            SwitchListTile(
              title: Text('Group Chat'),
              value: _isGroup,
              onChanged: (value) {
                setState(() {
                  _isGroup = value;
                });
              },
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
            final updatedChat = ChatModel(
              name: _nameController.text,
              currentMessage: _messageController.text,
              time: _timeController.text,
              status: _statusController.text,
              isGroup: _isGroup,
              icon: _isGroup ? "groups.svg" : "person.svg",
              id: widget.chat?.id ?? DateTime.now().millisecondsSinceEpoch,
            );
            widget.onSave(updatedChat);
            Navigator.pop(context);
          },
          child: Text('Save'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _messageController.dispose();
    _timeController.dispose();
    _statusController.dispose();
    super.dispose();
  }
}

import 'package:chatapp/Model/ChatModel.dart';
import 'package:chatapp/Model/MessageModel.dart';
import 'package:chatapp/database/DatabaseHelper.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';

class IndividualPage extends StatefulWidget {
  final ChatModel? chatModel;
  final ChatModel? sourchat;

  const IndividualPage({
    Key? key,
    this.chatModel,
    this.sourchat,
  }) : super(key: key);

  @override
  _IndividualPageState createState() => _IndividualPageState();
}

class _IndividualPageState extends State<IndividualPage> {
  // UI State
  bool _showEmojiPicker = false;
  FocusNode _messageFocusNode = FocusNode();
  bool _isSendButtonActive = false;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Message State
  List<MessageModel> _chatItems = [];

  @override
  void initState() {
    super.initState();
    _setupFocusListener();
    _loadChatHistory();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _messageFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _setupFocusListener() {
    _messageFocusNode.addListener(() {
      if (_messageFocusNode.hasFocus && mounted) {
        setState(() => _showEmojiPicker = false);
      }
    });
  }

  Future<void> _sendMessage(String messageContent) async {
    if (messageContent.trim().isEmpty) return;

    final newMessage = MessageModel(
      type: 'source',
      message: messageContent.trim(),
      time: _getCurrentTime(),
      date: DateTime.now().toIso8601String().split('T')[0],
    );

    // Add to local state
    setState(() {
      _chatItems.add(newMessage);
    });

    // Save to database
    try {
      if (widget.chatModel?.id != null) {
        final databaseHelper = DatabaseHelper();
        await databaseHelper.insertMessage(newMessage, widget.chatModel!.id!);
      }
    } catch (e) {
      print('Error saving message to database: $e');
    }

    _messageController.clear();
    setState(() => _isSendButtonActive = false);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients && mounted) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  void _toggleEmojiPicker() {
    setState(() => _showEmojiPicker = !_showEmojiPicker);
    if (!_showEmojiPicker) {
      _messageFocusNode.requestFocus();
    }
  }

  // Load chat history from database
  Future<void> _loadChatHistory() async {
    try {
      if (widget.chatModel?.id != null) {
        final databaseHelper = DatabaseHelper();
        final messages = await databaseHelper.getMessages(widget.chatModel!.id!);
        
        if (mounted) {
          setState(() {
            _chatItems = messages;
          });
          
          // Scroll to bottom after loading messages
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToBottom();
          });
        }
      }
    } catch (e) {
      print('Error loading chat history: $e');
    }
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 35,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: _toggleEmojiPicker,
                    child: Container(
                      margin: const EdgeInsets.only(left: 6),
                      child: Icon(
                        Icons.emoji_emotions,
                        color: Colors.grey[500],
                        size: 25,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      focusNode: _messageFocusNode,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: const InputDecoration(
                        hintText: "Message",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 4),
                      ),
                      onChanged: (value) {
                        setState(() => _isSendButtonActive = value.trim().isNotEmpty);
                      },
                      onSubmitted: (value) => _sendMessage(value),
                      style: const TextStyle(fontSize: 16),
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            height: 50,
            width: 50,
            decoration: const BoxDecoration(
              color: Color(0xFF25D366),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: _isSendButtonActive
                  ? () => _sendMessage(_messageController.text)
                  : null,
              icon: Icon(
                _isSendButtonActive ? Icons.send : Icons.mic,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        controller: _scrollController,
        itemCount: _chatItems.length + 1,
        itemBuilder: (context, index) {
          if (index == _chatItems.length) {
            return const SizedBox(height: 100);
          }

          final message = _chatItems[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              mainAxisAlignment: message.type == 'source' 
                  ? MainAxisAlignment.end 
                  : MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: message.type == 'source' 
                        ? const Color(0xFF25D366) 
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Show image if attachment exists
                      if (message.attachmentType == 'image' && message.attachmentPath != null)
                        Container(
                          margin: const EdgeInsets.only(bottom: 4),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              message.attachmentPath!,
                              width: 200,
                              height: 150,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 200,
                                  height: 150,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.image_not_supported, color: Colors.grey),
                                );
                              },
                            ),
                          ),
                        ),
                      // Show message text
                      if (message.message != null && message.message!.isNotEmpty)
                        Text(
                          message.message!,
                          style: TextStyle(
                            color: message.type == 'source' ? Colors.white : Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      // Show attachment name if exists
                      if (message.attachmentName != null && message.attachmentName!.isNotEmpty)
                        Text(
                          message.attachmentName!,
                          style: TextStyle(
                            color: message.type == 'source' ? Colors.white70 : Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmojiPicker() {
    return EmojiPicker(
      onEmojiSelected: (_, emoji) {
        setState(() {
          _messageController.text += emoji.emoji;
          _isSendButtonActive = _messageController.text.trim().isNotEmpty;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF075E54),
        elevation: 0,
        leadingWidth: 75,
        titleSpacing: 0,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.arrow_back, size: 24),
              const SizedBox(width: 8),
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[300],
                backgroundImage: widget.chatModel?.profileImage != null && widget.chatModel!.profileImage!.isNotEmpty
                    ? AssetImage(widget.chatModel!.profileImage!)
                    : null,
                child: widget.chatModel?.profileImage == null || widget.chatModel!.profileImage!.isEmpty
                    ? Text(
                        widget.chatModel?.name?.substring(0, 1).toUpperCase() ?? '?',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )
                    : null,
              ),
            ],
          ),
        ),
        title: Container(
          margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.chatModel?.name ?? 'Unknown Contact',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const Text(
                "last seen today at 12:05",
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.call_outlined),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {},
            itemBuilder: (_) => [
              const PopupMenuItem(child: Text("View Contact"), value: "View Contact"),
              const PopupMenuItem(child: Text("Media"), value: "Media"),
              const PopupMenuItem(child: Text("Search"), value: "Search"),
            ],
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/whatsapp_Back.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          bottom: true,
          child: Column(
            children: [
              _buildMessageList(),
              _buildMessageInput(),
              if (_showEmojiPicker) _buildEmojiPicker(),
            ],
          ),
        ),
      ),
    );
  }
}

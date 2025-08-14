import 'package:chatapp/CustomUI/OwnMessgaeCrad.dart';
import 'package:chatapp/CustomUI/ReplyCard.dart';
import 'package:chatapp/CustomUI/DateHeader.dart';
import 'package:chatapp/CustomUI/CachedAvatar.dart';
import 'package:chatapp/Model/ChatModel.dart';
import 'package:chatapp/Model/MessageModel.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chatapp/database/DatabaseHelper.dart';
import 'dart:io';

class IndividualPage extends StatefulWidget {
  IndividualPage({Key? key, this.chatModel, this.sourchat}) : super(key: key);
  final ChatModel? chatModel;
  final ChatModel? sourchat;

  @override
  _IndividualPageState createState() => _IndividualPageState();
}

class _IndividualPageState extends State<IndividualPage> {
  bool show = false;
  FocusNode focusNode = FocusNode();
  bool sendButton = false;
  List<MessageModel> messages = [];
  List<dynamic> chatItems = []; // Will contain messages and date headers
  TextEditingController _controller = TextEditingController();
  ScrollController _scrollController = ScrollController();
  String? selectedProfileImage;
  final ImagePicker _picker = ImagePicker();
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  
  @override
  void initState() {
    super.initState();
    _loadMessages();

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          show = false;
        });
      }
    });
  }



  Future<void> _loadMessages() async {
    int chatId = widget.chatModel?.id ?? 0;
    List<MessageModel> dbMessages = await _databaseHelper.getMessages(chatId);
    
    // Load profile image from database
    Map<String, dynamic>? chatSession = await _databaseHelper.getChatSession(chatId);
    if (chatSession != null && chatSession['profileImage'] != null && chatSession['profileImage'].toString().isNotEmpty) {
      setState(() {
        selectedProfileImage = chatSession['profileImage'].toString();
        if (widget.chatModel != null) {
          widget.chatModel!.profileImage = chatSession['profileImage'].toString();
        }
      });
    }
    
    if (dbMessages.isEmpty) {
      // Load mock messages if no database messages exist
      _addMockMessages();
      // Save mock messages to database
      for (MessageModel message in messages) {
        await _databaseHelper.insertMessage(message, chatId);
      }
    } else {
      setState(() {
        messages = dbMessages;
        _groupMessagesByDate();
      });
    }
  }



  @override
  void dispose() {
    _controller.dispose();
    focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _addMockMessages() {
    // No mock messages - start with empty chat
    messages = [];
  }

  void _groupMessagesByDate() {
    chatItems.clear();
    if (messages.isEmpty) return;

    String? currentDate;
    
    for (MessageModel message in messages) {
      String messageDate = message.date ?? DateTime.now().toIso8601String().split('T')[0];
      
      // Add date header if it's a new date
      if (currentDate != messageDate) {
        currentDate = messageDate;
        chatItems.add({'type': 'date_header', 'date': messageDate});
      }
      
      // Add message
      chatItems.add({'type': 'message', 'message': message});
    }
  }

  Future<void> sendMessage(String message, int sourceId, int targetId) async {
    await setMessage("source", message);
    // For educational purposes, we don't need real-time messaging
    // Just add the message locally
  }

  Future<void> setMessage(String type, String message) async {
    MessageModel messageModel = MessageModel(
        type: type,
        message: message,
        time: DateTime.now().toString().substring(10, 16),
        date: DateTime.now().toIso8601String().split('T')[0]);
    print(messages);

    setState(() {
      messages.add(messageModel);
      _groupMessagesByDate();
    });

    // Save to database
    int chatId = widget.chatModel?.id ?? 0;
    await _databaseHelper.insertMessage(messageModel, chatId);
    await _databaseHelper.updateChatSession(chatId, message, messageModel.time ?? "");
  }

  Future<void> _pickProfileImage() async {
    try {
      // Show source selection dialog
      ImageSource? source = await _showImageSourceDialog();
      if (source == null) return;

      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );
      
      if (image != null) {
        // Update the chat model with new profile image
        if (widget.chatModel != null) {
          widget.chatModel!.profileImage = image.path;
          // Save to database
          await _databaseHelper.updateProfileImage(widget.chatModel!.id ?? 0, image.path);
          print('Profile image saved to database: ${image.path}');
        }
        
        setState(() {
          selectedProfileImage = image.path;
        });
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile picture updated!'),
            backgroundColor: Color(0xFF25D366),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick image: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<ImageSource?> _showImageSourceDialog() async {
    return showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt, color: Color(0xFF25D366)),
                title: Text('Camera'),
                onTap: () {
                  Navigator.pop(context, ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library, color: Color(0xFF25D366)),
                title: Text('Gallery'),
                onTap: () {
                  Navigator.pop(context, ImageSource.gallery);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showProfileOptions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Profile Picture'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt, color: Color(0xFF25D366)),
                title: Text('Take Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickProfileImage();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library, color: Color(0xFF25D366)),
                title: Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickProfileImage();
                },
              ),
              if (selectedProfileImage != null)
                ListTile(
                  leading: Icon(Icons.delete, color: Colors.red),
                  title: Text('Remove Picture'),
                  onTap: () async {
                    Navigator.pop(context);
                    if (widget.chatModel != null) {
                      widget.chatModel!.profileImage = null;
                      // Remove from database
                      await _databaseHelper.updateProfileImage(widget.chatModel!.id ?? 0, "");
                      print('Profile image removed from database');
                    }
                    setState(() {
                      selectedProfileImage = null;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Profile picture removed'),
                        backgroundColor: Colors.orange,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF075E54),
        elevation: 0,
        leadingWidth: 70,
        titleSpacing: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.arrow_back, size: 24, color: Colors.white),
              GestureDetector(
                onTap: () {
                  _showProfileOptions();
                },
                child: CachedAvatar(
                  imagePath: selectedProfileImage,
                  fallbackIcon: widget.chatModel?.isGroup == true ? "groups.svg" : "person.svg",
                  radius: 20,
                  isGroup: widget.chatModel?.isGroup ?? false,
                  name: widget.chatModel?.name,
                  contactId: widget.chatModel?.id,
                ),
              ),
            ],
          ),
        ),
        title: InkWell(
          onTap: () {
            _showProfileOptions();
          },
          child: Container(
            margin: EdgeInsets.all(6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.chatModel?.name ?? '',
                  style: TextStyle(
                    fontSize: 18.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "last seen today at 12:05",
                  style: TextStyle(fontSize: 13, color: Colors.white70),
                )
              ],
            ),
          ),
        ),
        actions: [
          IconButton(icon: Icon(Icons.videocam, color: Colors.white), onPressed: () {}),
          IconButton(icon: Icon(Icons.call, color: Colors.white), onPressed: () {}),
          PopupMenuButton<String>(
            padding: EdgeInsets.all(0),
            icon: Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              print(value);
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(child: Text("View Contact"), value: "View Contact"),
                PopupMenuItem(child: Text("Media, links, and docs"), value: "Media, links, and docs"),
                PopupMenuItem(child: Text("WhatsApp Web"), value: "WhatsApp Web"),
                PopupMenuItem(child: Text("Search"), value: "Search"),
                PopupMenuItem(child: Text("Mute Notification"), value: "Mute Notification"),
                PopupMenuItem(child: Text("Wallpaper"), value: "Wallpaper"),
              ];
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/whatsapp_Back.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          bottom: true,
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  controller: _scrollController,
                  itemCount: chatItems.length + 1,
                  itemBuilder: (context, index) {
                    if (index == chatItems.length) {
                      return Container(height: 100);
                    }
                    
                    var item = chatItems[index];
                    
                    if (item['type'] == 'date_header') {
                      return DateHeader(date: item['date']);
                    } else if (item['type'] == 'message') {
                      MessageModel message = item['message'];
                      if (message.type == "source") {
                        return OwnMessageCard(
                          message: message.message,
                          time: message.time,
                          attachmentType: message.attachmentType,
                          attachmentPath: message.attachmentPath,
                          attachmentName: message.attachmentName,
                        );
                      } else {
                        return ReplyCard(
                          message: message.message,
                          time: message.time,
                          attachmentType: message.attachmentType,
                          attachmentPath: message.attachmentPath,
                          attachmentName: message.attachmentName,
                        );
                      }
                    }
                    
                    return Container(); // Fallback
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 6, right: 6, top: 4, bottom: 6),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(0, 255, 255, 255),
                ),
                child: SafeArea(
                  top: false,
                  bottom: true,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 55,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    show = !show;
                                  });
                                },
                                child: Container(
                                  height: 25,
                                  width: 25,
                                  margin: EdgeInsets.only(left: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Icon(Icons.emoji_emotions, color: Colors.grey.shade500, size: 25),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 15),
                                      Expanded(
                                        child: TextField(
                                          key: ValueKey('message_input_field'),
                                          controller: _controller,
                                          focusNode: focusNode,
                                          decoration: InputDecoration(
                                            hintText: "Message",
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.symmetric(vertical: 10),
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              sendButton = value.isNotEmpty;
                                            });
                                          },
                                          textInputAction: TextInputAction.send,
                                          onSubmitted: (value) async {
                                            if (value.isNotEmpty) {
                                              await sendMessage(
                                                  value,
                                                  widget.sourchat?.id ?? 0,
                                                  widget.chatModel?.id ?? 0);
                                              _controller.clear();
                                              setState(() {
                                                sendButton = false;
                                              });
                                              _scrollController.animateTo(
                                                  _scrollController.position.maxScrollExtent,
                                                  duration: Duration(milliseconds: 300),
                                                  curve: Curves.easeOut);
                                            }
                                          },
                                          style: TextStyle(fontSize: 16),
                                          maxLines: null,
                                          keyboardType: TextInputType.multiline,
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.attach_file, color: Colors.grey[600]),
                                        onPressed: () {
                                          showModalBottomSheet(
                                              context: context,
                                              builder: (builder) => bottomSheet());
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.camera_alt, color: Colors.grey[600]),
                                        onPressed: () {},
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Color(0xFF25D366),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: IconButton(
                          onPressed: sendButton
                              ? () async {
                                  await sendMessage(
                                      _controller.text,
                                      widget.sourchat?.id ?? 0,
                                      widget.chatModel?.id ?? 0);
                                  _controller.clear();
                                  setState(() {
                                    sendButton = false;
                                  });
                                  _scrollController.animateTo(
                                      _scrollController.position.maxScrollExtent,
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.easeOut);
                                }
                              : null,
                          icon: Icon(
                            sendButton ? Icons.send : Icons.mic,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (show) emojiSelect(),
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 278,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: const EdgeInsets.all(18.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(Icons.insert_drive_file, Colors.indigo, "Document"),
                  SizedBox(width: 40),
                  iconCreation(Icons.camera_alt, Colors.pink, "Camera"),
                  SizedBox(width: 40),
                  iconCreation(Icons.insert_photo, Colors.purple, "Gallery"),
                ],
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(Icons.headset, Colors.orange, "Audio"),
                  SizedBox(width: 40),
                  iconCreation(Icons.location_pin, Colors.teal, "Location"),
                  SizedBox(width: 40),
                  iconCreation(Icons.person, Colors.blue, "Contact"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget iconCreation(IconData icons, Color color, String text) {
    return InkWell(
      onTap: () {
        _handleAttachmentTap(text.toLowerCase());
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color,
            child: Icon(icons, size: 29, color: Colors.white),
          ),
          SizedBox(height: 5),
          Text(text, style: TextStyle(fontSize: 12))
        ],
      ),
    );
  }

  void _handleAttachmentTap(String attachmentType) {
    Navigator.pop(context); // Close the bottom sheet
    
    // Create a mock attachment message
    String mockPath = '';
    String mockName = '';
    
    switch (attachmentType) {
      case 'document':
        mockPath = 'assets/document.pdf';
        mockName = '项目报告.pdf';
        break;
      case 'camera':
      case 'gallery':
        mockPath = 'assets/profile_pictures/1.jpg';
        mockName = '照片';
        attachmentType = 'image';
        break;
      case 'audio':
        mockPath = 'assets/audio.mp3';
        mockName = '语音消息';
        break;
      case 'location':
        mockPath = 'assets/location.png';
        mockName = '位置信息';
        attachmentType = 'image';
        break;
      case 'contact':
        mockPath = 'assets/contact.png';
        mockName = '联系人';
        attachmentType = 'image';
        break;
      default:
        return;
    }
    
    // Add the attachment message
    _addAttachmentMessage(attachmentType, mockPath, mockName);
  }

  void _addAttachmentMessage(String attachmentType, String attachmentPath, String attachmentName) {
    setState(() {
      messages.add(MessageModel(
        type: "source",
        message: "",
        time: _getCurrentTime(),
        date: DateTime.now().toIso8601String().split('T')[0],
        attachmentType: attachmentType,
        attachmentPath: attachmentPath,
        attachmentName: attachmentName,
      ));
      _groupMessagesByDate();
    });
    
    // Save to database
    _databaseHelper.insertMessage(
      MessageModel(
        type: "source",
        message: "",
        time: _getCurrentTime(),
        date: DateTime.now().toIso8601String().split('T')[0],
        attachmentType: attachmentType,
        attachmentPath: attachmentPath,
        attachmentName: attachmentName,
      ),
      widget.chatModel?.id ?? 0,
    );
    
    // Scroll to bottom
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  Widget emojiSelect() {
    return EmojiPicker(
      onEmojiSelected: (category, emoji) {
        print(emoji);
        setState(() {
          _controller.text = _controller.text + emoji.emoji;
          sendButton = _controller.text.isNotEmpty;
        });
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:chatapp/Model/ChatModel.dart';
import 'package:chatapp/Model/MessageModel.dart';
import 'package:chatapp/CustomUI/DateHeader.dart';

/// Clean, single implementation of the chat screen using in-memory messages.
class IndividualPage extends StatefulWidget {
  final ChatModel? chatModel;
  const IndividualPage({Key? key, this.chatModel}) : super(key: key);

  @override
  State<IndividualPage> createState() => _IndividualPageState();
}

class _IndividualPageState extends State<IndividualPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  List<MessageModel> _messages = [];
  bool _isSendActive = false;

  @override
  void initState() {
    super.initState();
    _messages = List<MessageModel>.from(widget.chatModel?.messages ?? []);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  String _nowTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  List<dynamic> _withDateHeaders(List<MessageModel> src) {
    final List<dynamic> out = [];
    String? current;
    for (final m in src) {
      final d = m.date ?? DateTime.now().toIso8601String().split('T')[0];
      if (current != d) {
        current = d;
        out.add(d);
      }
      out.add(m);
    }
    return out;
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final msg = MessageModel(
      type: 'source',
      message: text,
      time: _nowTime(),
      date: DateTime.now().toIso8601String().split('T')[0],
      status: 'sent',
    );

    setState(() {
      _messages.add(msg);
      if (widget.chatModel != null) widget.chatModel!.messages = List<MessageModel>.from(_messages);
      _isSendActive = false;
    });

    _messageController.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxSource = (screenWidth * 0.65).clamp(0.0, 320.0);
    final maxDest = (screenWidth * 0.78).clamp(0.0, 320.0);

    final rows = _withDateHeaders(_messages);

    return Scaffold(
      appBar: AppBar(title: Text(widget.chatModel?.name ?? 'Chat'), backgroundColor: const Color(0xFF075E54)),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: const AssetImage('assets/whatsapp_Back.png'), fit: BoxFit.cover, opacity: 0.95),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  itemCount: rows.length,
                  itemBuilder: (ctx, i) {
                    final row = rows[i];
                    if (row is String) return DateHeader(date: row);

                    final m = row as MessageModel;
                    final isSource = m.type == 'source';
                    final maxW = isSource ? maxSource : maxDest;

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: Row(
                        mainAxisAlignment: isSource ? MainAxisAlignment.end : MainAxisAlignment.start,
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: maxW),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSource ? const Color(0xFFdcf8c6) : Colors.white,
                                borderRadius: isSource
                                    ? const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12), bottomLeft: Radius.circular(12), bottomRight: Radius.circular(4))
                                    : const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12), bottomLeft: Radius.circular(4), bottomRight: Radius.circular(12)),
                                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 1, offset: const Offset(0, 1))],
                              ),
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 18.0),
                                    child: Text(m.message ?? '', style: const TextStyle(fontSize: 14, height: 1.18)),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                                      Text(m.time ?? '', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                                      if (isSource) const SizedBox(width: 6),
                                      if (isSource)
                                        Icon(
                                          m.status == 'read' ? Icons.done_all : Icons.done,
                                          size: 14,
                                          color: m.status == 'read' ? Colors.blue : Colors.grey[600],
                                        )
                                    ]),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                color: Colors.transparent,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28)),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(children: [
                          const Icon(Icons.emoji_emotions_outlined, color: Colors.grey, size: 22),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              focusNode: _focus_node,
                              decoration: const InputDecoration(border: InputBorder.none, hintText: 'Message', isCollapsed: true, contentPadding: EdgeInsets.symmetric(vertical: 8)),
                              onChanged: (v) => setState(() => _isSendActive = v.trim().isNotEmpty),
                              maxLines: null,
                            ),
                          ),
                        ]),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      height: 48,
                      width: 48,
                      decoration: const BoxDecoration(color: Color(0xFF075E54), shape: BoxShape.circle),
                      child: IconButton(
                        onPressed: _isSendActive ? _sendMessage : null,
                        icon: Icon(_isSendActive ? Icons.send : Icons.mic, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (!_scroll_controller.hasClients) return;
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  String _nowTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  List<dynamic> _withDateHeaders(List<MessageModel> src) {
    final List<dynamic> out = [];
    String? current;
    for (final m in src) {
      final d = m.date ?? DateTime.now().toIso8601String().split('T')[0];
      if (current != d) {
        current = d;
        out.add(d);
      }
      out.add(m);
    }
    return out;
  }

  void _sendMessageInternal() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final msg = MessageModel(
      type: 'source',
      message: text,
      time: _nowTime(),
      date: DateTime.now().toIso8601String().split('T')[0],
      status: 'sent',
    );

    setState(() {
      _messages.add(msg);
      if (widget.chatModel != null) widget.chatModel!.messages = List<MessageModel>.from(_messages);
      _isSendActive = false;
    });

    _messageController.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxSource = (screenWidth * 0.65).clamp(0.0, 320.0);
    final maxDest = (screenWidth * 0.78).clamp(0.0, 320.0);

    final rows = _withDateHeaders(_messages);

    return Scaffold(
      appBar: AppBar(title: Text(widget.chatModel?.name ?? 'Chat'), backgroundColor: const Color(0xFF075E54)),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: const AssetImage('assets/whatsapp_Back.png'), fit: BoxFit.cover, opacity: 0.95),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  itemCount: rows.length,
                  itemBuilder: (ctx, i) {
                    final row = rows[i];
                    if (row is String) return DateHeader(date: row);

                    final m = row as MessageModel;
                    final isSource = m.type == 'source';
                    final maxW = isSource ? maxSource : maxDest;

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: Row(
                        mainAxisAlignment: isSource ? MainAxisAlignment.end : MainAxisAlignment.start,
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: maxW),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSource ? const Color(0xFFdcf8c6) : Colors.white,
                                borderRadius: isSource
                                    ? const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12), bottomLeft: Radius.circular(12), bottomRight: Radius.circular(4))
                                    : const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12), bottomLeft: Radius.circular(4), bottomRight: Radius.circular(12)),
                                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 1, offset: const Offset(0, 1))],
                              ),
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 18.0),
                                    child: Text(m.message ?? '', style: const TextStyle(fontSize: 14, height: 1.18)),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                                      Text(m.time ?? '', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                                      if (isSource) const SizedBox(width: 6),
                                      if (isSource)
                                        Icon(
                                          m.status == 'read' ? Icons.done_all : Icons.done,
                                          size: 14,
                                          color: m.status == 'read' ? Colors.blue : Colors.grey[600],
                                        )
                                    ]),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Input bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                color: Colors.transparent,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28)),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(children: [
                          const Icon(Icons.emoji_emotions_outlined, color: Colors.grey, size: 22),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              focusNode: _focusNode,
                              decoration: const InputDecoration(border: InputBorder.none, hintText: 'Message', isCollapsed: true, contentPadding: EdgeInsets.symmetric(vertical: 8)),
                              onChanged: (v) => setState(() => _isSendActive = v.trim().isNotEmpty),
                              maxLines: null,
                            ),
                          ),
                        ]),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      height: 48,
                      width: 48,
                      decoration: const BoxDecoration(color: Color(0xFF075E54), shape: BoxShape.circle),
                      child: IconButton(
                        onPressed: _isSendActive ? _sendMessageInternal : null,
                        icon: Icon(_isSendActive ? Icons.send : Icons.mic, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:chatapp/Model/ChatModel.dart';
import 'package:chatapp/Model/MessageModel.dart';
import 'package:chatapp/database/DatabaseHelper.dart';
import 'package:chatapp/CustomUI/DateHeader.dart';

class IndividualPage extends StatefulWidget {
  final ChatModel? chatModel;
  const IndividualPage({Key? key, this.chatModel}) : super(key: key);
  @override
  State<IndividualPage> createState() => _IndividualPageState();
}

class _IndividualPageState extends State<IndividualPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scroll = ScrollController();
  final FocusNode _focus = FocusNode();
  List<MessageModel> _items = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      if (widget.chatModel?.id != null) {
        final db = DatabaseHelper();
        final msgs = await db.getMessages(widget.chatModel!.id!);
        setState(() => _items = msgs);
        import 'package:flutter/material.dart';
        import 'package:chatapp/Model/ChatModel.dart';
        import 'package:chatapp/Model/MessageModel.dart';
        import 'package:chatapp/CustomUI/DateHeader.dart';

        /// Clean, in-memory-only chat screen.
        /// - Uses `widget.chatModel?.messages` if present as the message source.
        /// - Does NOT call any database helpers (per-user request).
        class IndividualPage extends StatefulWidget {
          final ChatModel? chatModel;

          const IndividualPage({Key? key, this.chatModel}) : super(key: key);

          @override
          State<IndividualPage> createState() => _IndividualPageState();
        }

        class _IndividualPageState extends State<IndividualPage> {
          final TextEditingController _messageController = TextEditingController();
          final ScrollController _scrollController = ScrollController();
          final FocusNode _focusNode = FocusNode();

          List<MessageModel> _messages = [];
          bool _isSendActive = false;

          @override
          void initState() {
            super.initState();
          _messages = List<MessageModel>.from(widget.chatModel?.messages ?? []);
            _focusNode.addListener(() {});
            WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
          }

          @override
          void dispose() {
          _messageController.dispose();
            _scrollController.dispose();
            _focusNode.dispose();
            super.dispose();
          }

          void _scrollToBottom() {
            if (!_scrollController.hasClients) return;
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
            );
          }

          String _nowTime() {
            final now = DateTime.now();
            return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
          }

          List<dynamic> _withDateHeaders(List<MessageModel> src) {
            final List<dynamic> out = [];
            String? current;
            for (final m in src) {
              final d = m.date ?? DateTime.now().toIso8601String().split('T')[0];
              if (current != d) {
                current = d;
                out.add(d);
              }
              out.add(m);
            }
            return out;
          }

          void _sendMessage() {
            final text = _messageController.text.trim();
            if (text.isEmpty) return;

          final msg = MessageModel(
              type: 'source',
              message: text,
              time: _nowTime(),
              date: DateTime.now().toIso8601String().split('T')[0],
              status: 'sent',
            );

            setState(() {
              _messages.add(msg);
              // keep the chatModel in-sync so other screens reading it will see the change
              if (widget.chatModel != null) widget.chatModel!.messages = List<MessageModel>.from(_messages);
              _isSendActive = false;
            });

            _messageController.clear();
            WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
          }

          @override
          Widget build(BuildContext context) {
          final screenWidth = MediaQuery.of(context).size.width;
            final maxSource = (screenWidth * 0.65).clamp(0.0, 320.0);
            final maxDest = (screenWidth * 0.78).clamp(0.0, 320.0);

            final rows = _withDateHeaders(_messages);

            return Scaffold(
          appBar: AppBar(title: Text(widget.chatModel?.name ?? 'Chat'), backgroundColor: const Color(0xFF075E54)),
              body: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(image: const AssetImage('assets/whatsapp_Back.png'), fit: BoxFit.cover, opacity: 0.95),
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          itemCount: rows.length,
                          itemBuilder: (ctx, i) {
                            final row = rows[i];
                            if (row is String) return DateHeader(date: row);

                            final m = row as MessageModel;
                            final isSource = m.type == 'source';
                            final maxW = isSource ? maxSource : maxDest;

                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              child: Row(
                                mainAxisAlignment: isSource ? MainAxisAlignment.end : MainAxisAlignment.start,
                                children: [
                                  ConstrainedBox(
                                    constraints: BoxConstraints(maxWidth: maxW),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: isSource ? const Color(0xFFdcf8c6) : Colors.white,
                                        borderRadius: isSource
                                            ? const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12), bottomLeft: Radius.circular(12), bottomRight: Radius.circular(4))
                                            : const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12), bottomLeft: Radius.circular(4), bottomRight: Radius.circular(12)),
                                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 1, offset: const Offset(0, 1))],
                                      ),
                                      child: Stack(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 18.0),
                                            child: Text(m.message ?? '', style: const TextStyle(fontSize: 14, height: 1.18)),
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            right: 0,
                                            child: Row(mainAxisSize: MainAxisSize.min, children: [
                                              Text(m.time ?? '', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                                              if (isSource) const SizedBox(width: 6),
                                              if (isSource)
                                                Icon(
                                                  m.status == 'read' ? Icons.done_all : Icons.done,
                                                  size: 14,
                                                  color: m.status == 'read' ? Colors.blue : Colors.grey[600],
                                                )
                                            ]),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                      // Input bar
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28)),
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Row(children: [
                                  const Icon(Icons.emoji_emotions_outlined, color: Colors.grey, size: 22),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextField(
                                      controller: _messageController,
                                      focusNode: _focusNode,
                                      decoration: const InputDecoration(border: InputBorder.none, hintText: 'Message', isCollapsed: true, contentPadding: EdgeInsets.symmetric(vertical: 8)),
                                      onChanged: (v) => setState(() => _isSendActive = v.trim().isNotEmpty),
                                      maxLines: null,
                                    ),
                                  ),
                                ]),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              height: 48,
                              width: 48,
                              decoration: const BoxDecoration(color: Color(0xFF075E54), shape: BoxShape.circle),
                              child: IconButton(
                                onPressed: _isSendActive ? _sendMessage : null,
                                icon: Icon(_isSendActive ? Icons.send : Icons.mic, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }

          void _sendMessage() {
            _sendMessageInternal();
          }

          void _sendMessageInternal() {
            final text = _messageController.text.trim();
            if (text.isEmpty) return;

            final msg = MessageModel(
              type: 'source',
              message: text,
              time: _nowTime(),
              date: DateTime.now().toIso8601String().split('T')[0],
              status: 'sent',
            );

            setState(() {
              _messages.add(msg);
              if (widget.chatModel != null) widget.chatModel!.messages = List<MessageModel>.from(_messages);
              _isSendActive = false;
            });

            _messageController.clear();
            WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
          }
        }

  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  List<dynamic> _getMessageListWithHeaders() {
    List<dynamic> result = [];
    String? currentDate;
    for (MessageModel message in _chatItems) {
      String messageDate = message.date ?? DateTime.now().toIso8601String().split('T')[0];
      if (currentDate != messageDate) {
        currentDate = messageDate;
        result.add(messageDate);
      }
      result.add(message);
    }
    return result;
  }

  Future<void> _sendMessage(String messageContent) async {
    if (messageContent.trim().isEmpty) return;
    final newMessage = MessageModel(
      type: 'source',
      message: messageContent.trim(),
      time: _getCurrentTime(),
      date: DateTime.now().toIso8601String().split('T')[0],
  status: 'sent',
    );

    setState(() => _chatItems.add(newMessage));

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



  Widget _buildMessageInput() {
    // WhatsApp-like input: rounded pill + circular send/mic button
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      color: Colors.transparent,
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28)),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  const Icon(Icons.emoji_emotions_outlined, color: Colors.grey, size: 22),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      focusNode: _messageFocusNode,
                      decoration: const InputDecoration(border: InputBorder.none, hintText: 'Message', isCollapsed: true, contentPadding: EdgeInsets.symmetric(vertical: 8)),
                      onChanged: (v) => setState(() => _isSendButtonActive = v.trim().isNotEmpty),
                      maxLines: null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Attachment / voice icons could go here if desired
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(color: const Color(0xFF075E54), shape: BoxShape.circle),
            child: IconButton(
              onPressed: _isSendButtonActive ? () => _sendMessage(_messageController.text) : null,
              icon: Icon(_isSendButtonActive ? Icons.send : Icons.mic, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatModel?.name ?? 'Chat'),
        backgroundColor: const Color(0xFF075E54),
      ),
      // WhatsApp-like wallpaper background (assets/whatsapp_Back.png is included in repo)
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/whatsapp_Back.png'),
            fit: BoxFit.cover,
            opacity: 0.95,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // message list (expanded)
              _buildMessageList(),
              // input box
              _buildMessageInput(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageList() {
  final screenWidth = MediaQuery.of(context).size.width;
  // Per-side width caps to get WhatsApp-like feel
  final maxBubbleWidthSource = (screenWidth * 0.65).clamp(0.0, 320.0);
  final maxBubbleWidthDest = (screenWidth * 0.78).clamp(0.0, 320.0);

    return Expanded(
      child: _chatItems.isEmpty
          ? const Center(child: Text('No messages yet'))
          : ListView.builder(
              controller: _scrollController,
              itemCount: _getMessageListWithHeaders().length,
              itemBuilder: (context, index) {
                final item = _getMessageListWithHeaders()[index];
                if (item is String) return DateHeader(date: item);

                final message = item as MessageModel;
                final isSource = message.type == 'source';

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: Row(
                    mainAxisAlignment: isSource ? MainAxisAlignment.end : MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Align(
                          alignment: isSource ? Alignment.centerRight : Alignment.centerLeft,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: isSource ? maxBubbleWidthSource : maxBubbleWidthDest),
                child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSource ? const Color(0xFFdcf8c6) : Colors.white,
                                borderRadius: isSource
                                    ? const BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        topRight: Radius.circular(12),
                                        bottomLeft: Radius.circular(12),
                                        bottomRight: Radius.circular(4),
                                      )
                                    : const BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        topRight: Radius.circular(12),
                                        bottomLeft: Radius.circular(4),
                                        bottomRight: Radius.circular(12),
                                      ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: isSource ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                children: [
                                  if (message.attachmentType == 'image' && message.attachmentPath != null)
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 6),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.asset(
                                          message.attachmentPath!,
                                          width: (isSource ? maxBubbleWidthSource : maxBubbleWidthDest) * 0.9,
                                          height: (isSource ? maxBubbleWidthSource : maxBubbleWidthDest) * 0.45,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),

                                  if (message.message != null && message.message!.isNotEmpty)
                                    Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 18.0),
                                          child: Text(
                                            message.message!,
                                            style: const TextStyle(fontSize: 14, height: 1.2),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                message.time ?? '',
                                                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                                              ),
                                              if (isSource) const SizedBox(width: 6),
                                              if (isSource)
                                                Icon(
                                                  message.status == 'read'
                                                      ? Icons.done_all
                                                      : (message.status == 'delivered' ? Icons.done_all : Icons.done),
                                                  size: 12,
                                                  color: message.status == 'read' ? Colors.blue : Colors.grey[600],
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

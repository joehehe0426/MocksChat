import 'package:chatapp/Model/MessageModel.dart';

class ChatModel {
  String? name;
  String? icon;
  bool? isGroup;
  String? time;
  String? currentMessage;
  String? status;
  bool select = false;
  int? id;
  String? profileImage;
  // In-memory message store (no DB)
  List<MessageModel>? messages;

  ChatModel({
    this.name,
    this.icon,
    this.isGroup,
    this.time,
    this.currentMessage,
    this.status,
    this.select = false,
    this.id,
    this.profileImage,
    this.messages,
  }) {
    messages ??= <MessageModel>[];
  }
}

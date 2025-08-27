import 'package:chatapp/Model/ChatModel.dart';
import 'package:chatapp/CustomUI/CachedAvatar.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({Key? key, this.chatModel, this.sourchat}) : super(key: key);
  final ChatModel? chatModel;
  final ChatModel? sourchat;
  
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _buildAvatar(),
      title: _buildTitle(),
      subtitle: _buildSubtitle(),
      trailing: Container(
        width: 80,
        child: _buildTrailing(),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }

  Widget _buildAvatar() {
    return CachedAvatar(
      imagePath: chatModel!.profileImage,
      fallbackIcon: chatModel!.icon,
      radius: 28,
      isGroup: chatModel!.isGroup ?? false,
      name: chatModel!.name,
      contactId: chatModel!.id,
    );
  }

  Widget _buildTitle() {
    return Text(
      chatModel!.name ?? "No Name",
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildSubtitle() {
    return Text(
      chatModel!.currentMessage ?? "No message",
      style: TextStyle(
        fontSize: 14,
        color: Colors.grey[600],
        fontWeight: FontWeight.w300,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildTrailing() {
          return Padding(
        padding: const EdgeInsets.only(right: 16, bottom: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              chatModel!.time ?? "",
              style: const TextStyle(
                fontSize: 10,
                color: Colors.grey,
                fontWeight: FontWeight.w300,
              ),
              textAlign: TextAlign.end,
            ),
            const SizedBox(height: 4),
                      if (chatModel!.isGroup == true)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF075E54),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "Group",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
        ],
      ),
    );
  }
}

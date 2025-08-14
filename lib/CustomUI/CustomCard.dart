import 'package:chatapp/Model/ChatModel.dart';
import 'package:chatapp/Screens/IndividualPage.dart';
import 'package:chatapp/CustomUI/CachedAvatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:io';

class CustomCard extends StatelessWidget {
  const CustomCard({Key? key, this.chatModel, this.sourchat}) : super(key: key);
  final ChatModel? chatModel;
  final ChatModel? sourchat;
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (chatModel != null && sourchat != null) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (builder) => IndividualPage(
                        chatModel: chatModel!,
                        sourchat: sourchat!,
                      )));
        }
      },
      child: Container(
        constraints: BoxConstraints(
          minHeight: 80,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              // Profile circle - pushed more to the left
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: _buildAvatar(),
              ),
              SizedBox(width: 12),
              // Text content - moved more to the left
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTitle(),
                    SizedBox(height: 4),
                    _buildSubtitle(),
                  ],
                ),
              ),
              SizedBox(width: 8),
              // Trailing content with fixed width - increased for more right space
              Container(
                width: 80,
                child: _buildTrailing(),
              ),
            ],
          ),
        ),
      ),
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
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[500],
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.end,
          ),
          SizedBox(height: 4),
          if (chatModel!.isGroup == true)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Color(0xFF075E54),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
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

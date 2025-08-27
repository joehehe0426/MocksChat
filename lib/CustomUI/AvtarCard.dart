import 'package:chatapp/Model/ChatModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AvtarCard extends StatelessWidget {
  const AvtarCard({Key? key, this.chatModel}) : super(key: key);
  final ChatModel? chatModel;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 23,
                backgroundColor: Colors.blueGrey[200],
                child: SvgPicture.asset(
                  chatModel?.isGroup == true
                      ? "assets/groups.svg"
                      : "assets/person.svg",
                  colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  height: 30,
                  width: 30,
                ),
              ),
              const Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 11,
                  child: Icon(
                    Icons.clear,
                    size: 13,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
          Text(
            chatModel?.name ?? '',
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
            ),
          )
        ],
      ),
    );
  }
}

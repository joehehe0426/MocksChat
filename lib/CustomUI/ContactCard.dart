import 'package:chatapp/Model/ChatModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({Key? key, this.contact}) : super(key: key);
  final ChatModel? contact;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 50,
        height: 55,
        child: Stack(
          children: [
            CircleAvatar(
              radius: 23,
              backgroundColor: Colors.blueGrey[200],
              child: SvgPicture.asset(
                contact?.isGroup == true
                    ? "assets/groups.svg"
                    : "assets/person.svg",
                colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                height: 30,
                width: 30,
              ),
            ),
            Positioned(
              bottom: 2,
              right: 2,
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
      ),
      title: Text(
        contact?.name ?? '',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        contact?.status ?? '',
        style: TextStyle(
          fontSize: 13,
        ),
      ),
    );
  }
}

import 'package:chatapp/CustomUI/AvtarCard.dart';
import 'package:chatapp/Model/ChatModel.dart';
import 'package:flutter/material.dart';

class CreateGroup extends StatefulWidget {
  CreateGroup({Key? key}) : super(key: key);

  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  List<ChatModel> contacts = [
    ChatModel(
      name: "張小明",
      isGroup: false,
      currentMessage: "明天開會記得帶文件",
      time: "14:30",
      icon: "person.svg",
      id: 1,
    ),
    ChatModel(
      name: "李美玲",
      isGroup: false,
      currentMessage: "謝謝你的幫助！",
      time: "13:45",
      icon: "person.svg",
      id: 2,
    ),
    ChatModel(
      name: "王建國",
      isGroup: false,
      currentMessage: "項目進度如何？",
      time: "12:20",
      icon: "person.svg",
      id: 3,
    ),
    ChatModel(
      name: "陳雅婷",
      isGroup: false,
      currentMessage: "週末一起吃飯嗎？",
      time: "11:15",
      icon: "person.svg",
      id: 4,
    ),
    ChatModel(
      name: "劉志強",
      isGroup: false,
      currentMessage: "文件已發送",
      time: "10:30",
      icon: "person.svg",
      id: 5,
    ),
    ChatModel(
      name: "黃小華",
      isGroup: false,
      currentMessage: "會議改到下午3點",
      time: "09:45",
      icon: "person.svg",
      id: 6,
    ),
    ChatModel(
      name: "林志明",
      isGroup: false,
      currentMessage: "好的，沒問題",
      time: "昨天",
      icon: "person.svg",
      id: 7,
    ),
    ChatModel(
      name: "吳雅芳",
      isGroup: false,
      currentMessage: "生日快樂！🎉",
      time: "昨天",
      icon: "person.svg",
      id: 8,
    ),
  ];
  List<ChatModel> groupmember = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "New group",
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Add participants",
                style: TextStyle(
                  fontSize: 13,
                ),
              )
            ],
          ),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.search,
                  size: 26,
                ),
                onPressed: () {}),
            PopupMenuButton<String>(
              onSelected: (value) {
                print(value);
              },
              itemBuilder: (BuildContext contesxt) {
                return [
                  PopupMenuItem(
                    child: Text("Invite a friend"),
                    value: "Invite a friend",
                  ),
                  PopupMenuItem(
                    child: Text("Contacts"),
                    value: "Contacts",
                  ),
                  PopupMenuItem(
                    child: Text("Refresh"),
                    value: "Refresh",
                  ),
                  PopupMenuItem(
                    child: Text("Help"),
                    value: "Help",
                  ),
                ];
              },
            )
          ],
        ),
        body: Stack(
          children: [
            ListView.builder(
                itemCount: contacts.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Container(
                      height: groupmember.length > 0 ? 90 : 10,
                    );
                  }
                  return InkWell(
                      onTap: () {
                        if (contacts[index - 1].select == false) {
                          setState(() {
                            contacts[index - 1].select = true;
                            groupmember.add(contacts[index - 1]);
                          });
                        } else {
                          setState(() {
                            contacts[index - 1].select = false;
                            groupmember.remove(contacts[index - 1]);
                          });
                        }
                      },
                      child: ListTile(
                        leading: AvtarCard(
                          chatModel: contacts[index - 1],
                        ),
                        title: Text(
                          contacts[index - 1].name ?? '',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          contacts[index - 1].currentMessage ?? '',
                          style: TextStyle(fontSize: 13),
                        ),
                        trailing: groupmember.contains(contacts[index - 1])
                            ? Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              )
                            : Icon(Icons.check_circle_outline),
                      ));
                }),
            groupmember.length > 0
                ? Column(
                    children: [
                      Container(
                        height: 75,
                        color: Colors.white,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: contacts.length,
                            itemBuilder: (context, index) {
                              if (contacts[index].select == true) {
                                return InkWell(
                                    onTap: () {
                                      setState(() {
                                        groupmember.remove(contacts[index]);
                                        contacts[index].select = false;
                                      });
                                    },
                                    child: AvtarCard(
                                      chatModel: contacts[index],
                                    ));
                              } else {
                                return Container();
                              }
                            }),
                      ),
                      Divider(
                        thickness: 1,
                      )
                    ],
                  )
                : Container(),
          ],
        ));
  }
}

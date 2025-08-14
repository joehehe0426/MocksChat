import 'package:chatapp/CustomUI/ContactCard.dart';
import 'package:chatapp/Model/ChatModel.dart';
import 'package:chatapp/Screens/CreateGroup.dart';
import 'package:flutter/material.dart';

class SelectContact extends StatefulWidget {
  SelectContact({Key? key}) : super(key: key);

  @override
  _SelectContactState createState() => _SelectContactState();
}

class _SelectContactState extends State<SelectContact> {
  List<ChatModel> contacts = [
    ChatModel(
      name: "張小明",
      status: "軟體工程師",
      isGroup: false,
      currentMessage: "明天開會記得帶文件",
      time: "14:30",
      icon: "person.svg",
      id: 1,
      profileImage: "assets/profile_pictures/1.jpg",
    ),
    ChatModel(
      name: "李美玲",
      status: "UI/UX 設計師",
      isGroup: false,
      currentMessage: "謝謝你的幫助！",
      time: "13:45",
      icon: "person.svg",
      id: 2,
      profileImage: "assets/profile_pictures/2.jpeg",
    ),
    ChatModel(
      name: "王建國",
      status: "專案經理",
      isGroup: false,
      currentMessage: "項目進度如何？",
      time: "12:20",
      icon: "person.svg",
      id: 3,
      profileImage: "assets/profile_pictures/3.jpg",
    ),
    ChatModel(
      name: "陳雅婷",
      status: "產品經理",
      isGroup: false,
      currentMessage: "週末一起吃飯嗎？",
      time: "11:15",
      icon: "person.svg",
      id: 4,
      profileImage: "assets/profile_pictures/balram.jpg",
    ),
    ChatModel(
      name: "劉志強",
      status: "前端開發工程師",
      isGroup: false,
      currentMessage: "文件已發送",
      time: "10:30",
      icon: "person.svg",
      id: 5,
      profileImage: "assets/profile_pictures/1.png",
    ),
    ChatModel(
      name: "黃小華",
      status: "後端開發工程師",
      isGroup: false,
      currentMessage: "會議改到下午3點",
      time: "09:45",
      icon: "person.svg",
      id: 6,
      profileImage: "assets/profile_pictures/2.jpeg",
    ),
    ChatModel(
      name: "林志明",
      status: "測試工程師",
      isGroup: false,
      currentMessage: "好的，沒問題",
      time: "昨天",
      icon: "person.svg",
      id: 7,
      profileImage: "assets/profile_pictures/3.jpg",
    ),
    ChatModel(
      name: "吳雅芳",
      status: "人力資源專員",
      isGroup: false,
      currentMessage: "生日快樂！🎉",
      time: "昨天",
      icon: "person.svg",
      id: 8,
      profileImage: "assets/profile_pictures/balram.jpg",
    ),
    ChatModel(
      name: "趙大偉",
      status: "系統架構師",
      isGroup: false,
      currentMessage: "代碼審查完成",
      time: "昨天",
      icon: "person.svg",
      id: 9,
      profileImage: "assets/profile_pictures/1.jpg",
    ),
    ChatModel(
      name: "孫麗麗",
      status: "市場行銷專員",
      isGroup: false,
      currentMessage: "謝謝你的禮物",
      time: "昨天",
      icon: "person.svg",
      id: 10,
      profileImage: "assets/profile_pictures/2.jpeg",
    ),
    ChatModel(
      name: "鄭志豪",
      status: "業務經理",
      isGroup: false,
      currentMessage: "明天見面詳談",
      time: "昨天",
      icon: "person.svg",
      id: 11,
    ),
    ChatModel(
      name: "周小美",
      status: "會計師",
      isGroup: false,
      currentMessage: "報表已更新",
      time: "昨天",
      icon: "person.svg",
      id: 12,
    ),
    ChatModel(
      name: "楊建華",
      status: "運維工程師",
      isGroup: false,
      currentMessage: "伺服器維護完成",
      time: "昨天",
      icon: "person.svg",
      id: 13,
    ),
    ChatModel(
      name: "郭雅琳",
      status: "客戶服務專員",
      isGroup: false,
      currentMessage: "客戶反饋已處理",
      time: "昨天",
      icon: "person.svg",
      id: 14,
    ),
    ChatModel(
      name: "蔡志明",
      status: "法務專員",
      isGroup: false,
      currentMessage: "合約已審核",
      time: "昨天",
      icon: "person.svg",
      id: 15,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select Contact",
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "256 contacts",
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
        body: ListView.builder(
            itemCount: contacts.length + 2,
            itemBuilder: (context, index) {
              if (index == 0) {
                return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => CreateGroup()));
                    },
                    child: ListTile(
                      leading: Container(
                        height: 55,
                        width: 55,
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 23,
                              backgroundColor: Colors.blueGrey[200],
                              child: Icon(
                                Icons.group,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                      ),
                      title: Text(
                        "New group",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ));
              } else if (index == 1) {
                return ListTile(
                  leading: Container(
                    height: 55,
                    width: 55,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 23,
                          backgroundColor: Colors.blueGrey[200],
                          child: Icon(
                            Icons.person_add,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                  title: Text(
                    "New contact",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    "Add contact on phonebook",
                    style: TextStyle(fontSize: 13),
                  ),
                );
              } else {
                return ContactCard(
                  contact: contacts[index - 2],
                );
              }
            }));
  }
}

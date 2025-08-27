import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';

/// Generates mock contacts (1..15) and a 40-day chat history JSON file.
/// Output: assets/mock/mock_history.json
Future<void> main() async {
  final now = DateTime.now();
  const currentUserId = "user_001"; // Current user's ID
  final rng = _RandomGenerator(); // For better randomization

  // Enhanced contacts with avatars and statuses
  final contacts = <Map<String, dynamic>>[
    {'id': 1, 'name': '老豆', 'phoneNumber': '11111111', 'avatar': 'assets/avatars/father.png', 'status': '剛剛在看新聞'},
    {'id': 2, 'name': '媽', 'phoneNumber': '22222222', 'avatar': 'assets/avatars/mother.png', 'status': '準備做晚飯'},
    {'id': 3, 'name': '哥', 'phoneNumber': '33333333', 'avatar': null, 'status': '在加班中'},
    {'id': 4, 'name': '爺爺', 'phoneNumber': '44444444', 'avatar': 'assets/avatars/grandpa.png', 'status': '去公園散步了'},
    {'id': 5, 'name': '呀婆', 'phoneNumber': '55555555', 'avatar': 'assets/avatars/grandma.png', 'status': '剛睡午覺醒來'},
    {'id': 6, 'name': '呀嫲', 'phoneNumber': '66666666', 'avatar': null, 'status': '準備去買菜'},
    {'id': 7, 'name': '梅姨', 'phoneNumber': '77777777', 'avatar': 'assets/avatars/aunt1.png', 'status': '最近很忙'},
    {'id': 8, 'name': '舅父', 'phoneNumber': '88888888', 'avatar': null, 'status': '剛看完一場電影'},
    {'id': 9, 'name': '小明', 'phoneNumber': '99999999', 'avatar': 'assets/avatars/friend1.png', 'status': '在圖書館學習'},
    {'id': 10, 'name': '小華', 'phoneNumber': '10101010', 'avatar': 'assets/avatars/friend2.png', 'status': '等下要去運動'},
    {'id': 11, 'name': '阿強', 'phoneNumber': '11111110', 'avatar': null, 'status': '今天天氣不錯'},
    {'id': 12, 'name': '小美', 'phoneNumber': '12121212', 'avatar': 'assets/avatars/friend3.png', 'status': '剛剛吃完飯'},
    {'id': 13, 'name': '阿傑', 'phoneNumber': '13131313', 'avatar': null, 'status': '準備回家'},
    {'id': 14, 'name': '小麗', 'phoneNumber': '14141414', 'avatar': 'assets/avatars/friend4.png', 'status': '在聽音樂'},
    {'id': 15, 'name': '阿偉', 'phoneNumber': '15151515', 'avatar': null, 'status': '明天見'},
  ];

  // More diverse message pools
  final List<String> familyMessages = [
    '早安！今天要記得帶傘', '媽煮了你最愛的菜', '下班了嗎？', '剛剛去公園散步遇到李阿姨',
    '記得吃藥', '這個週末回家嗎？', '天氣變冷了，多穿點衣服', '爸說他買了新茶葉',
    '妹妹的考試成績出來了，還不錯', '爺爺身體好多了', '剛才看了一部好電影',
    '晚點打電話給你', '需要我幫你帶什麼東西嗎？', '明天早上一起去買菜？',
    '電視壞了，你知道怎麼修嗎？', '表哥下個月結婚', '記得繳水電費',
    '我學了新菜式，下次做給你吃', '剛剛去醫院檢查，一切正常', '晚安，早點休息'
  ];

  final List<String> friendMessages = [
    '嗨！週末要不要去看電影？', '新出的那個遊戲超好玩', '昨天的聚會你怎麼沒來？',
    '今天天氣真好，適合爬山', '我買了新耳機，音效超棒', '上次借你的書記得還我哦',
    '推薦你一家超好吃的餐廳', '這部劇你看了嗎？超級好看', '明天有空打籃球嗎？',
    '我下個月要去旅行', '昨晚睡得不好，今天好困', '剛剛看到一件超適合你的衣服',
    '老師佈置的作業好多啊', '這個音樂節你會去嗎？', '我電腦壞了，能幫我看看嗎？',
    '周末一起去圖書館吧', '最近有什麼好歌推薦？', '我學會了做蛋糕，下次給你嘗嘗',
    '這家咖啡店的拿鐵超讚', '昨晚的球賽看了嗎？太精彩了'
  ];

  // Add some attachment messages
  final List<String> attachmentMessages = [
    '這張照片拍得不錯', '看看這個視頻', '這個文件你可能需要',
    '分享一首歌給你', '這是上次活動的照片'
  ];

  final attachmentTypes = ['image', 'video', 'document', 'audio'];
  final allMessages = <Map<String, dynamic>>[];

  for (int contactId = 1; contactId <= 15; contactId++) {
    // Get contact-specific message pool
    List<String> messagePool;
    if (contactId <= 8) {
      messagePool = List<String>.from(familyMessages);
      // Add contact-specific messages
      switch (contactId) {
        case 1: messagePool.addAll(['記得買米回來', '晚上一起看球賽', '我的工具箱借你用']); break;
        case 2: messagePool.addAll(['你的衣服我洗好了', '要不要吃點水果', '鹽快沒了，記得買']); break;
        case 3: messagePool.addAll(['新出的遊戲超難', '周末去打球嗎', '電腦借我用一下']); break;
        default: break;
      }
    } else {
      messagePool = List<String>.from(friendMessages);
      // Add contact-specific messages
      switch (contactId) {
        case 9: messagePool.addAll(['數學作業好難', '老師點名了嗎', '明天一起上課']); break;
        case 10: messagePool.addAll(['新電影上映了', '演唱會門票買到了', '這首歌超級好聽']); break;
        default: break;
      }
    }

    // Generate messages for each day
    for (int day = 40; day >= 0; day--) {
      final messageDate = now.subtract(Duration(days: day));
      // Fewer messages for older days
      final messageCount = day < 7 ? 3 + rng.nextInt(5) : // Last week - more messages
                          day < 14 ? 2 + rng.nextInt(3) : // Last 2 weeks
                          1 + rng.nextInt(2); // Older than 2 weeks

      for (int idx = 0; idx < messageCount; idx++) {
        // Generate realistic message time
        final hour = rng.getRandomHour(day);
        final messageTime = DateTime(
          messageDate.year,
          messageDate.month,
          messageDate.day,
          hour,
          rng.nextInt(60),
        );

        // Randomly add attachments (10% chance)
        final hasAttachment = rng.nextDouble() < 0.1;
        String? text;
        String? attachmentType;
        String? attachmentPath;
        String? attachmentName;

        if (hasAttachment) {
          final attIdx = rng.nextInt(attachmentMessages.length);
          text = attachmentMessages[attIdx];
          attachmentType = attachmentTypes[rng.nextInt(attachmentTypes.length)];
          attachmentPath = 'assets/mocks/$attachmentType/${contactId}_${day}_$idx.$attachmentType';
          attachmentName = '${text.replaceAll(RegExp(r'[^\w]'), '')}.$attachmentType';
        } else {
          // Regular text message
          final poolIndex = rng.nextInt(messagePool.length);
          text = messagePool[poolIndex];
        }

        // Determine sender (current user or contact)
        final isCurrentUser = rng.nextBool();
        final senderId = isCurrentUser ? currentUserId : "user_${contactId.toString().padLeft(3, '0')}";
        final receiverId = isCurrentUser ? "user_${contactId.toString().padLeft(3, '0')}" : currentUserId;

        // Add message
        allMessages.add({
          'chatId': contactId,
          'type': 'text', // Updated to match database structure
          'message': text,
          'time': DateFormat('HH:mm').format(messageTime),
          'date': DateFormat('yyyy-MM-dd').format(messageTime),
          'timestamp': messageTime.millisecondsSinceEpoch,
          'senderId': senderId,
          'receiverId': receiverId,
          'isRead': !isCurrentUser && day < 3 ? 1 : 0, // Mark recent messages as read
          'attachmentType': attachmentType,
          'attachmentPath': attachmentPath,
          'attachmentName': attachmentName,
        });
      }
    }
  }

  // Prepare output with chat sessions
  final chatSessions = contacts.map((contact) {
    // Find last message for this contact
    final contactMessages = allMessages
        .where((m) => m['chatId'] == contact['id'])
        .toList()
      ..sort((a, b) => b['timestamp'].compareTo(a['timestamp']));
    
    final lastMessage = contactMessages.isNotEmpty ? contactMessages.first : null;

    return {
      'chatId': contact['id'],
      'name': contact['name'],
      'lastMessage': lastMessage?['message'] ?? '',
      'lastMessageTime': lastMessage?['time'] ?? '',
      'unreadCount': lastMessage != null && lastMessage['isRead'] == 0 ? 1 : 0,
      'profileImage': contact['avatar'],
      'isGroup': false,
    };
  }).toList();

  final output = {
    'contacts': contacts,
    'chat_sessions': chatSessions,
    'messages': allMessages,
  };

  // Write to file
  final outDir = Directory('assets/mock');
  if (!outDir.existsSync()) {
    outDir.createSync(recursive: true);
  }
  final outFile = File('assets/mock/mock_history.json');
  outFile.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(output));
  stdout.writeln('✅ Wrote ${allMessages.length} messages for ${contacts.length} contacts to ${outFile.path}');
  stdout.writeln('   Included ${allMessages.where((m) => m['attachmentType'] != null).length} attachments');
}

/// Helper class for better randomization
class _RandomGenerator {
  final _random = DateTime.now().microsecondsSinceEpoch;

  int nextInt(int max) {
    return (_random % max).abs();
  }

  double nextDouble() {
    return (_random % 1000) / 1000.0;
  }

  bool nextBool() {
    return (_random % 2) == 0;
  }

  /// Generate more realistic hours (more messages in evening/weekends)
  int getRandomHour(int day) {
    // Weekend (Saturday: 6, Sunday: 0)
    final isWeekend = DateTime.now().subtract(Duration(days: day)).weekday % 7 == 0 || 
                      DateTime.now().subtract(Duration(days: day)).weekday == 6;
    
    if (isWeekend) {
      // More messages in morning and evening on weekends
      final r = nextInt(100);
      if (r < 20) return 9 + nextInt(3); // 9-11 AM
      if (r < 40) return 12 + nextInt(3); // 12-2 PM
      if (r < 70) return 15 + nextInt(4); // 3-6 PM
      return 19 + nextInt(5); // 7-11 PM
    } else {
      // More messages in evening on weekdays
      final r = nextInt(100);
      if (r < 10) return 7 + nextInt(2); // 7-8 AM
      if (r < 20) return 12 + nextInt(2); // 12-1 PM
      if (r < 30) return 13 + nextInt(2); // 1-2 PM
      return 18 + nextInt(6); // 6-11 PM
    }
  }
}

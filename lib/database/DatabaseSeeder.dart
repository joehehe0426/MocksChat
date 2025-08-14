import 'package:chatapp/Model/MessageModel.dart';
import 'package:chatapp/database/DatabaseHelper.dart';
import 'package:chatapp/config/MockDataConfig.dart';

class DatabaseSeeder {
  static final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Seed the database with initial data
  static Future<void> seedDatabase() async {
    try {
      if (!MockDataConfig.enableMockData) {
        if (MockDataConfig.showDebugLogs) {
          print('🚫 Mock data is disabled in MockDataConfig');
        }
        return;
      }

      // Check if database already has data
      List<Map<String, dynamic>> existingContacts = await _databaseHelper.getAllContacts();
      if (existingContacts.isNotEmpty && !MockDataConfig.clearExistingData) {
        if (MockDataConfig.showDebugLogs) {
          print('📊 Database already has data, skipping seeding');
        }
        return;
      }

      if (MockDataConfig.showDebugLogs) {
        print('🌱 Seeding database with mock data from MockDataConfig...');
      }
      
      // Clear existing data if configured
      if (MockDataConfig.clearExistingData) {
        await _databaseHelper.clearAllData();
        if (MockDataConfig.showDebugLogs) {
          print('🗑️ Cleared existing data');
        }
      }
      
      // Add contacts from config
      await _addContactsFromConfig();
      
      // Add messages from config
      await _addMessagesFromConfig();
      
      // Add chat sessions from config
      await _addChatSessionsFromConfig();
      
      if (MockDataConfig.showDebugLogs) {
        print('✅ Database seeded successfully!');
      }
    } catch (e) {
      print('❌ Error seeding database: $e');
    }
  }

  static Future<void> _addContactsFromConfig() async {
    try {
      print('🌱 Starting to add contacts from config...');
      for (var contact in MockDataConfig.contacts) {
        int contactId = await _databaseHelper.insertContact(
          contact['name'],
          contact['phoneNumber'],
          avatar: contact['avatar'],
        );
        print('📞 Added contact: ${contact['name']} with ID: $contactId');
      }
      
      if (MockDataConfig.showDebugLogs) {
        print('📞 Added ${MockDataConfig.contacts.length} contacts from config');
      }
    } catch (e) {
      print('Error adding contacts from config: $e');
    }
  }

  static Future<void> _addMessagesFromConfig() async {
    try {
      // Generate 1+ month of realistic chat history
      await _generateExtendedChatHistory();
      
      // Also add the original messages from config (mapped to correct contact IDs)
      for (var msg in MockDataConfig.messages) {
        int originalChatId = msg['chatId'];
        int actualChatId = originalChatId + 15; // Map 1-8 to 16-23
        
        await _databaseHelper.insertMessage(
          MessageModel(
            message: msg['message'],
            type: msg['type'],
            time: msg['time'],
            attachmentType: msg['attachmentType'],
            attachmentPath: msg['attachmentPath'],
            attachmentName: msg['attachmentName'],
          ),
          actualChatId,
        );
      }
      
      if (MockDataConfig.showDebugLogs) {
        print('💬 Added extended chat history + ${MockDataConfig.messages.length} messages from config');
      }
    } catch (e) {
      print('Error adding messages from config: $e');
    }
  }

  // Generate realistic 1+ month chat history
  static Future<void> _generateExtendedChatHistory() async {
    final now = DateTime.now();
    final List<String> familyMessages = [
      '早安！', '早安，今天天氣不錯', '是啊，適合出門', '記得吃早餐', '好的，你也是',
      '今天工作怎麼樣？', '還好，有點忙', '注意休息', '知道，謝謝關心',
      '吃飯了嗎？', '剛吃完，你呢？', '我也剛吃完', '今天煮了什麼？', '簡單的菜',
      '這個週末回家嗎？', '應該會', '好的，到時候見', '路上小心', '知道，謝謝',
      '身體怎麼樣？', '還好，你呢？', '我也還好', '多保重', '你也是',
      '今天去哪裡了？', '去超市買東西', '買了什麼？', '日常用品', '好的',
      '天氣變冷了', '是啊，要多穿衣服', '你也是', '知道，謝謝關心',
      '早點休息', '好的，你也是', '晚安', '晚安，好夢',
    ];

    final List<String> friendMessages = [
      '嗨！最近怎麼樣？', '還好，你呢？', '我也不錯', '有空出來聚聚嗎？', '好啊，什麼時候？',
      '今天去哪裡玩了？', '去看了電影', '什麼電影？', '動作片，還不錯', '下次一起去看',
      '吃飯了嗎？', '還沒，你呢？', '我也還沒', '一起吃飯嗎？', '好啊，哪裡？',
      '今天工作很累', '辛苦了', '謝謝', '早點休息', '好的',
      '週末有什麼計劃？', '還沒想好', '要不要一起出去玩？', '好啊，去哪裡？', '海邊怎麼樣？',
      '今天心情不好', '怎麼了？', '工作壓力大', '別想太多', '謝謝關心',
      '今天遇到有趣的事', '什麼事？', '遇到老朋友', '那很好啊', '是啊',
      '最近在忙什麼？', '工作，你呢？', '學習新技能', '什麼技能？', '編程',
      '今天天氣真好', '是啊，適合出門', '要不要去散步？', '好啊', '現在出發？',
    ];

    // Generate messages for each contact over the past 40 days
    for (int contactId = 16; contactId <= 30; contactId++) {
      // Create contact-specific message pool for more variety
      List<String> messages;
      if (contactId <= 23) {
        // Family members get family messages with some variation
        messages = List.from(familyMessages);
        // Add some contact-specific messages
        if (contactId == 16) messages.addAll(['老豆，記得買菜', '好的，買什麼？', '青菜和肉', '知道了']);
        if (contactId == 17) messages.addAll(['媽，今天煮什麼？', '紅燒肉', '太好了', '記得回來吃飯']);
        if (contactId == 18) messages.addAll(['哥，一起打球嗎？', '好啊，什麼時候？', '下午三點', 'OK']);
        if (contactId == 19) messages.addAll(['爺爺，身體還好嗎？', '還好，你呢？', '我也還好', '多保重']);
        if (contactId == 20) messages.addAll(['呀婆，今天去哪裡？', '去公園散步', '小心點', '知道']);
        if (contactId == 21) messages.addAll(['呀嫲，吃飯了嗎？', '剛吃完', '好吃嗎？', '還不錯']);
        if (contactId == 22) messages.addAll(['梅姨，最近忙嗎？', '還好，你呢？', '我也還好', '注意休息']);
        if (contactId == 23) messages.addAll(['舅父，工作怎麼樣？', '還行', '辛苦了', '謝謝']);
      } else {
        // Friends get friend messages with some variation
        messages = List.from(friendMessages);
        // Add some contact-specific messages
        if (contactId == 24) messages.addAll(['小明，最近學習怎麼樣？', '還好', '加油', '謝謝']);
        if (contactId == 25) messages.addAll(['小華，週末有空嗎？', '有啊', '一起看電影？', '好啊']);
        if (contactId == 26) messages.addAll(['阿強，今天心情怎麼樣？', '不錯', '那就好', '謝謝關心']);
        if (contactId == 27) messages.addAll(['小美，吃飯了嗎？', '還沒', '一起吃飯？', '好啊']);
        if (contactId == 28) messages.addAll(['阿傑，最近在忙什麼？', '工作', '辛苦了', '謝謝']);
        if (contactId == 29) messages.addAll(['小麗，今天天氣真好', '是啊', '要不要出門？', '好啊']);
        if (contactId == 30) messages.addAll(['阿偉，最近怎麼樣？', '還好', '那就好', '保重']);
      }
      
      // Generate 2-5 messages per day for the past 40 days
      for (int day = 40; day >= 0; day--) {
        final messageDate = now.subtract(Duration(days: day));
        final messageCount = 2 + (day % 4); // 2-5 messages per day
        
        for (int msg = 0; msg < messageCount; msg++) {
          final messageTime = DateTime(
            messageDate.year,
            messageDate.month,
            messageDate.day,
            8 + (msg * 4) % 12, // Spread messages throughout the day
            (msg * 7) % 60,
          );
          
          // Make message selection more varied and contact-specific
          final messageIndex = (contactId * 7 + day * 3 + msg) % messages.length;
          final message = messages[messageIndex];
          final isSource = (contactId + day + msg) % 2 == 0; // More varied source/destination
          
          // Create a custom MessageModel with proper timestamp
          final customMessage = MessageModel(
            message: message,
            type: isSource ? 'source' : 'destination',
            time: '${messageTime.hour.toString().padLeft(2, '0')}:${messageTime.minute.toString().padLeft(2, '0')}',
            date: messageTime.toIso8601String().split('T')[0],
            attachmentType: null,
            attachmentPath: null,
            attachmentName: null,
          );
          
          // Insert with custom timestamp
          await _insertMessageWithTimestamp(customMessage, contactId, messageTime);
        }
      }
    }
  }

  // Helper method to insert message with custom timestamp
  static Future<void> _insertMessageWithTimestamp(MessageModel message, int chatId, DateTime timestamp) async {
    try {
      final db = await _databaseHelper.database;
      await db.insert('messages', {
        'chatId': chatId,
        'message': message.message ?? '',
        'type': message.type ?? 'source',
        'time': message.time ?? '',
        'date': message.date ?? timestamp.toIso8601String().split('T')[0],
        'timestamp': timestamp.millisecondsSinceEpoch, // Use custom timestamp
        'attachmentType': message.attachmentType,
        'attachmentPath': message.attachmentPath,
        'attachmentName': message.attachmentName,
      });
    } catch (e) {
      print('Error inserting message with timestamp: $e');
    }
  }

  static Future<void> _addChatSessionsFromConfig() async {
    try {
      print('💬 Starting to add chat sessions from config...');
      for (var contact in MockDataConfig.contacts) {
        int chatId = MockDataConfig.contacts.indexOf(contact) + 16; // Start from 16 to match contact IDs
        String profileImage = contact['profileImage'] ?? '';
        
        print('💬 Processing contact: ${contact['name']} with chatId: $chatId, profileImage: $profileImage');
        
        // Get the last message for this chat
        final lastMessage = await _databaseHelper.getLastMessage(chatId);
        String lastMessageText = '';
        String lastMessageTime = '';
        
        if (lastMessage != null) {
          lastMessageText = lastMessage.message ?? '';
          lastMessageTime = lastMessage.time ?? '';
        }
        
        await _databaseHelper.updateChatSession(chatId, lastMessageText, lastMessageTime);
        
        // Update profile image if available
        if (profileImage.isNotEmpty) {
          await _databaseHelper.updateProfileImage(chatId, profileImage);
          print('✅ Updated profile image for chatId $chatId: $profileImage');
        } else {
          print('❌ No profile image for chatId $chatId');
        }
      }
      
      if (MockDataConfig.showDebugLogs) {
        print('💬 Added chat sessions from config with last messages');
      }
    } catch (e) {
      print('Error adding chat sessions from config: $e');
    }
  }

  // Check if database is empty and needs seeding
  static Future<bool> needsSeeding() async {
    try {
      final messages = await _databaseHelper.getAllMessages();
      final contacts = await _databaseHelper.getAllContacts();
      final sessions = await _databaseHelper.getAllChatSessions();
      
      return messages.isEmpty && contacts.isEmpty && sessions.isEmpty;
    } catch (e) {
      print('Error checking if database needs seeding: $e');
      return true; // Seed if there's an error
    }
  }
}

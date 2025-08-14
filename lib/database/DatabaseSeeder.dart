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
      for (var contact in MockDataConfig.contacts) {
        await _databaseHelper.insertContact(
          contact['name'],
          contact['phoneNumber'],
          avatar: contact['avatar'],
        );
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
      for (var msg in MockDataConfig.messages) {
        await _databaseHelper.insertMessage(
          MessageModel(
            message: msg['message'],
            type: msg['type'],
            time: msg['time'],
            attachmentType: msg['attachmentType'],
            attachmentPath: msg['attachmentPath'],
            attachmentName: msg['attachmentName'],
          ),
          msg['chatId'],
        );
      }
      
      if (MockDataConfig.showDebugLogs) {
        print('💬 Added ${MockDataConfig.messages.length} messages from config');
      }
    } catch (e) {
      print('Error adding messages from config: $e');
    }
  }

  static Future<void> _addChatSessionsFromConfig() async {
    try {
      for (var session in MockDataConfig.chatSessions) {
        await _databaseHelper.updateChatSession(
          session['chatId'],
          session['lastMessage'],
          session['lastMessageTime'],
        );
      }
      
      if (MockDataConfig.showDebugLogs) {
        print('💬 Added ${MockDataConfig.chatSessions.length} chat sessions from config');
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

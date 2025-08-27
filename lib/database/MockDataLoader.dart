import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:chatapp/Model/MessageModel.dart';
import 'package:chatapp/Model/ChatModel.dart';

class MockDataLoader {
  static Map<String, dynamic>? _mockData;

  /// Load mock data from JSON file
  static Future<Map<String, dynamic>?> loadMockData() async {
    try {
      if (_mockData != null) return _mockData;

      print('📂 Loading mock data from JSON file...');
      final jsonString = await rootBundle.loadString('assets/mock/mock_history.json');
      _mockData = json.decode(jsonString) as Map<String, dynamic>;
      
      print('✅ Loaded mock data: ${_mockData!['contacts'].length} contacts, ${_mockData!['messages'].length} messages');
      return _mockData;
    } catch (e) {
      print('❌ Error loading mock data: $e');
      return null;
    }
  }


  /// Get chat models from JSON
  static Future<List<ChatModel>> getMockChats() async {
    final data = await loadMockData();
    if (data == null) return [];
    final contacts = data['contacts'] as List<dynamic>;
    return contacts.map((contact) => ChatModel(
      id: contact['id'],
      name: contact['name'],
      icon: contact['avatar'] ?? 'person.svg',
      isGroup: (contact['avatar'] ?? 'person.svg') == 'group.svg',
      status: 'Online',
      profileImage: contact['profileImage'],
      currentMessage: '',
      time: '',
    )).toList();
  }


  /// Get messages from JSON for a given chatId
  static Future<List<MessageModel>> getMockMessages(int chatId) async {
    final data = await loadMockData();
    if (data == null) return [];
    final messages = data['messages'] as List<dynamic>;
    return messages
        .where((msg) => msg['chatId'] == chatId)
        .map((msg) => MessageModel(
              type: msg['type'] ?? 'text',
              message: msg['message'],
              time: msg['time'],
              date: msg['date'],
              attachmentType: msg['attachmentType'],
              attachmentPath: msg['attachmentPath'],
              attachmentName: msg['attachmentName'],
            ))
        .toList();
  }

  // All DB-related methods removed. Only JSON in-memory access now.
}

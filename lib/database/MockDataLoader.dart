import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:chatapp/Model/MessageModel.dart';
import 'package:chatapp/Model/ChatModel.dart';
import 'package:chatapp/config/install_logger.dart';

class MockDataLoader {
  static Map<String, dynamic>? _mockData;

  /// Load mock data from JSON file
  static Future<Map<String, dynamic>?> loadMockData() async {
    try {
      if (_mockData != null) return _mockData;

      await InstallLogger.log('Loading mock data from JSON file...');
      final jsonString = await rootBundle.loadString('assets/mock/mock_history.json');
      _mockData = json.decode(jsonString) as Map<String, dynamic>;
      await InstallLogger.log('Loaded mock data: \\${_mockData!['contacts'].length} contacts, \\${_mockData!['messages'].length} messages');
      return _mockData;
    } catch (e) {
      await InstallLogger.log('Error loading mock data: $e');
      return null;
    }
  }

  /// Helper to parse a message's datetime (best-effort)
  static DateTime _parseMessageDate(Map<String, dynamic> msg) {
    try {
      final datePart = (msg['date'] ?? '').toString().trim();
      final timePart = (msg['time'] ?? '').toString().trim();

      if (datePart.isNotEmpty) {
        // Combine date + time (e.g. "2024-01-16 12:05")
        final combined = timePart.isNotEmpty ? '$datePart $timePart' : datePart;
        final parsed = DateTime.tryParse(combined);
        if (parsed != null) return parsed;
      }

      if (timePart.isNotEmpty) {
        // Fallback: use today's date plus the time string
        final now = DateTime.now();
        final parts = timePart.split(':');
        final h = int.tryParse(parts[0]) ?? 0;
        final m = parts.length > 1 ? (int.tryParse(parts[1]) ?? 0) : 0;
        return DateTime(now.year, now.month, now.day, h, m);
      }
    } catch (_) {}

    // Very old epoch as fallback so it sorts to the end
    return DateTime.fromMillisecondsSinceEpoch(0);
  }

  /// Get chat models from JSON and populate last message/time
  static Future<List<ChatModel>> getMockChats() async {
    final data = await loadMockData();
    if (data == null) return [];

    final contacts = data['contacts'] as List<dynamic>? ?? [];
    final messages = data['messages'] as List<dynamic>? ?? [];

    return contacts.map((contact) {
      final chatId = contact['id'];
      // Find messages for this chat
      final chatMessages = messages.where((m) => m['chatId'] == chatId).cast<Map<String, dynamic>>().toList();

      String lastMessage = '';
      String time = '';

      if (chatMessages.isNotEmpty) {
        // Sort descending by parsed datetime and pick the newest
        chatMessages.sort((a, b) => _parseMessageDate(b).compareTo(_parseMessageDate(a)));
        final latest = chatMessages.first;
        lastMessage = (latest['message'] ?? '').toString();
        time = (latest['time'] ?? '').toString();
      }

      return ChatModel(
        id: contact['id'],
        name: contact['name'],
        icon: contact['avatar'] ?? 'person.svg',
        isGroup: (contact['avatar'] ?? 'person.svg') == 'group.svg',
        status: 'Online',
        profileImage: contact['profileImage'],
        currentMessage: lastMessage,
        time: time,
      );
    }).toList();
  }

  /// Get messages from JSON for a given chatId
  static Future<List<MessageModel>> getMockMessages(int chatId) async {
    final data = await loadMockData();
    if (data == null) {
      await InstallLogger.log('No mock data available when loading messages for chatId=$chatId');
      return [];
    }
    final messages = data['messages'] as List<dynamic>;
    final filtered = messages.where((msg) => msg['chatId'] == chatId).toList();
    await InstallLogger.log('Loaded ${filtered.length} mock messages for chatId=$chatId');
    return filtered
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
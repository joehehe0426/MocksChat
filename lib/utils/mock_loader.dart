import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../Model/MessageModel.dart';

/// Lightweight loader for the mock chat history bundled in
/// `assets/mock/mock_history.json`.
///
/// Important: This is read-only and in-memory only. It does NOT touch
/// any database or persistence layer. Callers receive a Map keyed by
/// `chatId` with a List<MessageModel> (preserves the order in the file).
class MockLoader {
  /// Loads the mock history and returns messages grouped by `chatId`.
  ///
  /// Returns an empty map if the file is missing or malformed.
  static Future<Map<int, List<MessageModel>>> loadMockMessages() async {
    try {
      final jsonStr = await rootBundle.loadString('assets/mock/mock_history.json');
      final data = json.decode(jsonStr) as Map<String, dynamic>;

      final rawMessages = data['messages'] as List<dynamic>? ?? [];
      final Map<int, List<MessageModel>> byChat = {};

      for (final dynamic item in rawMessages) {
        if (item is! Map<String, dynamic>) continue;

        final chatId = (item['chatId'] is num) ? (item['chatId'] as num).toInt() : 0;

        final msg = MessageModel(
          message: item['message']?.toString(),
          type: item['type']?.toString(),
          time: item['time']?.toString(),
          date: item['date']?.toString(),
          attachmentType: item['attachmentType']?.toString(),
          attachmentPath: item['attachmentPath']?.toString(),
          attachmentName: item['attachmentName']?.toString(),
          status: item['status']?.toString() ?? (item['type'] == 'source' ? 'sent' : null),
        );

        byChat.putIfAbsent(chatId, () => []).add(msg);
      }

      return byChat;
    } catch (_) {
      // Fail silently and return empty data to avoid impacting runtime.
      return <int, List<MessageModel>>{};
    }
  }
}

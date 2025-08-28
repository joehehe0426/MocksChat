import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:chatapp/Model/MessageModel.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null && _database!.isOpen) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'whatsapp_clone.db');
    return await openDatabase(
      path,
      version: 4,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      singleInstance: true,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create messages table with indexes for better performance
    await db.execute('''
      CREATE TABLE messages(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        chatId INTEGER NOT NULL,
        message TEXT NOT NULL,
        type TEXT NOT NULL,
        time TEXT NOT NULL,
        date TEXT,
        timestamp INTEGER NOT NULL,
        attachmentType TEXT,
        attachmentPath TEXT,
        attachmentName TEXT,
        status TEXT
      )
    ''');

    // Create indexes for better query performance
    await db.execute('CREATE INDEX idx_messages_chatid ON messages(chatId)');
    await db.execute('CREATE INDEX idx_messages_timestamp ON messages(timestamp)');

    // Create chat sessions table
    await db.execute('''
      CREATE TABLE chat_sessions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        chatId INTEGER NOT NULL UNIQUE,
        lastMessage TEXT,
        lastMessageTime TEXT,
        unreadCount INTEGER DEFAULT 0,
        profileImage TEXT
      )
    ''');

    // Create contacts table
    await db.execute('''
      CREATE TABLE contacts(
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        phoneNumber TEXT NOT NULL,
        avatar TEXT,
        isFavorite INTEGER DEFAULT 0,
        timestamp INTEGER NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // For this migration, we want to remove AUTOINCREMENT from contacts.id.
    // SQLite doesn't support altering primary key directly; we'll recreate the table.
  if (oldVersion < 2) {
      await db.transaction((txn) async {
        // Create new table without AUTOINCREMENT
        await txn.execute('''
          CREATE TABLE IF NOT EXISTS contacts_new(
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL,
            phoneNumber TEXT NOT NULL,
            avatar TEXT,
            isFavorite INTEGER DEFAULT 0,
            timestamp INTEGER NOT NULL
          )
        ''');

        // Copy data over if any exists
        await txn.execute('''
          INSERT INTO contacts_new(id, name, phoneNumber, avatar, isFavorite, timestamp)
          SELECT id, name, phoneNumber, avatar, isFavorite, timestamp FROM contacts
        ''');

        // Replace old table
        await txn.execute('DROP TABLE IF EXISTS contacts');
        await txn.execute('ALTER TABLE contacts_new RENAME TO contacts');
      });
    }
    // Add status column to messages in version 4
    if (oldVersion < 4) {
      try {
        await db.execute('ALTER TABLE messages ADD COLUMN status TEXT');
        // Backfill existing rows with a default value (sent) where status is NULL
        await db.execute("UPDATE messages SET status = 'sent' WHERE status IS NULL");
      } catch (e) {
        // ignore if column already exists or migration fails; log for debugging
        print('Status column migration skipped or failed: $e');
      }
    }
  }

  // Insert a new message with error handling
  Future<int> insertMessage(MessageModel message, int chatId) async {
    try {
      final db = await database;
      return await db.insert('messages', {
        'chatId': chatId,
        'message': message.message ?? '',
        'type': message.type ?? 'source',
        'time': message.time ?? '',
        'date': message.date ?? DateTime.now().toIso8601String().split('T')[0],
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'attachmentType': message.attachmentType,
        'attachmentPath': message.attachmentPath,
  'attachmentName': message.attachmentName,
  'status': message.status,
      });
    } catch (e) {
      print('Error inserting message: $e');
      rethrow;
    }
  }

  // Get all messages for a specific chat with pagination
  Future<List<MessageModel>> getMessages(int chatId, {int limit = 50, int offset = 0}) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'messages',
        where: 'chatId = ?',
        whereArgs: [chatId],
        orderBy: 'timestamp ASC', // Changed to ASC for chronological order
        limit: limit,
        offset: offset,
      );

      return List.generate(maps.length, (i) {
        return MessageModel(
          type: maps[i]['type'],
          message: maps[i]['message'],
          time: maps[i]['time'],
          date: maps[i]['date'],
          attachmentType: maps[i]['attachmentType'],
          attachmentPath: maps[i]['attachmentPath'],
          attachmentName: maps[i]['attachmentName'],
          status: maps[i]['status'],
        );
      }); // No need to reverse since we're using ASC order
    } catch (e) {
      print('Error getting messages: $e');
      return [];
    }
  }

  // Get the last message for a specific chat
  Future<MessageModel?> getLastMessage(int chatId) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'messages',
        where: 'chatId = ?',
        whereArgs: [chatId],
        orderBy: 'timestamp DESC',
        limit: 1,
      );

      if (maps.isNotEmpty) {
        return MessageModel(
          type: maps.first['type'],
          message: maps.first['message'],
          time: maps.first['time'],
          date: maps.first['date'],
          attachmentType: maps.first['attachmentType'],
          attachmentPath: maps.first['attachmentPath'],
          attachmentName: maps.first['attachmentName'],
          status: maps.first['status'],
        );
      }
      return null;
    } catch (e) {
      print('Error getting last message: $e');
      return null;
    }
  }

  // Update chat session with upsert behavior
  Future<void> updateChatSession(int chatId, String lastMessage, String lastMessageTime) async {
    try {
      final db = await database;
      
      await db.insert(
        'chat_sessions',
        {
          'chatId': chatId,
          'lastMessage': lastMessage,
          'lastMessageTime': lastMessageTime,
          'unreadCount': 0,
          'profileImage': null,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Error updating chat session: $e');
    }
  }

  // Update profile image
  Future<void> updateProfileImage(int chatId, String profileImagePath) async {
    try {
      final db = await database;
      
      await db.insert(
        'chat_sessions',
        {
          'chatId': chatId,
          'lastMessage': '',
          'lastMessageTime': '',
          'unreadCount': 0,
          'profileImage': profileImagePath,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Error updating profile image: $e');
    }
  }

  // Get chat session
  Future<Map<String, dynamic>?> getChatSession(int chatId) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'chat_sessions',
        where: 'chatId = ?',
        whereArgs: [chatId],
        limit: 1,
      );

      return maps.isNotEmpty ? maps.first : null;
    } catch (e) {
      print('Error getting chat session: $e');
      return null;
    }
  }

  // Delete all messages for a chat
  Future<void> deleteChatMessages(int chatId) async {
    try {
      final db = await database;
      await db.delete(
        'messages',
        where: 'chatId = ?',
        whereArgs: [chatId],
      );
    } catch (e) {
      print('Error deleting chat messages: $e');
    }
  }

  // Delete all data for a chat (messages and session)
  Future<void> deleteChatData(int chatId) async {
    try {
      final db = await database;
      await db.transaction((txn) async {
        await txn.delete(
          'messages',
          where: 'chatId = ?',
          whereArgs: [chatId],
        );
        await txn.delete(
          'chat_sessions',
          where: 'chatId = ?',
          whereArgs: [chatId],
        );
      });
    } catch (e) {
      print('Error deleting chat data: $e');
    }
  }

  // Close database
  Future<void> close() async {
    try {
      final db = await database;
      await db.close();
      _database = null;
    } catch (e) {
      print('Error closing database: $e');
    }
  }

  // Debug: Get all messages from database
  Future<List<Map<String, dynamic>>> getAllMessages() async {
    try {
      final db = await database;
      return await db.query('messages');
    } catch (e) {
      print('Error getting all messages: $e');
      return [];
    }
  }

  // Debug: Get all chat sessions from database
  Future<List<Map<String, dynamic>>> getAllChatSessions() async {
    try {
      final db = await database;
      return await db.query('chat_sessions');
    } catch (e) {
      print('Error getting all chat sessions: $e');
      return [];
    }
  }

  // Clear all database data
  Future<void> clearAllData() async {
    try {
      final db = await database;
      await db.transaction((txn) async {
        await txn.delete('messages');
        await txn.delete('chat_sessions');
        await txn.delete('contacts');
      });
      print('🗑️ Database cleared successfully');
    } catch (e) {
      print('Error clearing database: $e');
    }
  }

  // Contact Management Methods
  Future<int> insertContact(String name, String phoneNumber, {int? id, String? avatar, bool isFavorite = false}) async {
    try {
      final db = await database;
      final data = {
        'name': name,
        'phoneNumber': phoneNumber,
        'avatar': avatar,
        'isFavorite': isFavorite ? 1 : 0,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };
      if (id != null) {
        data['id'] = id;
      }
      return await db.insert('contacts', data);
    } catch (e) {
      print('Error inserting contact: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getAllContacts() async {
    try {
      final db = await database;
      
      // Join contacts with chat_sessions to get profile images
      final List<Map<String, dynamic>> maps = await db.rawQuery('''
        SELECT 
          c.id,
          c.name,
          c.phoneNumber,
          c.avatar,
          c.isFavorite,
          c.timestamp,
          cs.profileImage
        FROM contacts c
        LEFT JOIN chat_sessions cs ON c.id = cs.chatId
        ORDER BY c.name ASC
      ''');

      return maps;
    } catch (e) {
      print('Error getting all contacts: $e');
      return [];
    }
  }

  Future<void> updateContact(int id, String name, String phoneNumber, {String? avatar, bool? isFavorite}) async {
    try {
      final db = await database;
      Map<String, dynamic> data = {
        'name': name,
        'phoneNumber': phoneNumber,
      };
      
      if (avatar != null) data['avatar'] = avatar;
      if (isFavorite != null) data['isFavorite'] = isFavorite ? 1 : 0;
      
      await db.update(
        'contacts',
        data,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('Error updating contact: $e');
    }
  }

  Future<void> deleteContact(int id) async {
    try {
      final db = await database;
      await db.delete(
        'contacts',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('Error deleting contact: $e');
    }
  }

  Future<Map<String, dynamic>?> getContact(int id) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'contacts',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      return maps.isNotEmpty ? maps.first : null;
    } catch (e) {
      print('Error getting contact: $e');
      return null;
    }
  }

  Future<void> toggleFavorite(int id, bool isFavorite) async {
    try {
      final db = await database;
      await db.update(
        'contacts',
        {'isFavorite': isFavorite ? 1 : 0},
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('Error toggling favorite: $e');
    }
  }

  // Get contacts by phone number
  Future<List<Map<String, dynamic>>> getContactsByPhone(String phone) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'contacts',
        where: 'phoneNumber LIKE ?',
        whereArgs: ['%$phone%'],
        orderBy: 'name ASC',
      );

      return maps;
    } catch (e) {
      print('Error getting contacts by phone: $e');
      return [];
    }
  }

  // Update contact avatar
  Future<void> updateContactAvatar(int id, String? path) async {
    try {
      final db = await database;
      await db.update(
        'contacts',
        {'avatar': path},
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('Error updating contact avatar: $e');
    }
  }

  // Update last contacted timestamp
  Future<void> updateLastContacted(int id, int timestamp) async {
    try {
      final db = await database;
      await db.update(
        'contacts',
        {'timestamp': timestamp},
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('Error updating last contacted: $e');
    }
  }

  // Debug: Print all database contents
  Future<void> printDatabaseContents() async {
    try {
      print('=== DATABASE CONTENTS ===');
      
      // Print all messages
      List<Map<String, dynamic>> messages = await getAllMessages();
      print('MESSAGES (${messages.length} total):');
      for (var msg in messages) {
        print('  ChatID: ${msg['chatId']}, Type: ${msg['type']}, Message: ${msg['message']}, Time: ${msg['time']}');
      }
      
      // Print all chat sessions
      List<Map<String, dynamic>> sessions = await getAllChatSessions();
      print('CHAT SESSIONS (${sessions.length} total):');
      for (var session in sessions) {
        print('  ChatID: ${session['chatId']}, LastMessage: ${session['lastMessage']}, LastTime: ${session['lastMessageTime']}, ProfileImage: ${session['profileImage']}');
      }
      
      // Print all contacts
      List<Map<String, dynamic>> contacts = await getAllContacts();
      print('CONTACTS (${contacts.length} total):');
      for (var contact in contacts) {
        print('  ID: ${contact['id']}, Name: ${contact['name']}, Phone: ${contact['phoneNumber']}, Favorite: ${contact['isFavorite']}');
      }
      
      print('=== END DATABASE CONTENTS ===');
    } catch (e) {
      print('Error printing database contents: $e');
    }
  }
}

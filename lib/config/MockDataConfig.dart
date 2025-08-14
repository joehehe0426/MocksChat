// ========================================
// MOCK CHAT HISTORY CONFIGURATION
// ========================================
// Edit this file to customize your mock chat history
// The data will be automatically loaded when the app starts

class MockDataConfig {
  // ========================================
  // CONTACTS CONFIGURATION - FAMILY MEMBERS & FRIENDS
  // ========================================
  static const List<Map<String, dynamic>> contacts = [
    {
      'name': '老豆',
      'phoneNumber': '+86 138 0000 0001',
      'avatar': 'person.svg',
      'status': '在线',
      'profileImage': 'assets/profile_pictures/1.jpg',
    },
    {
      'name': '媽',
      'phoneNumber': '+86 138 0000 0002',
      'avatar': 'person.svg',
      'status': '在线',
      'profileImage': 'assets/profile_pictures/2.jpg',
    },
    {
      'name': '哥',
      'phoneNumber': '+86 138 0000 0003',
      'avatar': 'person.svg',
      'status': '2小时前在线',
      'profileImage': 'assets/profile_pictures/3.jpg',
    },
    {
      'name': '爺爺',
      'phoneNumber': '+86 138 0000 0004',
      'avatar': 'person.svg',
      'status': '在线',
      'profileImage': 'assets/profile_pictures/4.jpg',
    },
    {
      'name': '呀婆',
      'phoneNumber': '+86 138 0000 0005',
      'avatar': 'person.svg',
      'status': '1小时前在线',
      'profileImage': 'assets/profile_pictures/5.jpg',
    },
    {
      'name': '呀嫲',
      'phoneNumber': '+86 138 0000 0006',
      'avatar': 'person.svg',
      'status': '在线',
      'profileImage': 'assets/profile_pictures/6.jpg',
    },
    {
      'name': '梅姨',
      'phoneNumber': '+86 138 0000 0007',
      'avatar': 'person.svg',
      'status': '昨天在线',
      'profileImage': 'assets/profile_pictures/7.jpg',
    },
    {
      'name': '舅父',
      'phoneNumber': '+86 138 0000 0008',
      'avatar': 'person.svg',
      'status': '在线',
      'profileImage': 'assets/profile_pictures/8.jpg',
    },
    {
      'name': '小明',
      'phoneNumber': '+86 138 0000 0009',
      'avatar': 'person.svg',
      'status': '在线',
      'profileImage': 'assets/profile_pictures/9.jpg',
    },
    {
      'name': '小華',
      'phoneNumber': '+86 138 0000 0010',
      'avatar': 'person.svg',
      'status': '3小时前在线',
      'profileImage': 'assets/profile_pictures/10.jpg',
    },
    {
      'name': '阿強',
      'phoneNumber': '+86 138 0000 0011',
      'avatar': 'person.svg',
      'status': '在线',
      'profileImage': 'assets/profile_pictures/11.jpg',
    },
    {
      'name': '小美',
      'phoneNumber': '+86 138 0000 0012',
      'avatar': 'person.svg',
      'status': '昨天在线',
      'profileImage': 'assets/profile_pictures/12.jpg',
    },
    {
      'name': '阿傑',
      'phoneNumber': '+86 138 0000 0013',
      'avatar': 'person.svg',
      'status': '在线',
      'profileImage': 'assets/profile_pictures/13.jpg',
    },
    {
      'name': '小麗',
      'phoneNumber': '+86 138 0000 0014',
      'avatar': 'person.svg',
      'status': '1小时前在线',
      'profileImage': 'assets/profile_pictures/14.jpg',
    },
    {
      'name': '阿偉',
      'phoneNumber': '+86 138 0000 0015',
      'avatar': 'person.svg',
      'status': '在线',
      'profileImage': 'assets/profile_pictures/15.jpg',
    },
  ];

  // ========================================
  // MESSAGES CONFIGURATION - 1 MONTH OF FAMILY HISTORY
  // ========================================
  // Format: {'chatId': 1, 'message': 'text', 'type': 'source/destination', 'time': 'HH:MM', 'date': 'YYYY-MM-DD', 'attachmentType': 'image/document/audio', 'attachmentPath': 'path', 'attachmentName': 'name'}
  static const List<Map<String, dynamic>> messages = [
    // ========================================
    // 老豆 (ID: 1) - Work, Health, Family Updates
    // ========================================
    {'chatId': 1, 'message': '仔，工作怎麼樣？', 'type': 'destination', 'time': '08:30', 'date': '2024-01-15'},
    {'chatId': 1, 'message': '還好，最近比較忙', 'type': 'source', 'time': '08:35', 'date': '2024-01-15'},
    {'chatId': 1, 'message': '注意身體，不要太累', 'type': 'destination', 'time': '08:40', 'date': '2024-01-15'},
    {'chatId': 1, 'message': '知道，謝謝老豆', 'type': 'source', 'time': '08:45', 'date': '2024-01-15'},
    {'chatId': 1, 'message': '這個週末回家吃飯嗎？', 'type': 'destination', 'time': '12:00', 'date': '2024-01-16'},
    {'chatId': 1, 'message': '好啊，我想吃媽煮的菜', 'type': 'source', 'time': '12:05', 'date': '2024-01-16'},
    {'chatId': 1, 'message': '媽說要煮你最愛的紅燒肉', 'type': 'destination', 'time': '12:10', 'date': '2024-01-16'},
    {'chatId': 1, 'message': '太好了！', 'type': 'source', 'time': '12:15', 'date': '2024-01-16'},
    {'chatId': 1, 'message': '', 'type': 'destination', 'time': '18:30', 'date': '2024-01-17', 'attachmentType': 'image', 'attachmentPath': 'assets/profile_pictures/1.jpg', 'attachmentName': '新買的茶葉'},
    {'chatId': 1, 'message': '這個茶葉不錯，下次帶給你', 'type': 'destination', 'time': '18:32', 'date': '2024-01-17'},
    {'chatId': 1, 'message': '看起來很好，謝謝老豆', 'type': 'source', 'time': '18:35', 'date': '2024-01-17'},
    {'chatId': 1, 'message': '身體檢查報告出來了', 'type': 'destination', 'time': '14:20', 'date': '2024-01-18'},
    {'chatId': 1, 'message': '怎麼樣？', 'type': 'source', 'time': '14:25', 'date': '2024-01-18'},
    {'chatId': 1, 'message': '一切正常，放心', 'type': 'destination', 'time': '14:30', 'date': '2024-01-18'},
    {'chatId': 1, 'message': '那就好，注意保重', 'type': 'source', 'time': '14:35', 'date': '2024-01-18'},
    {'chatId': 1, 'message': '爺爺最近身體不太好', 'type': 'destination', 'time': '20:15', 'date': '2024-01-19'},
    {'chatId': 1, 'message': '怎麼了？', 'type': 'source', 'time': '20:20', 'date': '2024-01-19'},
    {'chatId': 1, 'message': '感冒了，我們明天去看他', 'type': 'destination', 'time': '20:25', 'date': '2024-01-19'},
    {'chatId': 1, 'message': '好的，我也去', 'type': 'source', 'time': '20:30', 'date': '2024-01-19'},

    // ========================================
    // 媽 (ID: 2) - Food, Health, Daily Life
    // ========================================
    {'chatId': 2, 'message': '仔，吃飯了嗎？', 'type': 'destination', 'time': '12:30', 'date': '2024-01-20'},
    {'chatId': 2, 'message': '剛吃完，媽你呢？', 'type': 'source', 'time': '12:35', 'date': '2024-01-20'},
    {'chatId': 2, 'message': '我也剛吃完，今天煮了湯', 'type': 'destination', 'time': '12:40', 'date': '2024-01-20'},
    {'chatId': 2, 'message': '', 'type': 'destination', 'time': '12:42', 'date': '2024-01-20', 'attachmentType': 'image', 'attachmentPath': 'assets/profile_pictures/2.jpeg', 'attachmentName': '今天的湯'},
    {'chatId': 2, 'message': '看起來很美味！', 'type': 'source', 'time': '12:45', 'date': '2024-01-20'},
    {'chatId': 2, 'message': '週末回來煮給你喝', 'type': 'destination', 'time': '12:50', 'date': '2024-01-20'},
    {'chatId': 2, 'message': '好啊，期待！', 'type': 'source', 'time': '12:55', 'date': '2024-01-20'},
    {'chatId': 2, 'message': '今天去買菜，菜價又漲了', 'type': 'destination', 'time': '16:20', 'date': '2024-01-21'},
    {'chatId': 2, 'message': '是啊，什麼都貴了', 'type': 'source', 'time': '16:25', 'date': '2024-01-21'},
    {'chatId': 2, 'message': '不過還是要買新鮮的', 'type': 'destination', 'time': '16:30', 'date': '2024-01-21'},
    {'chatId': 2, 'message': '媽，你也要注意身體', 'type': 'source', 'time': '16:35', 'date': '2024-01-21'},
    {'chatId': 2, 'message': '知道，我會的', 'type': 'destination', 'time': '16:40', 'date': '2024-01-21'},
    {'chatId': 2, 'message': '今天學會了新的菜譜', 'type': 'destination', 'time': '19:15', 'date': '2024-01-22'},
    {'chatId': 2, 'message': '什麼菜？', 'type': 'source', 'time': '19:20', 'date': '2024-01-22'},
    {'chatId': 2, 'message': '麻婆豆腐，下次做給你吃', 'type': 'destination', 'time': '19:25', 'date': '2024-01-22'},
    {'chatId': 2, 'message': '太好了，我最愛吃豆腐', 'type': 'source', 'time': '19:30', 'date': '2024-01-22'},
    {'chatId': 2, 'message': '天氣變冷了，記得多穿衣服', 'type': 'destination', 'time': '21:00', 'date': '2024-01-23'},
    {'chatId': 2, 'message': '知道，媽你也是', 'type': 'source', 'time': '21:05', 'date': '2024-01-23'},
    {'chatId': 2, 'message': '早點睡覺，不要熬夜', 'type': 'destination', 'time': '22:30', 'date': '2024-01-23'},
    {'chatId': 2, 'message': '好的，媽晚安', 'type': 'source', 'time': '22:35', 'date': '2024-01-23'},

    // ========================================
    // 哥 (ID: 3) - Work, Technology, Sports
    // ========================================
    {'chatId': 3, 'message': '弟，最近工作怎麼樣？', 'type': 'destination', 'time': '09:00'},
    {'chatId': 3, 'message': '還好，你呢？', 'type': 'source', 'time': '09:05'},
    {'chatId': 3, 'message': '忙死了，項目要趕工', 'type': 'destination', 'time': '09:10'},
    {'chatId': 3, 'message': '加油，注意休息', 'type': 'source', 'time': '09:15'},
    {'chatId': 3, 'message': '這個週末打籃球嗎？', 'type': 'destination', 'time': '17:30'},
    {'chatId': 3, 'message': '好啊，幾點？', 'type': 'source', 'time': '17:35'},
    {'chatId': 3, 'message': '下午3點，老地方', 'type': 'destination', 'time': '17:40'},
    {'chatId': 3, 'message': '好的，不見不散', 'type': 'source', 'time': '17:45'},
    {'chatId': 3, 'message': '你看昨晚的球賽了嗎？', 'type': 'destination', 'time': '22:00'},
    {'chatId': 3, 'message': '看了，太精彩了！', 'type': 'source', 'time': '22:05'},
    {'chatId': 3, 'message': '那個三分球太厲害了', 'type': 'destination', 'time': '22:10'},
    {'chatId': 3, 'message': '是啊，絕殺！', 'type': 'source', 'time': '22:15'},
    {'chatId': 3, 'message': '新手機怎麼樣？', 'type': 'destination', 'time': '14:20'},
    {'chatId': 3, 'message': '很好用，拍照很清晰', 'type': 'source', 'time': '14:25'},
    {'chatId': 3, 'message': '', 'type': 'source', 'time': '14:27', 'attachmentType': 'image', 'attachmentPath': 'assets/profile_pictures/3.jpg', 'attachmentName': '新手機拍的'},
    {'chatId': 3, 'message': '確實很清晰', 'type': 'destination', 'time': '14:30'},
    {'chatId': 3, 'message': '推薦你也買一個', 'type': 'source', 'time': '14:35'},
    {'chatId': 3, 'message': '考慮一下', 'type': 'destination', 'time': '14:40'},

    // ========================================
    // 爺爺 (ID: 4) - Health, Stories, Family
    // ========================================
    {'chatId': 4, 'message': '孫仔，最近好嗎？', 'type': 'destination', 'time': '10:00'},
    {'chatId': 4, 'message': '爺爺，我很好，你呢？', 'type': 'source', 'time': '10:05'},
    {'chatId': 4, 'message': '我身體還好，就是有點感冒', 'type': 'destination', 'time': '10:10'},
    {'chatId': 4, 'message': '爺爺要保重身體', 'type': 'source', 'time': '10:15'},
    {'chatId': 4, 'message': '知道，我會的', 'type': 'destination', 'time': '10:20'},
    {'chatId': 4, 'message': '今天去公園散步了', 'type': 'destination', 'time': '16:00'},
    {'chatId': 4, 'message': '好啊，天氣不錯', 'type': 'source', 'time': '16:05'},
    {'chatId': 4, 'message': '遇到老朋友，聊了很久', 'type': 'destination', 'time': '16:10'},
    {'chatId': 4, 'message': '那很好啊', 'type': 'source', 'time': '16:15'},
    {'chatId': 4, 'message': '記得小時候的故事嗎？', 'type': 'destination', 'time': '20:30'},
    {'chatId': 4, 'message': '記得，爺爺經常講給我聽', 'type': 'source', 'time': '20:35'},
    {'chatId': 4, 'message': '那些都是珍貴的回憶', 'type': 'destination', 'time': '20:40'},
    {'chatId': 4, 'message': '是啊，謝謝爺爺', 'type': 'source', 'time': '20:45'},
    {'chatId': 4, 'message': '這個週末來看我嗎？', 'type': 'destination', 'time': '11:30'},
    {'chatId': 4, 'message': '好啊，我帶些水果去', 'type': 'source', 'time': '11:35'},
    {'chatId': 4, 'message': '不用帶東西，來就好', 'type': 'destination', 'time': '11:40'},
    {'chatId': 4, 'message': '爺爺，早點休息', 'type': 'source', 'time': '21:00'},
    {'chatId': 4, 'message': '好的，孫仔晚安', 'type': 'destination', 'time': '21:05'},

    // ========================================
    // 呀婆 (ID: 5) - Cooking, Health, Family News
    // ========================================
    {'chatId': 5, 'message': '孫仔，吃飯了嗎？', 'type': 'destination', 'time': '12:00'},
    {'chatId': 5, 'message': '呀婆，剛吃完', 'type': 'source', 'time': '12:05'},
    {'chatId': 5, 'message': '今天煮了湯，很補的', 'type': 'destination', 'time': '12:10'},
    {'chatId': 5, 'message': '謝謝呀婆', 'type': 'source', 'time': '12:15'},
    {'chatId': 5, 'message': '身體怎麼樣？', 'type': 'destination', 'time': '15:30'},
    {'chatId': 5, 'message': '還好，呀婆你呢？', 'type': 'source', 'time': '15:35'},
    {'chatId': 5, 'message': '我身體還好，就是膝蓋有點痛', 'type': 'destination', 'time': '15:40'},
    {'chatId': 5, 'message': '呀婆要小心，不要走太多', 'type': 'source', 'time': '15:45'},
    {'chatId': 5, 'message': '知道，我會注意的', 'type': 'destination', 'time': '15:50'},
    {'chatId': 5, 'message': '今天學會了新的菜', 'type': 'destination', 'time': '18:00'},
    {'chatId': 5, 'message': '什麼菜？', 'type': 'source', 'time': '18:05'},
    {'chatId': 5, 'message': '紅燒魚，下次做給你吃', 'type': 'destination', 'time': '18:10'},
    {'chatId': 5, 'message': '太好了，我最愛吃魚', 'type': 'source', 'time': '18:15'},
    {'chatId': 5, 'message': '天氣變冷了', 'type': 'destination', 'time': '20:00'},
    {'chatId': 5, 'message': '是啊，呀婆要多穿衣服', 'type': 'source', 'time': '20:05'},
    {'chatId': 5, 'message': '知道，你也是', 'type': 'destination', 'time': '20:10'},
    {'chatId': 5, 'message': '呀婆，早點休息', 'type': 'source', 'time': '21:30'},
    {'chatId': 5, 'message': '好的，孫仔晚安', 'type': 'destination', 'time': '21:35'},

    // ========================================
    // 呀嫲 (ID: 6) - Health, Family, Daily Life
    // ========================================
    {'chatId': 6, 'message': '孫仔，最近好嗎？', 'type': 'destination', 'time': '09:30'},
    {'chatId': 6, 'message': '呀嫲，我很好，你呢？', 'type': 'source', 'time': '09:35'},
    {'chatId': 6, 'message': '我身體還好，就是有點累', 'type': 'destination', 'time': '09:40'},
    {'chatId': 6, 'message': '呀嫲要多休息', 'type': 'source', 'time': '09:45'},
    {'chatId': 6, 'message': '知道，我會的', 'type': 'destination', 'time': '09:50'},
    {'chatId': 6, 'message': '今天去買菜了', 'type': 'destination', 'time': '14:00'},
    {'chatId': 6, 'message': '買了什麼？', 'type': 'source', 'time': '14:05'},
    {'chatId': 6, 'message': '買了魚和青菜', 'type': 'destination', 'time': '14:10'},
    {'chatId': 6, 'message': '好啊，營養均衡', 'type': 'source', 'time': '14:15'},
    {'chatId': 6, 'message': '今天天氣不錯', 'type': 'destination', 'time': '16:30'},
    {'chatId': 6, 'message': '是啊，適合散步', 'type': 'source', 'time': '16:35'},
    {'chatId': 6, 'message': '我去公園走了一圈', 'type': 'destination', 'time': '16:40'},
    {'chatId': 6, 'message': '很好，呀嫲要堅持運動', 'type': 'source', 'time': '16:45'},
    {'chatId': 6, 'message': '知道，我會的', 'type': 'destination', 'time': '16:50'},
    {'chatId': 6, 'message': '這個週末來看我嗎？', 'type': 'destination', 'time': '19:00'},
    {'chatId': 6, 'message': '好啊，我帶些水果去', 'type': 'source', 'time': '19:05'},
    {'chatId': 6, 'message': '不用帶東西，來就好', 'type': 'destination', 'time': '19:10'},
    {'chatId': 6, 'message': '呀嫲，早點休息', 'type': 'source', 'time': '21:00'},
    {'chatId': 6, 'message': '好的，孫仔晚安', 'type': 'destination', 'time': '21:05'},

    // ========================================
    // 梅姨 (ID: 7) - Work, Travel, Family News
    // ========================================
    {'chatId': 7, 'message': '姪仔，最近工作怎麼樣？', 'type': 'destination', 'time': '10:00'},
    {'chatId': 7, 'message': '梅姨，還好，你呢？', 'type': 'source', 'time': '10:05'},
    {'chatId': 7, 'message': '我工作很忙，經常出差', 'type': 'destination', 'time': '10:10'},
    {'chatId': 7, 'message': '梅姨要保重身體', 'type': 'source', 'time': '10:15'},
    {'chatId': 7, 'message': '知道，我會的', 'type': 'destination', 'time': '10:20'},
    {'chatId': 7, 'message': '這個月要去上海出差', 'type': 'destination', 'time': '15:00'},
    {'chatId': 7, 'message': '去多久？', 'type': 'source', 'time': '15:05'},
    {'chatId': 7, 'message': '一個星期', 'type': 'destination', 'time': '15:10'},
    {'chatId': 7, 'message': '注意安全', 'type': 'source', 'time': '15:15'},
    {'chatId': 7, 'message': '知道，謝謝關心', 'type': 'destination', 'time': '15:20'},
    {'chatId': 7, 'message': '今天買了新衣服', 'type': 'destination', 'time': '18:00'},
    {'chatId': 7, 'message': '什麼顏色的？', 'type': 'source', 'time': '18:05'},
    {'chatId': 7, 'message': '藍色的，很漂亮', 'type': 'destination', 'time': '18:10'},
    {'chatId': 7, 'message': '', 'type': 'destination', 'time': '18:12', 'attachmentType': 'image', 'attachmentPath': 'assets/profile_pictures/balram.jpg', 'attachmentName': '新衣服'},
    {'chatId': 7, 'message': '確實很漂亮', 'type': 'source', 'time': '18:15'},
    {'chatId': 7, 'message': '謝謝', 'type': 'destination', 'time': '18:20'},
    {'chatId': 7, 'message': '這個週末回家嗎？', 'type': 'destination', 'time': '20:00'},
    {'chatId': 7, 'message': '應該會，梅姨呢？', 'type': 'source', 'time': '20:05'},
    {'chatId': 7, 'message': '我也會回去', 'type': 'destination', 'time': '20:10'},
    {'chatId': 7, 'message': '那到時候見', 'type': 'source', 'time': '20:15'},

    // ========================================
    // 舅父 (ID: 8) - Business, Investment, Family
    // ========================================
    {'chatId': 8, 'message': '姪仔，最近怎麼樣？', 'type': 'destination', 'time': '11:00'},
    {'chatId': 8, 'message': '舅父，還好，你呢？', 'type': 'source', 'time': '11:05'},
    {'chatId': 8, 'message': '我生意還不錯', 'type': 'destination', 'time': '11:10'},
    {'chatId': 8, 'message': '那就好', 'type': 'source', 'time': '11:15'},
    {'chatId': 8, 'message': '最近有什麼投資機會嗎？', 'type': 'destination', 'time': '14:30'},
    {'chatId': 8, 'message': '我不太懂投資', 'type': 'source', 'time': '14:35'},
    {'chatId': 8, 'message': '可以學習一下', 'type': 'destination', 'time': '14:40'},
    {'chatId': 8, 'message': '好的，有機會請教舅父', 'type': 'source', 'time': '14:45'},
    {'chatId': 8, 'message': '今天去見客戶了', 'type': 'destination', 'time': '17:00'},
    {'chatId': 8, 'message': '談得怎麼樣？', 'type': 'source', 'time': '17:05'},
    {'chatId': 8, 'message': '還不錯，有希望合作', 'type': 'destination', 'time': '17:10'},
    {'chatId': 8, 'message': '恭喜舅父', 'type': 'source', 'time': '17:15'},
    {'chatId': 8, 'message': '謝謝', 'type': 'destination', 'time': '17:20'},
    {'chatId': 8, 'message': '這個週末有時間嗎？', 'type': 'destination', 'time': '19:30'},
    {'chatId': 8, 'message': '有，舅父有什麼事？', 'type': 'source', 'time': '19:35'},
    {'chatId': 8, 'message': '想請你吃飯', 'type': 'destination', 'time': '19:40'},
    {'chatId': 8, 'message': '好啊，謝謝舅父', 'type': 'source', 'time': '19:45'},
    {'chatId': 8, 'message': '到時候聯繫', 'type': 'destination', 'time': '19:50'},
    {'chatId': 8, 'message': '好的', 'type': 'source', 'time': '19:55'},
  ];

  // ========================================
  // CHAT SESSIONS CONFIGURATION
  // ========================================
  // These will be automatically updated with the latest message from each chat
  static const List<Map<String, dynamic>> chatSessions = [
    {
      'chatId': 1,
      'lastMessage': '這個週末回家吃飯嗎？',
      'lastMessageTime': '12:00',
      'unreadCount': 0,
    },
    {
      'chatId': 2,
      'lastMessage': '早點睡覺，不要熬夜',
      'lastMessageTime': '22:35',
      'unreadCount': 1,
    },
    {
      'chatId': 3,
      'lastMessage': '考慮一下',
      'lastMessageTime': '14:40',
      'unreadCount': 0,
    },
    {
      'chatId': 4,
      'lastMessage': '爺爺，早點休息',
      'lastMessageTime': '21:00',
      'unreadCount': 2,
    },
    {
      'chatId': 5,
      'lastMessage': '呀婆，早點休息',
      'lastMessageTime': '21:35',
      'unreadCount': 0,
    },
    {
      'chatId': 6,
      'lastMessage': '呀嫲，早點休息',
      'lastMessageTime': '21:05',
      'unreadCount': 1,
    },
    {
      'chatId': 7,
      'lastMessage': '這個週末回家嗎？',
      'lastMessageTime': '20:00',
      'unreadCount': 0,
    },
    {
      'chatId': 8,
      'lastMessage': '到時候聯繫',
      'lastMessageTime': '19:50',
      'unreadCount': 3,
    },
  ];

  // ========================================
  // CONFIGURATION SETTINGS
  // ========================================
  static const bool enableMockData = true;
  // ========================================
  // DATABASE CONFIGURATION
  // ========================================
  // Set to true to clear existing data and re-seed with new mock data
  // Set to false to keep existing data
  static const bool clearExistingData = true; // Force clear to fix chat history
  static const bool showDebugLogs = true;
}

// ========================================
// MOCK CHAT HISTORY CONFIGURATION
// ========================================
// Edit this file to customize your mock chat history
// The data will be automatically loaded when the app starts

class MockDataConfig {
  // ========================================
  // CONTACTS CONFIGURATION
  // ========================================
  static const List<Map<String, dynamic>> contacts = [
    {
      'name': '张三',
      'phoneNumber': '+86 138 0000 0001',
      'avatar': 'person.svg',
      'status': '在线',
      'profileImage': 'assets/profile_pictures/1.jpg',
    },
    {
      'name': '李四',
      'phoneNumber': '+86 138 0000 0002',
      'avatar': 'person.svg',
      'status': '2小时前在线',
      'profileImage': 'assets/2.jpeg',
    },
    {
      'name': '王五',
      'phoneNumber': '+86 138 0000 0003',
      'avatar': 'person.svg',
      'status': '在线',
      'profileImage': 'assets/3.jpg',
    },
    {
      'name': '陈雅婷',
      'phoneNumber': '+86 138 0000 0004',
      'avatar': 'person.svg',
      'status': '在线',
      'profileImage': 'assets/balram.jpg',
    },
    {
      'name': '刘志强',
      'phoneNumber': '+86 138 0000 0005',
      'avatar': 'person.svg',
      'status': '1小时前在线',
      'profileImage': 'assets/1.png',
    },
    {
      'name': '黄小华',
      'phoneNumber': '+86 138 0000 0006',
      'avatar': 'person.svg',
      'status': '在线',
      'profileImage': 'assets/2.jpeg',
    },
    {
      'name': '林志明',
      'phoneNumber': '+86 138 0000 0007',
      'avatar': 'person.svg',
      'status': '昨天在线',
      'profileImage': 'assets/3.jpg',
    },
    {
      'name': '吴雅芳',
      'phoneNumber': '+86 138 0000 0008',
      'avatar': 'person.svg',
      'status': '在线',
      'profileImage': 'assets/balram.jpg',
    },
    {
      'name': '赵大伟',
      'phoneNumber': '+86 138 0000 0009',
      'avatar': 'person.svg',
      'status': '3小时前在线',
      'profileImage': 'assets/1.jpg',
    },
    {
      'name': '孙丽丽',
      'phoneNumber': '+86 138 0000 0010',
      'avatar': 'person.svg',
      'status': '在线',
      'profileImage': 'assets/2.jpeg',
    },
    {
      'name': '郑志豪',
      'phoneNumber': '+86 138 0000 0011',
      'avatar': 'person.svg',
      'status': '昨天在线',
      'profileImage': 'assets/3.jpg',
    },
    {
      'name': '工作群',
      'phoneNumber': '+86 138 0000 0012',
      'avatar': 'group.svg',
      'status': '12个成员',
    },
  ];

  // ========================================
  // MESSAGES CONFIGURATION - 1 MONTH OF HISTORY
  // ========================================
  // Format: {'chatId': 1, 'message': 'text', 'type': 'source/destination', 'time': 'HH:MM', 'attachmentType': 'image/document/audio', 'attachmentPath': 'path', 'attachmentName': 'name'}
  static const List<Map<String, dynamic>> messages = [
    // Chat with 张三 (ID: 1) - Recent messages with attachments
    {'chatId': 1, 'message': '你好，最近怎么样？', 'type': 'destination', 'time': '12:30'},
    {'chatId': 1, 'message': '我很好，谢谢！你呢？', 'type': 'source', 'time': '12:32'},
    {'chatId': 1, 'message': '工作很忙，但还不错', 'type': 'destination', 'time': '12:35'},
    {'chatId': 1, 'message': '那就好，注意休息', 'type': 'source', 'time': '12:37'},
    {'chatId': 1, 'message': '谢谢关心！', 'type': 'destination', 'time': '12:40'},
    {'chatId': 1, 'message': '周末一起吃饭吗？', 'type': 'source', 'time': '12:45'},
    {'chatId': 1, 'message': '好啊，去哪里？', 'type': 'destination', 'time': '12:47'},
    {'chatId': 1, 'message': '新开的火锅店怎么样？', 'type': 'source', 'time': '12:50'},
    {'chatId': 1, 'message': '听起来不错！', 'type': 'destination', 'time': '12:52'},
    {'chatId': 1, 'message': '', 'type': 'source', 'time': '12:55', 'attachmentType': 'image', 'attachmentPath': 'assets/profile_pictures/1.jpg', 'attachmentName': '火锅店照片'},
    {'chatId': 1, 'message': '看起来很好吃！', 'type': 'destination', 'time': '12:57'},

    // Chat with 李四 (ID: 2) - Work related with documents
    {'chatId': 2, 'message': '明天见！', 'type': 'destination', 'time': '11:45'},
    {'chatId': 2, 'message': '好的，明天见！', 'type': 'source', 'time': '11:47'},
    {'chatId': 2, 'message': '记得带文件', 'type': 'destination', 'time': '11:50'},
    {'chatId': 2, 'message': '好的，我会记得的', 'type': 'source', 'time': '11:52'},
    {'chatId': 2, 'message': '', 'type': 'source', 'time': '11:53', 'attachmentType': 'document', 'attachmentPath': 'assets/document.pdf', 'attachmentName': '项目报告.pdf'},
    {'chatId': 2, 'message': '项目进度如何？', 'type': 'destination', 'time': '11:55'},
    {'chatId': 2, 'message': '按计划进行中', 'type': 'source', 'time': '11:57'},
    {'chatId': 2, 'message': '有什么问题吗？', 'type': 'destination', 'time': '12:00'},
    {'chatId': 2, 'message': '暂时没有，一切顺利', 'type': 'source', 'time': '12:02'},

    // Chat with 王五 (ID: 3) - Project discussion with audio
    {'chatId': 3, 'message': '工作进展如何？', 'type': 'destination', 'time': '10:20'},
    {'chatId': 3, 'message': '项目进行得很顺利', 'type': 'source', 'time': '10:25'},
    {'chatId': 3, 'message': '太好了！', 'type': 'destination', 'time': '10:30'},
    {'chatId': 3, 'message': '', 'type': 'source', 'time': '10:32', 'attachmentType': 'audio', 'attachmentPath': 'assets/audio.mp3', 'attachmentName': '语音消息'},
    {'chatId': 3, 'message': '预计下周完成', 'type': 'source', 'time': '10:35'},
    {'chatId': 3, 'message': '期待看到结果', 'type': 'destination', 'time': '10:40'},
    {'chatId': 3, 'message': '需要我帮忙吗？', 'type': 'source', 'time': '10:45'},
    {'chatId': 3, 'message': '暂时不用，谢谢', 'type': 'destination', 'time': '10:47'},
    {'chatId': 3, 'message': '好的，有需要随时说', 'type': 'source', 'time': '10:50'},

    // Chat with 陈雅婷 (ID: 4) - Personal chat with images
    {'chatId': 4, 'message': '周末有什么计划？', 'type': 'destination', 'time': '09:15'},
    {'chatId': 4, 'message': '想去看电影', 'type': 'source', 'time': '09:20'},
    {'chatId': 4, 'message': '什么电影？', 'type': 'destination', 'time': '09:25'},
    {'chatId': 4, 'message': '新上映的科幻片', 'type': 'source', 'time': '09:30'},
    {'chatId': 4, 'message': '', 'type': 'source', 'time': '09:31', 'attachmentType': 'image', 'attachmentPath': 'assets/profile_pictures/2.jpeg', 'attachmentName': '电影海报'},
    {'chatId': 4, 'message': '听起来不错！', 'type': 'destination', 'time': '09:35'},
    {'chatId': 4, 'message': '要一起去看吗？', 'type': 'source', 'time': '09:40'},
    {'chatId': 4, 'message': '好啊，几点？', 'type': 'destination', 'time': '09:45'},
    {'chatId': 4, 'message': '下午3点怎么样？', 'type': 'source', 'time': '09:50'},

    // Chat with 刘志强 (ID: 5) - Technical discussion
    {'chatId': 5, 'message': '代码审查完成了吗？', 'type': 'destination', 'time': '08:30'},
    {'chatId': 5, 'message': '已经完成了', 'type': 'source', 'time': '08:35'},
    {'chatId': 5, 'message': '有什么问题吗？', 'type': 'destination', 'time': '08:40'},
    {'chatId': 5, 'message': '有几个小问题需要修改', 'type': 'source', 'time': '08:45'},
    {'chatId': 5, 'message': '什么时候能改完？', 'type': 'destination', 'time': '08:50'},
    {'chatId': 5, 'message': '今天下午就能完成', 'type': 'source', 'time': '08:55'},
    {'chatId': 5, 'message': '好的，辛苦了', 'type': 'destination', 'time': '09:00'},

    // Chat with 黄小华 (ID: 6) - Design feedback
    {'chatId': 6, 'message': 'UI设计稿看过了吗？', 'type': 'destination', 'time': '07:45'},
    {'chatId': 6, 'message': '看过了，整体不错', 'type': 'source', 'time': '07:50'},
    {'chatId': 6, 'message': '有什么建议吗？', 'type': 'destination', 'time': '07:55'},
    {'chatId': 6, 'message': '颜色搭配可以再调整一下', 'type': 'source', 'time': '08:00'},
    {'chatId': 6, 'message': '好的，我修改一下', 'type': 'destination', 'time': '08:05'},
    {'chatId': 6, 'message': '谢谢反馈', 'type': 'source', 'time': '08:10'},
    {'chatId': 6, 'message': '不客气', 'type': 'destination', 'time': '08:15'},

    // Chat with 林志明 (ID: 7) - Testing discussion
    {'chatId': 7, 'message': '测试用例写好了吗？', 'type': 'destination', 'time': '06:30'},
    {'chatId': 7, 'message': '已经写好了', 'type': 'source', 'time': '06:35'},
    {'chatId': 7, 'message': '覆盖率怎么样？', 'type': 'destination', 'time': '06:40'},
    {'chatId': 7, 'message': '达到85%以上', 'type': 'source', 'time': '06:45'},
    {'chatId': 7, 'message': '很好，继续努力', 'type': 'destination', 'time': '06:50'},
    {'chatId': 7, 'message': '谢谢鼓励', 'type': 'source', 'time': '06:55'},
    {'chatId': 7, 'message': '应该的', 'type': 'destination', 'time': '07:00'},

    // Chat with 吴雅芳 (ID: 8) - HR related with birthday photo
    {'chatId': 8, 'message': '生日快乐！🎉', 'type': 'destination', 'time': '05:15'},
    {'chatId': 8, 'message': '谢谢！', 'type': 'source', 'time': '05:20'},
    {'chatId': 8, 'message': '有什么庆祝计划吗？', 'type': 'destination', 'time': '05:25'},
    {'chatId': 8, 'message': '和家人一起吃饭', 'type': 'source', 'time': '05:30'},
    {'chatId': 8, 'message': '', 'type': 'source', 'time': '05:32', 'attachmentType': 'image', 'attachmentPath': 'assets/profile_pictures/3.jpg', 'attachmentName': '生日蛋糕'},
    {'chatId': 8, 'message': '听起来很棒！', 'type': 'destination', 'time': '05:35'},
    {'chatId': 8, 'message': '是的，很期待', 'type': 'source', 'time': '05:40'},
    {'chatId': 8, 'message': '祝你生日快乐！', 'type': 'destination', 'time': '05:45'},

    // Chat with 赵大伟 (ID: 9) - Architecture discussion
    {'chatId': 9, 'message': '系统架构设计完成了吗？', 'type': 'destination', 'time': '04:20'},
    {'chatId': 9, 'message': '基本完成了', 'type': 'source', 'time': '04:25'},
    {'chatId': 9, 'message': '有什么技术难点吗？', 'type': 'destination', 'time': '04:30'},
    {'chatId': 9, 'message': '性能优化方面需要深入研究', 'type': 'source', 'time': '04:35'},
    {'chatId': 9, 'message': '需要我协助吗？', 'type': 'destination', 'time': '04:40'},
    {'chatId': 9, 'message': '暂时不用，我先研究一下', 'type': 'source', 'time': '04:45'},
    {'chatId': 9, 'message': '好的，有需要随时说', 'type': 'destination', 'time': '04:50'},

    // Chat with 孙丽丽 (ID: 10) - Marketing discussion
    {'chatId': 10, 'message': '市场调研报告完成了吗？', 'type': 'destination', 'time': '03:10'},
    {'chatId': 10, 'message': '已经完成了', 'type': 'source', 'time': '03:15'},
    {'chatId': 10, 'message': '主要发现是什么？', 'type': 'destination', 'time': '03:20'},
    {'chatId': 10, 'message': '用户对产品功能很满意', 'type': 'source', 'time': '03:25'},
    {'chatId': 10, 'message': '太好了！', 'type': 'destination', 'time': '03:30'},
    {'chatId': 10, 'message': '还有什么改进建议吗？', 'type': 'source', 'time': '03:35'},
    {'chatId': 10, 'message': '界面可以更简洁一些', 'type': 'destination', 'time': '03:40'},

    // Chat with 郑志豪 (ID: 11) - Sales discussion
    {'chatId': 11, 'message': '销售目标完成得怎么样？', 'type': 'destination', 'time': '02:00'},
    {'chatId': 11, 'message': '超额完成了10%', 'type': 'source', 'time': '02:05'},
    {'chatId': 11, 'message': '太棒了！', 'type': 'destination', 'time': '02:10'},
    {'chatId': 11, 'message': '谢谢团队的支持', 'type': 'source', 'time': '02:15'},
    {'chatId': 11, 'message': '继续加油！', 'type': 'destination', 'time': '02:20'},
    {'chatId': 11, 'message': '一定会的', 'type': 'source', 'time': '02:25'},
    {'chatId': 11, 'message': '下个月的目标定了吗？', 'type': 'destination', 'time': '02:30'},

    // Work Group Chat (ID: 12)
    {'chatId': 12, 'message': '下午3点开会', 'type': 'destination', 'time': '09:15'},
    {'chatId': 12, 'message': '收到', 'type': 'source', 'time': '09:20'},
    {'chatId': 12, 'message': '好的，我会准时参加', 'type': 'source', 'time': '09:22'},
    {'chatId': 12, 'message': '请准备项目报告', 'type': 'destination', 'time': '09:25'},
    {'chatId': 12, 'message': '已经准备好了', 'type': 'source', 'time': '09:30'},
    {'chatId': 12, 'message': '很好，大家辛苦了', 'type': 'destination', 'time': '09:35'},
    {'chatId': 12, 'message': '会议地点在哪里？', 'type': 'source', 'time': '09:40'},
    {'chatId': 12, 'message': '会议室A', 'type': 'destination', 'time': '09:45'},
    {'chatId': 12, 'message': '好的，知道了', 'type': 'source', 'time': '09:50'},
  ];

  // ========================================
  // CHAT SESSIONS CONFIGURATION
  // ========================================
  // These will be automatically updated with the latest message from each chat
  static const List<Map<String, dynamic>> chatSessions = [
    {
      'chatId': 1,
      'lastMessage': '新开的火锅店怎么样？',
      'lastMessageTime': '12:50',
      'unreadCount': 0,
    },
    {
      'chatId': 2,
      'lastMessage': '暂时没有，一切顺利',
      'lastMessageTime': '12:02',
      'unreadCount': 1,
    },
    {
      'chatId': 3,
      'lastMessage': '好的，有需要随时说',
      'lastMessageTime': '10:50',
      'unreadCount': 0,
    },
    {
      'chatId': 4,
      'lastMessage': '下午3点怎么样？',
      'lastMessageTime': '09:50',
      'unreadCount': 2,
    },
    {
      'chatId': 5,
      'lastMessage': '好的，辛苦了',
      'lastMessageTime': '09:00',
      'unreadCount': 0,
    },
    {
      'chatId': 6,
      'lastMessage': '不客气',
      'lastMessageTime': '08:15',
      'unreadCount': 1,
    },
    {
      'chatId': 7,
      'lastMessage': '应该的',
      'lastMessageTime': '07:00',
      'unreadCount': 0,
    },
    {
      'chatId': 8,
      'lastMessage': '祝你生日快乐！',
      'lastMessageTime': '05:45',
      'unreadCount': 3,
    },
    {
      'chatId': 9,
      'lastMessage': '好的，有需要随时说',
      'lastMessageTime': '04:50',
      'unreadCount': 0,
    },
    {
      'chatId': 10,
      'lastMessage': '界面可以更简洁一些',
      'lastMessageTime': '03:40',
      'unreadCount': 1,
    },
    {
      'chatId': 11,
      'lastMessage': '下个月的目标定了吗？',
      'lastMessageTime': '02:30',
      'unreadCount': 0,
    },
    {
      'chatId': 12,
      'lastMessage': '好的，知道了',
      'lastMessageTime': '09:50',
      'unreadCount': 5,
    },
  ];

  // ========================================
  // CONFIGURATION SETTINGS
  // ========================================
  static const bool enableMockData = true;
  static const bool clearExistingData = true;
  static const bool showDebugLogs = true;
}

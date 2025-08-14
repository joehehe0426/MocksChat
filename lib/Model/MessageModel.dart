class MessageModel {
  String? message;
  String? type;
  String? time;
  String? date; // Date for grouping messages (e.g., "2024-01-15")
  String? attachmentType; // 'image', 'document', 'audio', 'video', 'location', 'contact'
  String? attachmentPath; // Path or data for the attachment
  String? attachmentName; // Display name for the attachment
  
  MessageModel({
    this.message, 
    this.type, 
    this.time, 
    this.date,
    this.attachmentType,
    this.attachmentPath,
    this.attachmentName,
  });
}

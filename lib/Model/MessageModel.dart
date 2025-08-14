class MessageModel {
  String? message;
  String? type;
  String? time;
  String? attachmentType; // 'image', 'document', 'audio', 'video', 'location', 'contact'
  String? attachmentPath; // Path or data for the attachment
  String? attachmentName; // Display name for the attachment
  
  MessageModel({
    this.message, 
    this.type, 
    this.time, 
    this.attachmentType,
    this.attachmentPath,
    this.attachmentName,
  });
}

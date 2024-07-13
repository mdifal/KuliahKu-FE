class MessageModel {
  String sender;
  String type;
  String message;
  String dateTime;
  MessageModel({
    required this.sender,
    required this.message,
    required this.type,
    required this.dateTime,
  });
}

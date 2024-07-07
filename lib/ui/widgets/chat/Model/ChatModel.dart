class ChatModel {
  String id;
  String targetId;
  String name;
  String profilePicture;
  String time;
  String currentMessage;
  String status;
  bool select = false;
  ChatModel({
    required this.id,
    required this.targetId,
    required this.name,
    required this.profilePicture,
    required this.time,
    required this.currentMessage,
    required this.status,
    this.select = false,
  });

  static fromJson(data) {}
}

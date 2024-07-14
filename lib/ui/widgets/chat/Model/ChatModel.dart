class ChatModel {
  String? roomId;
  String targetId;
  String roomName;
  String profilePicture = 'https://via.placeholder.com/150';
  String CMTime;
  String currentMessage;
  bool isGroup = false;
  bool select = false;
  ChatModel({
    this.roomId,
    required this.targetId,
    required this.roomName,
    this.profilePicture = 'https://via.placeholder.com/150',
    required this.CMTime,
    required this.currentMessage,
    this.isGroup = false,
    this.select = false,
  });

  static fromJson(data) {}
}

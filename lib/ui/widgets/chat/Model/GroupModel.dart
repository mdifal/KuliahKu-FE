class GroupModel {
  String idGroup;
  String groupName;
  String profilePicture;
  String currentMessage;
  String time;
  GroupModel({
    required this.idGroup,
    required this.groupName,
    required this.profilePicture,
    required this.currentMessage,
    required this.time,
  });

  static fromJson(data) {}
}

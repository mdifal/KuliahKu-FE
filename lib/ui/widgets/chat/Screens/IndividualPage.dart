import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kuliahku/ui/views/collab_plan/calender.dart';
import 'package:kuliahku/ui/views/history_time_record.dart';
import 'package:kuliahku/ui/views/timer.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:kuliahku/ui/shared/images.dart';
import 'package:kuliahku/ui/widgets/chat/CustomUI/OwnMessageCard.dart';
import 'package:kuliahku/ui/widgets/chat/CustomUI/ReplyCard.dart';
import 'package:kuliahku/ui/widgets/chat/Model/ChatModel.dart';
import 'package:kuliahku/ui/widgets/chat/Model/MessageModel.dart';
import 'package:kuliahku/ui/shared/style.dart';
import 'package:kuliahku/ui/shared/global.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class IndividualPage extends StatefulWidget {
  final ChatModel chatModel;

  IndividualPage({Key? key, required this.chatModel}) : super(key: key);

  @override
  _IndividualPageState createState() => _IndividualPageState();
}

class _IndividualPageState extends State<IndividualPage> {
  bool show = false;
  FocusNode focusNode = FocusNode();
  bool sendButton = false;
  List<MessageModel> messages = <MessageModel>[];
  TextEditingController _controller = TextEditingController();
  ScrollController _scrollController = ScrollController();
  late IO.Socket socket;
  String ListGroupMember = '';
  late List<dynamic> groupMembers = [];

  @override
  void initState() {
    super.initState();
    IdGroup = '${widget.chatModel.roomId}';
    print("ini id chat: ${widget.chatModel.roomId}");

    fetchGroupMembers();

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          show = false;
        });
      }
    });

    connect();
  }

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TimerPage(urlApi: 'http://$ipUrl/groups/${widget.chatModel.roomId}/time-records', urlApiHistory: 'http://$ipUrl/groups/${widget.chatModel.roomId}/time-records/subgroup/$IdSubgroup', urlApiMataKuliah: 'http://$ipUrl/groups/${widget.chatModel.roomId}/schedulesList/subgroups/$IdSubgroup/',)),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CalenderCollabPlanPage(groupId:widget.chatModel.roomId)),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HistoryRecordPage(urlApi:
                        'http://$ipUrl/groups/${widget.chatModel.roomId}/time-records/subgroup/$IdSubgroup')),
        );
        break;
    }
  }

  void connect() async {
    if (widget.chatModel.roomId != null) {
      if (widget.chatModel.isGroup) {
        await fetchInitialGroupMessages();
      } else {
        await fetchInitialPersonalMessages();
      }
    }

    socket = IO.io('http://$ipUrl', <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });

    socket.connect();

    socket.onConnect((_) {
      print("Connected");
      socket.emit("signin", email);
      socket.on("message", (msg) {
        print("Message received: $msg");
        setMessage("destination", msg["content"]);
      });
    });

    socket.onConnectError((data) => print("Connect Error: $data"));

    socket.onDisconnect((_) => print("Disconnected"));

    print(socket.connected);
  }

  Future<void> fetchInitialPersonalMessages() async {
    final response = await http.get(Uri.parse(
        'http://$ipUrl/privateChats/${widget.chatModel.roomId}/chats'));

    if (response.statusCode == 200) {
      final List<dynamic> chatData = json.decode(response.body);
      setState(() {
        for (var data in chatData) {
          print(data);
          MessageModel message = MessageModel(
            sender: data['senderId'],
            type: data['senderId'] == email ? 'source' : 'destination',
            message: data['content'],
            dateTime: data['id'].toString(),
          );

          messages.add(message);
        }
      });

      WidgetsBinding.instance?.addPostFrameCallback((_) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    } else {
      throw Exception('Failed to load chat messages');
    }
  }

  Future<void> fetchInitialGroupMessages() async {
    final response = await http.get(
        Uri.parse('http://$ipUrl/groups/${widget.chatModel.roomId}/chats'));

    if (response.statusCode == 200) {
      final List<dynamic> chatData = json.decode(response.body);
      setState(() {
        for (var data in chatData) {
          print(data);
          MessageModel message = MessageModel(
            sender: data['senderId'],
            type: data['senderId'] == email ? 'source' : 'destination',
            message: data['content'],
            dateTime: data['id'].toString(),
          );
          try {
            DateTime.parse(message.dateTime);
            messages.add(message);
          } catch (e) {
            print("Invalid dateTime format: ${message.dateTime}");
          }
        }
      });

      WidgetsBinding.instance?.addPostFrameCallback((_) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    } else {
      throw Exception('Failed to load chat messages');
    }
  }

  Future<void> fetchGroupMembers() async {
    final response = await http.get(
        Uri.parse('http://$ipUrl/groups/${widget.chatModel.roomId}/member'));

    if (response.statusCode == 200) {
      final List<dynamic> membersGroup = json.decode(response.body);
      print(membersGroup);
      groupMembers = membersGroup;
      setState(() {
        List<String> memberNames = membersGroup
            .where((member) => member.containsKey('fullname'))
            .map((member) => (member['fullname'] as String).split(' ').first)
            .toList();

        if (memberNames.length > 4) {
          memberNames = memberNames.sublist(0, 4);
          memberNames.add('...');
        }

        ListGroupMember = memberNames.join(', ');
      });
      print(ListGroupMember);
    } else {
      throw Exception('Failed to load chat messages');
    }
  }

  void sendMessage(String message) {
    DateTime now = DateTime.now();
    String? target;
    if (widget.chatModel.isGroup) {
      target = widget.chatModel.roomId;
    } else {
      target = widget.chatModel.targetId;
    }
    print("Sending message: $message to $target timestamp: $now");
    setMessage("source", message);
    if (widget.chatModel.isGroup) {
      socket.emit("chat", {
        "senderId": email,
        "content": message,
        "groupId": widget.chatModel.roomId,
        "timestamp": now.toString(),
      });
    } else {
      socket.emit("chat", {
        "senderId": email,
        "targetId": widget.chatModel.targetId,
        "content": message,
        "timestamp": now.toString(),
      });
    }
  }

  void setMessage(String type, String message) {
    DateTime now = DateTime.now();

    MessageModel messageModel = MessageModel(
      sender: email,
      type: type,
      message: message,
      dateTime: now.toString(),
    );

    setState(() {
      messages.add(messageModel);
    });

    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  String getFormattedDate(DateTime date) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = DateTime(now.year, now.month, now.day - 1);
    DateTime dateMessage = DateTime(date.year, date.month, date.day);

    if (dateMessage == today) {
      return "Today";
    } else if (dateMessage == yesterday) {
      return "Yesterday";
    } else {
      return "${date.day}/${date.month}/${date.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softBlue,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          backgroundColor: facebookColor,
          leadingWidth: 70,
          titleSpacing: 0,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.arrow_back,
                  size: 30,
                  color: white,
                ),
                widget.chatModel.profilePicture == ''
                    ? CircleAvatar(
                        radius: 20,
                        backgroundColor: greySoft,
                        child: ClipOval(
                            child: widget.chatModel.isGroup
                                ? SvgPicture.asset(
                                    image_group,
                                    fit: BoxFit.cover,
                                    width: 38,
                                    height: 38,
                                  )
                                : SvgPicture.asset(
                                    image_person,
                                    fit: BoxFit.cover,
                                    width: 38,
                                    height: 38,
                                  )),
                      )
                    : CircleAvatar(
                        radius: 23,
                        backgroundColor: greySoft,
                      ),
              ],
            ),
          ),
          title: InkWell(
              child: Container(
            margin: EdgeInsets.all(6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.chatModel.roomName,
                  style: TextStyle(
                    fontSize: 18.5,
                    color: white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                widget.chatModel.isGroup
                    ? ListGroupMember.isNotEmpty
                        ? Text(
                            ListGroupMember,
                            style: TextStyle(
                              fontSize: 12,
                              color: white.withOpacity(0.8),
                            ),
                          )
                        : SizedBox.shrink()
                    : SizedBox.shrink(),
              ],
            ),
          )),
          actions: widget.chatModel.isGroup
    ? [
        PopupMenuButton<int>(
          icon: Icon(Icons.more_vert, color: white),
          onSelected: (item) => onSelected(context, item),
          itemBuilder: (context) => [
            PopupMenuItem<int>(value: 0, child: Text('Timer')),
            PopupMenuItem<int>(value: 1, child: Text('Collab Plan')),
            PopupMenuItem<int>(value: 2, child: Text('History Time Record')),
          ],
        ),
      ]
    : [],
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Expanded(
              child: groupMembers.isNotEmpty || !widget.chatModel.isGroup?
              ListView.builder(
                shrinkWrap: true,
                controller: _scrollController,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  DateTime currentDate =
                  DateTime.parse(messages[index].dateTime);
                  DateTime? previousDate;
                  if (index > 0) {
                    previousDate = DateTime.parse(messages[index - 1].dateTime);
                  }

                  bool isNewDay = previousDate == null ||
                      currentDate.day != previousDate.day ||
                      currentDate.month != previousDate.month ||
                      currentDate.year != previousDate.year;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isNewDay)
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Center(
                            child: Card(
                              color: facebookColor.withOpacity(0.8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 13),
                                child: Text(
                                  getFormattedDate(currentDate),
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (messages[index].type == "source")
                        OwnMessageCard(
                          message: messages[index].message,
                          time: currentDate.toString().substring(11, 16),
                        )
                      else
                        ReplyCard(
                          sender: widget.chatModel.isGroup ? groupMembers
                              .firstWhere((member) => member['email'] == messages[index].sender)['fullname'] ?? '' : '',
                          message: messages[index].message,
                          time: currentDate.toString().substring(11, 16),
                          isGroup: widget.chatModel.isGroup,
                        ),
                    ],
                  );
                },
              ) : SizedBox.shrink(),
            ),
            Container(
              height: 70,
              child: Row(
                children: [
                  Expanded(
                    child: Card(
                      margin: EdgeInsets.only(left: 2, right: 2, bottom: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextFormField(
                        controller: _controller,
                        focusNode: focusNode,
                        textAlignVertical: TextAlignVertical.center,
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        minLines: 1,
                        onChanged: (value) {
                          setState(() {
                            sendButton = value.trim().isNotEmpty;
                          });
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Type a message",
                          hintStyle: TextStyle(color: greySoft),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),

                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 8,
                      right: 2,
                      left: 2,
                    ),
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: mainColor,
                      child: IconButton(

                        icon: Icon(Icons.send),
                        onPressed: sendButton
                          ? () {
                            sendMessage(
                              _controller.text.trim(),
                            );
                            _controller.clear();
                            setState(() {
                              sendButton = false;
                            });
                          }
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

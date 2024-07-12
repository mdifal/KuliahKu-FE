import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
  List<MessageModel> messages = [];
  TextEditingController _controller = TextEditingController();
  ScrollController _scrollController = ScrollController();
  late IO.Socket socket;

  @override
  void initState() {
    super.initState();
    print("ini id chat: ${widget.chatModel.id}");

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          show = false;
        });
      }
    });

    connect();
  }

  void connect() async {
    // Fetch initial chat messages
    await fetchInitialMessages();

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

  Future<void> fetchInitialMessages() async {
    final response = await http.get(Uri.parse('http://$ipUrl/privateChats/${widget.chatModel.id}/chats'));

    if (response.statusCode == 200) {
      final List<dynamic> chatData = json.decode(response.body);
      setState(() {
        messages = chatData.map((data) => MessageModel(
          sender: data['senderId'],
          type: data['senderId'] == email ? 'source' : 'destination',
          message: data['content'],
          dateTime: data['timestamp'],
        )).toList();
      });

      WidgetsBinding.instance?.addPostFrameCallback((_) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    } else {
      throw Exception('Failed to load chat messages');
    }
  }

  void sendMessage(String message, String targetId) {
    DateTime now = DateTime.now().toLocal();
    print("Sending message: $message to targetId: $targetId timestamp: $now");
    setMessage("source", message);
    // socket.emit("chat", {"senderId": email, "targetId": targetId, "content": message, "timestamp": now});
    socket.emit("chat", {"senderId": email, "targetId": targetId, "content": message});
  }

  void setMessage(String type, String message) {
    DateTime now = DateTime.now().toLocal();

    MessageModel messageModel = MessageModel(
      sender: email,
      type: type,
      message: message,
      dateTime: now.toString(), // Correct substring for HH:mm format
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
    DateTime dateMessage = DateTime(date.year,date.month,date.day);

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
                CircleAvatar(
                  child: SvgPicture.asset(
                    image_person,
                    color: white,
                    height: 36,
                    width: 36,
                  ),
                  radius: 20,
                  backgroundColor: softBlue,
                ),
              ],
            ),
          ),
          title: InkWell(
            onTap: () {},
            child: Container(
              margin: EdgeInsets.all(6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.chatModel.name,
                    style: TextStyle(
                      fontSize: 18.5,
                      color: white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                controller: _scrollController,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  DateTime currentDate = DateTime.parse(messages[index].dateTime);
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
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Card(
                              color: facebookColor.withOpacity(0.8),
                              
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 13),
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
                          message: messages[index].message,
                          time: currentDate.toString().substring(11, 16),
                        ),
                    ],
                  );
                },
              ),
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
                            sendButton = value.isNotEmpty;
                          });
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Type a message",
                          hintStyle: TextStyle(color: greySoft),
                          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.send),
                            onPressed: () {
                              sendMessage(
                                _controller.text,
                                widget.chatModel.targetId,
                              );
                              _controller.clear();
                            },
                          ),
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
                      backgroundColor: greySoft,
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


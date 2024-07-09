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
          type: data['senderId'] == email ? 'source' : 'destination',
          message: data['content'],
          time: data['timestamp'].toString().substring(11, 16),
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
    print("Sending message: $message to targetId: $targetId");
    setMessage("source", message);
    socket.emit("chat", {"senderId": email, "targetId": targetId, "content": message});
  }

  void setMessage(String type, String message) {
    print("ini sampe sini");
    DateTime now = DateTime.now().toLocal();

    print ("ini time: $now");
    MessageModel messageModel = MessageModel(
      type: type,
      message: message,
      time: now.toString().substring(10, 16), // Correct substring for HH:mm format
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

  void addDummyMessages() {
    List<MessageModel> dummyMessages = [
      MessageModel(
        type: "source",
        message: "Hello!",
        time: "10:00",
      ),
      MessageModel(
        type: "destination",
        message: "Hi there!",
        time: "10:01",
      ),
      MessageModel(
        type: "source",
        message: "How are you?",
        time: "10:02",
      ),
      MessageModel(
        type: "destination",
        message: "I'm good, thanks. How about you?",
        time: "10:03",
      ),
      MessageModel(
        type: "source",
        message: "I'm doing well.",
        time: "10:04",
      ),
    ];

    setState(() {
      messages.addAll(dummyMessages);
    });
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
                  if (messages[index].type == "source") {
                    return OwnMessageCard(
                      message: messages[index].message,
                      time: messages[index].time,
                    );
                  } else {
                    return ReplyCard(
                      message: messages[index].message,
                      time: messages[index].time,
                    );
                  }
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


import 'package:flutter/material.dart';
import 'package:kuliahku/ui/widgets/chat/CustomUI/ListChatCard.dart';
import 'package:kuliahku/ui/widgets/chat/Model/ChatModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../shared/global.dart';
import '../shared/style.dart';
import '../widgets/chat/CustomUI/ListGroupCard.dart';
import '../widgets/chat/Model/GroupModel.dart';
import '../widgets/chat/Screens/SelectContact.dart';
import 'make_new_grup.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with SingleTickerProviderStateMixin {
  late List<ChatModel> personalChats = [];
  late List<ChatModel> groupChats = [];
  late List<ChatModel> chat = [];
  late ChatModel sourchat;
  late TabController _controller;
  bool isLoading = true;

  Future<void> fetchChatsData() async {
    try {
      var url = 'http://$ipUrl/users/$email/roomchat';
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> roomChat = json.decode(response.body);
        setState(() {
          for (var data in roomChat) {
            print (data);
            ChatModel chatModel = ChatModel(
              roomId: data['roomId'],
              targetId: data['targetId'] ?? 'nisrinawafa@gmail.com',
              roomName: data['roomName'] ?? 'test chat',
              profilePicture: data['profilePicture'] ?? 'https://via.placeholder.com/150',
              CMTime: data['CMTime'],
              currentMessage: data['currentMessage'],
              isGroup: data['isGroup'],
            );

            if (chatModel.isGroup) {
              groupChats.add(chatModel);
            } else {
              personalChats.add(chatModel);
            }
          }
          personalChats.sort((a, b) => DateTime.parse(b.CMTime).compareTo(DateTime.parse(a.CMTime)));
          groupChats.sort((a, b) => DateTime.parse(b.CMTime).compareTo(DateTime.parse(a.CMTime)));

          isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch chats data');
      }
    } catch (error) {
      print('Error fetching chats data: $error');
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to fetch chats data');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this, initialIndex: 0);
    fetchChatsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(width: 10),
            Text(
              'Chat',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            decoration: BoxDecoration(
              color: mainColor,
              borderRadius: BorderRadius.circular(5),
            ),
            width: 25,
            height: 25,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: Icon(
                    Icons.add,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        if (_controller.index == 0) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SelectContact(),
                            ),
                          );
                        } else if (_controller.index == 1) {
                          print("Create new group");
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const TambahGrupPage()),
                            );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 30),
        ],
        bottom: TabBar(
          controller: _controller,
          indicatorColor: white,
          tabs: [
            Tab(
              text: "PERSONAL CHATS",
            ),
            Tab(
              text: "GROUP",
            ),
          ],
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : TabBarView(
        controller: _controller,
        children: [
          ListView.builder(
            itemCount: personalChats.length,
            itemBuilder: (context, index) => ListChatCard(
              chatModel: personalChats[index],
            ),
          ),
          ListView.builder(
            itemCount: groupChats.length,  // Corrected line
            itemBuilder: (context, index) => ListChatCard(
              chatModel: groupChats[index],
            ),
          ),
        ],
      ),
    );
  }
}

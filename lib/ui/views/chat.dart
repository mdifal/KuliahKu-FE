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
  late List<dynamic> personalchatmodels = [];
  late List<dynamic> groupchatmodels = [];
  late ChatModel sourchat;
  late TabController _controller;
  bool isLoading = false;

  Future<void> fetchChatsData() async {
    try {
      var url = 'http://$ipUrl/users/$email/roomchat';
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final fetchedData = json.decode(response.body);

        setState(() {
          personalchatmodels = (fetchedData['chats'] as List).map((data) => ChatModel.fromJson(data)).toList();
          isLoading = false;  // Data has been fetched, stop loading
        });
      } else {
        throw Exception('Failed to fetch chats data');
      }
    } catch (error) {
      print('Error fetching chats data: $error');
      setState(() {
        isLoading = false;  // Stop loading even if there is an error
      });
      throw Exception('Failed to fetch chats data');
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this, initialIndex: 0);
    // fetchChatsData();
    // Inisialisasi nilai chatmodels dan sourchat di sini
    personalchatmodels = List.generate(
      10,
          (index) => ChatModel(
            id: 'L8uaURaA5UzOFP8R4Y2Y',
            targetId: 'nisrinawafa@gmail.com',
            name: 'Nisrina Wafa',
            currentMessage: 'Hello, this is message $index',
            time: '10:00 AM',
            profilePicture: 'https://via.placeholder.com/150',
            status: "123",
          ),
    );
    groupchatmodels = List.generate(
      10,
          (index) => GroupModel(
        idGroup: 'L8uaURaA5UzOFP8R4Y2Y',
        groupName: 'SDA TEAM',
        currentMessage: 'Hello, this is message $index',
        time: '10:00 AM',
        profilePicture: 'https://via.placeholder.com/150',
      ),
    );
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
            itemCount: personalchatmodels.length,
            itemBuilder: (context, index) => ListChatCard(
              chatModel: personalchatmodels[index],
            ),
          ),
          ListView.builder(
            itemCount: personalchatmodels.length,
            itemBuilder: (context, index) => ListGroupCard(
              groupModel: groupchatmodels[index],
            ),
          ),
        ],
      ),
    );
  }
}

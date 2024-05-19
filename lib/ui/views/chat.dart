import 'package:flutter/material.dart';
import 'package:kuliahku/ui/widgets/chat/CustomUI/CustomCard.dart';
import 'package:kuliahku/ui/widgets/chat/Model/ChatModel.dart';

import '../shared/style.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late List<ChatModel> chatmodels;
  late ChatModel sourchat;

  @override
  void initState() {
    super.initState();
    // Inisialisasi nilai chatmodels dan sourchat di sini
    chatmodels = List.generate(
      10,
          (index) => ChatModel(
        id: index,
        name: 'User $index',
        currentMessage: 'Hello, this is message $index',
        time: '10:00 AM',
        icon: 'https://via.placeholder.com/150',
        isGroup: false,
        status: "123",
      ),
    );
    sourchat = ChatModel(
      id: 23,
      name: 'Sour User',
      currentMessage: 'Hello, this is a sour message',
      time: '11:00 AM',
      icon: 'https://via.placeholder.com/150',
      isGroup: true,
      status: "123",
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
              'Personal Chat',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.group,
              color: white,
            ),
            onPressed: () {

            },
          ),
          SizedBox(width: 8),
        ],
      ),
      body: ListView.builder(
        itemCount: chatmodels.length,
        itemBuilder: (context, index) => CustomCard(
          chatModel: chatmodels[index]
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:kuliahku/ui/widgets/chat/CustomUI/CustomCard.dart';
import 'package:kuliahku/ui/widgets/chat/Model/ChatModel.dart';

import '../shared/style.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with SingleTickerProviderStateMixin {
  late List<ChatModel> chatmodels;
  late ChatModel sourchat;
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 4, vsync: this, initialIndex: 1);
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
              color: white, // Menggunakan Colors.white secara langsung
            ),
            onPressed: () {
              // Aksi ketika tombol ditekan
            },
          ),
          SizedBox(width: 8),
        ],
        bottom: TabBar(
          controller: _controller,
          indicatorColor: white,
          tabs: [
            Tab(
              text: "CHATS",
            ),
            Tab(
              text: "GROUP",
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: [
          ListView.builder(
            itemCount: chatmodels.length,
            itemBuilder: (context, index) => CustomCard(
              chatModel: chatmodels[index],
            ),
          ),
          Center(child: Text("GROUP")), // Placeholder untuk status
        ],
      ),
    );
  }
}

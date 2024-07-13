import 'package:intl/intl.dart';
import 'package:kuliahku/ui/widgets/chat/Model/ChatModel.dart';
import 'package:kuliahku/ui/widgets/chat/Screens/IndividualPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../shared/images.dart';
import '../../../shared/style.dart';

class ListChatCard extends StatelessWidget {
  const ListChatCard({
    Key? key,
    required this.chatModel
  }) : super(key: key);
  final ChatModel chatModel;

  String formatCMTime(String cmTime) {
    DateTime now = DateTime.now();
    DateTime date = DateTime.parse(cmTime);
    Duration difference = now.difference(date);

    if (difference.inDays == 0) {
      // Tampilkan jam jika CMTime hari ini
      return DateFormat('HH:mm').format(date);
    } else if (difference.inDays == 1) {
      // Tampilkan 'Kemarin' jika CMTime adalah 1 hari sebelum hari ini
      return 'Kemarin';
    } else {
      // Tampilkan tanggal jika CMTime lebih dari 1 hari sebelum hari ini
      return DateFormat('dd MMM yyyy').format(date);
    }
  }


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (contex) => IndividualPage(
                      chatModel: chatModel,
                    )));
      },
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 23,
              child: SvgPicture.asset(
                image_person,
                fit: BoxFit.cover,
                width: 35,
                height: 35,
              ),
              backgroundColor: greySoft,
            ),
            title: Text(
              chatModel.roomName,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Row(
              children: [
                Text(
                  chatModel.currentMessage,
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            trailing:
            Text(formatCMTime(chatModel.CMTime)),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20, left: 20),
            child: Divider(
              thickness: 1,
              height: 1,
              color: greySoft.withOpacity( 0.4),
            ),
          ),
        ],
      ),
    );
  }
}

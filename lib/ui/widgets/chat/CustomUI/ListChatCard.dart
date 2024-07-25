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

  String formatedCMTime(String cmTime) {
    DateTime now = DateTime.now();
    DateTime yesterday = now.subtract(Duration(days: 1));
    DateTime date = DateTime.parse(cmTime);

    if (DateFormat('dd/MMM/yyyy').format(date) == DateFormat('dd/MMM/yyyy').format(now)) {
      return DateFormat('HH:mm').format(date);
    } else if (DateFormat('dd/MMM/yyyy').format(date) == DateFormat('dd/MMM/yyyy').format(yesterday)) {
      return 'Kemarin';
    } else {
      return DateFormat('dd/MMM/yyyy').format(date);
    }
  }

  String formatedCurrentMessage(String currentMessage) {
    String message = currentMessage.split('\n')[0];

    if (message.length > 45) {
      message = message.substring(0, 35) + '....';
    }

    return message;
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
            leading: chatModel.profilePicture == ''
                  ? CircleAvatar(
                        radius: 23,
                        backgroundColor: greySoft,
                        child: ClipOval(
                          child: chatModel.isGroup
                          ? SvgPicture.asset(
                            image_group,
                            fit: BoxFit.cover,
                            width: 50,
                            height: 50,
                          )
                              : SvgPicture.asset(
                            image_person,
                            fit: BoxFit.cover,
                            width: 50,
                            height: 50,
                          )
                        ),
                    )
                    : CircleAvatar(
                      radius: 23,
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
                  formatedCurrentMessage(chatModel.currentMessage ?? ''),
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            trailing:
            Text(formatedCMTime(chatModel.CMTime ?? '')),
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

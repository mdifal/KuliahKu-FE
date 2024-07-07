import 'package:kuliahku/ui/widgets/chat/Model/ChatModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../shared/images.dart';
import '../../../shared/style.dart';
import '../Model/ContactModel.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({
    Key? key,
    required this.contact
  }) : super(key: key);
  final ContactModel contact;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 50,
        height: 53,
        child: Stack(
          children: [
            CircleAvatar(
              radius: 23,
              child: SvgPicture.asset(
                image_person,
                fit: BoxFit.cover,
                width: 50,
                height: 50,
              ),
              backgroundColor: Colors.blueGrey[200],
            ),
          ],
        ),
      ),
      title: Text(
        contact.name,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        contact.email,
        style: TextStyle(
          fontSize: 13,
        ),
      ),
    );
  }
}

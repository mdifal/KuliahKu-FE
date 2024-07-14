import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kuliahku/ui/shared/images.dart';
import 'package:kuliahku/ui/shared/style.dart';
import '../Model/ChatModel.dart';
import '../Model/ContactModel.dart';
import '../Screens/IndividualPage.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({
    Key? key,
    required this.contact,
  }) : super(key: key);

  final ContactModel contact;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 3, horizontal: 15), // Add some margin if needed
      padding: EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white, // Set the background color here
        borderRadius: BorderRadius.circular(10), // Add border radius if desired
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => IndividualPage(
                chatModel: ChatModel(
                  targetId: contact.email,
                  roomName: contact.name,
                  profilePicture: contact.icon,
                  currentMessage: '',
                  CMTime: '',
                  isGroup: false,
                ),
              ),
            ),
          );
        },
        leading: CircleAvatar(
          radius: 20,
          backgroundColor: greySoft,
          child: ClipOval(
            child: contact.icon == ''
                ? SvgPicture.asset(
              image_person,
              fit: BoxFit.cover,
              width: 35,
              height: 35,
            )
                : SvgPicture.asset(
              contact.icon,
              fit: BoxFit.cover,
              width: 35,
              height: 35,
            ),
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
      ),
    );
  }
}

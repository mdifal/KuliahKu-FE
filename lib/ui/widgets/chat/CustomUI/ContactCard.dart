import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kuliahku/ui/shared/images.dart';
import 'package:kuliahku/ui/shared/style.dart';
import '../Model/ContactModel.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({
    Key? key,
    required this.contact,
  }) : super(key: key);

  final ContactModel contact;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 23,
        backgroundColor: greySoft,
        child: ClipOval(
          child: contact.icon == ''
              ? SvgPicture.asset(
            image_person,
            fit: BoxFit.cover,
            width: 50,
            height: 50,
          )
              : SvgPicture.asset(
            contact.icon!,
            fit: BoxFit.cover,
            width: 50,
            height: 50,
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
    );
  }
}

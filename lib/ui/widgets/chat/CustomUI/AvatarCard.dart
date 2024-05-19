import 'package:kuliahku/ui/shared/style.dart';
import 'package:kuliahku/ui/widgets/chat/Model/ChatModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AvatarCard extends StatelessWidget {
  const AvatarCard({
    Key? key,
    required this.chatModel
  }) : super(key: key);
  final ChatModel chatModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 23,
                child: SvgPicture.asset(
                  "assets/person.svg",
                  color: white,
                  height: 30,
                  width: 30,
                ),
                backgroundColor: white,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  backgroundColor: grey,
                  radius: 11,
                  child: Icon(
                    Icons.clear,
                    color: white,
                    size: 13,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 2,
          ),
          Text(
            chatModel.name,
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

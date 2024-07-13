import 'package:flutter/material.dart';
import 'package:kuliahku/ui/shared/style.dart';

class ReplyCard extends StatelessWidget {
  const ReplyCard({
    Key? key,
    required this.sender,
    required this.message,
    required this.time,
    required this.isGroup,
  }) : super(key: key);
  final String sender;
  final String message;
  final String time;
  final bool isGroup;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Card(
          elevation: 1,
          color: lighterBlue,
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 8,
                  right: 50,
                  top: 5,
                  bottom: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isGroup)
                      Text(
                        sender,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: darkBlue,
                        ),
                      ),
                    Text(
                      message,
                      style: TextStyle(
                        fontSize: 15,
                        color: black,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 4,
                right: 10,
                child: Text(
                  time,
                  style: TextStyle(
                    fontSize: 9,
                    color: black.withOpacity(0.8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

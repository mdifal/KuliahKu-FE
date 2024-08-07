import 'package:flutter/material.dart';

import '../../../shared/style.dart';

class OwnMessageCard extends StatelessWidget {
  const OwnMessageCard({
    Key? key,
    required this.message,
    required this.time
  }) : super(key: key);
  final String message;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Card(
          elevation: 1,
          // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: white,
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 40,
                  top: 5,
                  bottom: 10,
                ),
                child: Text(
                  message,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              Positioned(
                bottom: 4,
                right: 10,
                child: Row(
                  children: [
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 9,
                        color: black.withOpacity(0.8),
                      ),
                    ),
                    SizedBox(
                      width: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

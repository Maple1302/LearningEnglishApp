import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;

  const MessageBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.only(bottom: 0, top: 8, right: 10, left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(width: 1.5, color: Colors.grey),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.elliptical(20, 30),
                bottomRight: Radius.circular(10),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
            //margin: const EdgeInsets.only(bottom: 20,right: 20),
            child: Column(
              children: [
                const Icon(Icons.voice_chat, color: Colors.blue),
                Text(
                  message,
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w300,
                      fontSize: 20),
                  softWrap: true,
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}

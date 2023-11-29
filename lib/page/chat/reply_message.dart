import 'package:flutter/material.dart';

import '../../model/chat.dart';

class ReplyMessageWisget extends StatelessWidget {
  final Chat chat;
  final VoidCallback? onCancelReply;

  const ReplyMessageWisget({super.key, required this.chat, this.onCancelReply});

  @override
  Widget build(BuildContext context) => IntrinsicHeight(
        child: Row(
          children: [
            Icon(
              Icons.person,
              size: 4,
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(child: buildReplyMessage()),
          ],
        ),
      );
  Widget buildReplyMessage() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${chat.userMall}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              if (onCancelReply != null)
                GestureDetector(
                  child: Icon(
                    Icons.close,
                    size: 16,
                  ),
                  onTap: onCancelReply,
                )
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            chat.messageContent!,
            style: TextStyle(color: Colors.black),
          )
        ],
      );
}

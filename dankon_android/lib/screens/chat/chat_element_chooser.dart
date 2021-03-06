import 'package:dankon/models/chat.dart';
import 'package:dankon/models/message.dart';
import 'package:dankon/services/read_receipt.dart';
import 'package:dankon/utils/timestamp_to_datetime.dart';
import 'package:dankon/widgets/cached_avatar.dart';
import 'package:dankon/widgets/message_bubble.dart';
import 'package:dankon/widgets/overchat/tic_tac_toe/in_chat_element.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dankon/utils/date_only_compare.dart';
import 'package:provider/provider.dart';

class ChatElementChooser extends StatelessWidget {
  const ChatElementChooser(
      {Key? key, required this.message, this.previousMessage, this.nextMessage})
      : super(key: key);

  final Message message;
  final Message? previousMessage;
  final Message? nextMessage;

  @override
  Widget build(BuildContext context) {
    String myUid = context.read<User?>()!.uid;
    Chat chat = context.read<Chat>();

    bool threadTheMessageAbove = previousMessage != null &&
        previousMessage!.author == message.author &&
        message.time.difference(previousMessage!.time).inMinutes < 3;
    bool threadTheMessageBelow = nextMessage != null &&
        nextMessage!.author == message.author &&
        nextMessage!.time.difference(message.time).inMinutes < 3;

    Map<dynamic, dynamic> readReceiptData =
        context.watch<Map<dynamic, dynamic>>();
    ReadReceiptService readReceiptService =
        ReadReceiptService(chat: chat, uid: myUid);

    Widget chooseChatElement() {
      if (message.type == "TEXT_MESSAGE") {
        return MessageBuble(
          msg: message,
          byMe: message.author == myUid,
          isThereMessageBefore: threadTheMessageAbove,
          isThereMessageAfter: threadTheMessageBelow,
        );
      }

      if (message.type == "TIC_TAC_TOE/DEFAULT") {
        return TicTacToeInChatElement(
          message: message,
          chat: chat,
          byMe: message.author == myUid,
          isThereMessageBefore: threadTheMessageAbove,
          isThereMessageAfter: threadTheMessageBelow,
        );
      }

      return const Text(
        "Unsupported chat element.\nPlease update the app.",
        style: TextStyle(color: Colors.red),
        textAlign: TextAlign.center,
      );
    }

    return Padding(
      padding: EdgeInsets.only(top: threadTheMessageAbove ? 2 : 30),
      child: Column(children: [
        TimeDivider(
          messageTime: message.time,
          previousMessageTime:
              previousMessage != null ? previousMessage!.time : null,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: chooseChatElement(),
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: chat
                .getListOfAvatarsFromUids(
                    readReceiptService.getUidsToShowReadReceipt(
                        message.time,
                        nextMessage != null ? nextMessage!.time : null,
                        readReceiptData),
                    excludedUid: myUid)
                .map((e) => Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: CachedAvatar(
                        url: e,
                        radius: 10,
                      ),
                    ))
                .toList())
      ]),
    );
  }
}

class TimeDivider extends StatelessWidget {
  const TimeDivider(
      {Key? key, this.previousMessageTime, required this.messageTime})
      : super(key: key);
  final DateTime? previousMessageTime;
  final DateTime messageTime;

  @override
  Widget build(BuildContext context) {
    if (previousMessageTime == null ||
        !previousMessageTime!.isTheSameDate(messageTime) &&
            messageTime != placeholderDateTime) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Text(DateFormat('EEEE, MMM d').format(messageTime)),
      );
    } else {
      return Container();
    }
  }
}

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:socket_io_chat_flutter/repository/api_urls.dart';
import 'package:socket_io_chat_flutter/repository/data_model/user_friends_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatScreen extends StatefulWidget {
  final UserFriendsModel? userModel;

  const ChatScreen({Key? key, this.userModel}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late TextEditingController _textEditingController;
  List<Map<String, dynamic>> fetchListOfMessages = [
    {
      'message': 'Hello! this my practice chat',
      'sender': 24,
      'date_time': DateTime.now()
    }
  ];

  late ScrollController controller;
  final WebSocketChannel channel = WebSocketChannel.connect(Uri.parse(
      '${ApiUrls.socketUrl}ws/chat/03002796822/?token=5199c0a5c2b9da8fc57b8d816171b46d13c297ce'));
  late StreamController streamController;
  late DateTime previousDate;
  bool isNextDate = false;

  @override
  void initState() {
    streamController = StreamController<bool>.broadcast();
    controller = ScrollController();
    previousDate = fetchListOfMessages[0]['date_time'];

    //chatInit();
    _textEditingController = TextEditingController();
    print('............stream.........Befor}');
    channel.stream.listen(
      (data) {
        var mapData = jsonDecode(data);

        setState(() {
          fetchListOfMessages.add(mapData);
        });

        print('.............Data......$fetchListOfMessages');
      },
      onError: (error) => print('................error.$error'),
    );
    super.initState();
  }

  Widget _buildSeparator(DateTime date) {
    previousDate = date;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.center,
      child: Text(
        '${date.toString().substring(0, 11)}',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void sendMessage({required String message}) {
    fetchListOfMessages.add({
      'message': message,
      'date_time': DateTime.now().subtract(Duration(days: 7)),
      'sender': 24
    });
    setState(() {
      print(fetchListOfMessages);
      controller.animateTo(controller.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200), curve: Curves.elasticIn);
    });
    // print('...............sendMessage Message....');
    // channel?.sink.add(
    //   jsonEncode(
    //     {
    //       "message": message,
    //     },
    //   ),
    // );
  }

  Future<void> closeChannel() async {
    await Future.delayed(const Duration(seconds: 10));
    channel?.sink.close();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    fetchListOfMessages.reversed.toList();
    print('....const ......Build...................');
    return Scaffold(
      appBar: AppBar(
        title: const Text('{widget.userModel.chatName}'),
      ),
      body: bodyContent(context),
    );
  }

  Widget bodyContent(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 12.0, bottom: 12),
            child: ListView.separated(
                itemCount: fetchListOfMessages.length,
                controller: controller,
                //reverse: true,
                separatorBuilder: (BuildContext context, int index) {
                  var isNextDate = previousDate
                      .toString()
                      .substring(0, 10)
                      .compareTo(fetchListOfMessages[index]['date_time']
                          .toString()
                          .substring(0, 10));
                  // isNextDate = previousDate
                  //     .toString()
                  //     .compareTo(fetchListOfMessages[index]['date_time']);
                  return isNextDate == 0
                      ? const SizedBox()
                      : _buildSeparator(
                          fetchListOfMessages[index]['date_time']);
                },
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Column(
                      crossAxisAlignment:
                          fetchListOfMessages[index]['sender'] == 24
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                      children: [
                        _buildSeparator(previousDate),
                        ChatBubble(
                            message: fetchListOfMessages[index]['message'],
                            time:
                                '${previousDate.hour} : ${previousDate.minute}',
                            isMe: fetchListOfMessages[index]['sender'] == 24),
                      ],
                    );
                  } else {
                    return ChatBubble(
                        message: fetchListOfMessages[index]['message'],
                        time: '${previousDate.hour} : ${previousDate.minute}',
                        isMe: fetchListOfMessages[index]['sender'] == 24);
                  }

                  // userMessageWidget(
                  //   time: fetchListOfMessages[index]['date_time'],
                  //   context: context,
                  //   msg: fetchListOfMessages[index]['message'],
                  //   alignment: Alignment.centerRight,
                  //   color: Colors.blue);
                  // userMessageWidget(
                  //   time: fetchListOfMessages[index]['date_time'],
                  //   context: context,
                  //   msg: fetchListOfMessages[index]['message'],
                  //   alignment: Alignment.centerLeft,
                  //   color: Colors.green);
                }),
          ),
        ),
        inputFieldBar(),
      ],
    );
  }

  Widget inputFieldBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
      child: Container(
        color: Colors.white,
        child: Row(
          children: [
            Flexible(
              flex: 9,
              child: TextField(
                autofocus: true,
                minLines: 1,
                maxLines: 10,
                decoration: const InputDecoration(
                    hintText: 'Type message...',
                    enabled: true,
                    border: OutlineInputBorder()),
                controller: _textEditingController,
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  sendMessage(message: _textEditingController.text);
                  setState(() {});
                  _textEditingController.clear();
                },
                child: const Icon(
                  Icons.send,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget userMessageWidget(
      {required BuildContext context,
      required String msg,
      required String time,
      required AlignmentGeometry alignment,
      required Color color}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: alignment,
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: color, borderRadius: BorderRadius.circular(5)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  alignment: WrapAlignment.start,
                  direction: Axis.vertical,
                  children: [
                    Text(
                      msg,
                      style: const TextStyle(color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 10,
                      textAlign: TextAlign.start,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        time,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final String time;
  final bool isMe;

  const ChatBubble(
      {super.key,
      required this.message,
      required this.time,
      required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(left: isMe ? 80.0 : 8.0, right: isMe ? 8.0 : 80.0),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              decoration: BoxDecoration(
                  color: isMe ? Colors.lightBlueAccent : Colors.grey[200],
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
                message,
                style: TextStyle(
                    color: isMe ? Colors.white : Colors.black54, fontSize: 15),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, right: 4, left: 4),
              child: Text(
                time,
                style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}

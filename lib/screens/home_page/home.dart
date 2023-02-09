import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_chat_flutter/repository/data_client/user_client.dart';
import 'package:socket_io_chat_flutter/repository/data_model/user_friends_model.dart';

import '../chat/chat_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late UserClient _userClient;

  @override
  void initState() {
    _userClient = Provider.of<UserClient>(context, listen: false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios)),
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: usersWidget(),
    );
  }

  Widget usersWidget() {
    return FutureBuilder<List<UserFriendsModel>?>(
      future: _userClient.getFriends(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data?.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(2.0),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ChatScreen(userModel: snapshot.data![index]),
                        ));
                  },
                  style: ListTileStyle.drawer,
                  tileColor: Colors.white.withOpacity(0.5),
                  leading: CircleAvatar(
                    child: Text('${index + 1}'),
                  ),
                  title: Text('${snapshot.data?[index].firstName}'),
                  subtitle: Text('${snapshot.data?[index].lastSeen}'),
                  trailing: Text('${snapshot.data?[index].status}'),
                ),
              );
            },
          );
        } else {
          const Center(
            child: Text('Something went wrong!'),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

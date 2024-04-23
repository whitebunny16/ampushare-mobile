import 'package:ampushare/data/models/buddy/buddy_follow_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class UserChatPage extends HookWidget {
  final BuddyPartialModel user;

  const UserChatPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final messageController = useTextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('${user.firstName} ${user.lastName}'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: 6, // replace with your list of messages
              itemBuilder: (context, index) {
                // replace with your message widget
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user.profilePic),
                  ),
                  title: Text('Message ${index + 1}'),
                  subtitle: const Text('This is a sample message'),
                );
              },
            ),
          ),
          Material(
            elevation: 12.0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: const InputDecoration(
                        hintText: 'Type a message',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      // handle send button press
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

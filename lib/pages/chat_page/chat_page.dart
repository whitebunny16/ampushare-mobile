import 'dart:async';
import 'dart:convert';

import 'package:ampushare/data/models/auth_model/auth_model.dart';
import 'package:ampushare/data/models/buddy/buddy_follow_model.dart';
import 'package:ampushare/pages/chat_page/user_chat_page.dart';
import 'package:ampushare/services/dio_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatPage extends HookWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = useState<int>(0);

    void getProfile() async {
      final prefs = await SharedPreferences.getInstance();
      final authModelString = prefs.getString('authModel');
      AuthModel authModel = authModelFromJson(authModelString!);
      userId.value = authModel.user.id;
    }

    useEffect(() {
      getProfile();
    }, []);

    Future<List<BuddyPartialModel>> fetchBuddies() async {
      var dio = await DioHelper.getDio();
      final followingResponse =
          await dio.get('/api/user/${userId.value}/following');
      return buddyFollowModelFromJson(jsonEncode(followingResponse.data))
          .map((item) => item.following)
          .toList();
    }

    final followersFuture = useMemoized(fetchBuddies);

    final snapshot = useFuture(followersFuture);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Page'),
      ),
      body: snapshot.connectionState == ConnectionState.waiting
          ? const Center(child: CircularProgressIndicator())
          : snapshot.hasError
              ? Center(child: Text('${snapshot.error}'))
              : ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    var buddy = snapshot.data?[index];

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            '${dotenv.get('API_HOST')}${buddy?.profilePic}' ??
                                ''),
                      ),
                      title: Text(buddy!.username),
                      subtitle: Text('${buddy.firstName} ${buddy.lastName}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserChatPage(user: buddy),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}

import 'dart:convert';

import 'package:ampushare/data/models/auth_model/auth_model.dart';
import 'package:ampushare/data/models/buddy/buddy_follow_model.dart';
import 'package:ampushare/pages/user_profile_page/user_profile_page.dart';
import 'package:ampushare/services/dio_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BuddyViewPage extends HookWidget {
  const BuddyViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = useState<int>(0);

    final followers = useState<List<BuddyPartialModel>>([]);
    final following = useState<List<BuddyPartialModel>>([]);

    void getProfile() async {
      final prefs = await SharedPreferences.getInstance();
      final authModelString = prefs.getString('authModel');
      AuthModel authModel = authModelFromJson(authModelString!);
      userId.value = authModel.user.id;
    }

    void fetchBuddies() async {
      var dio = await DioHelper.getDio();
      final followersResponse =
          await dio.get('/api/user/${userId.value}/followers');
      final followingResponse =
          await dio.get('/api/user/${userId.value}/following');
      followers.value =
          buddyFollowModelFromJson(jsonEncode(followersResponse.data))
              .map((item) => item.follower)
              .toList();
      following.value =
          buddyFollowModelFromJson(jsonEncode(followingResponse.data))
              .map((item) => item.following)
              .toList();
    }

    useEffect(() {
      getProfile();
      fetchBuddies();
    }, []);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('View Buddies'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Followers'),
              Tab(text: 'Following'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTabContent(context, followers.value),
            _buildTabContent(context, following.value),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(
      BuildContext context, List<BuddyPartialModel> buddies) {
    return ListView.builder(
      itemCount: buddies.length,
      itemBuilder: (context, index) {
        final buddy = buddies[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage:
                NetworkImage('${dotenv.get('API_HOST')}${buddy.profilePic}'),
          ),
          title: Text('${buddy.firstName} ${buddy.lastName}'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserProfilePage(username: buddy.username),
              ),
            );
          },
        );
      },
    );
  }
}

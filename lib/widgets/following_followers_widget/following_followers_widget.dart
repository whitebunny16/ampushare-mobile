import 'dart:convert';

import 'package:ampushare/data/models/buddy/buddy_follow_model.dart';
import 'package:ampushare/pages/user_profile_page/user_profile_page.dart';
import 'package:ampushare/services/dio_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class FollowingFollowersWidget extends HookWidget {
  final int userId;

  const FollowingFollowersWidget({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final followers = useState<List<BuddyPartialModel>>([]);
    final following = useState<List<BuddyPartialModel>>([]);

    void fetchBuddies() async {
      var dio = await DioHelper.getDio();
      final followersResponse = await dio.get('/api/user/$userId/followers');
      final followingResponse = await dio.get('/api/user/$userId/following');
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
      fetchBuddies();
    }, []);

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'Followers'),
              Tab(text: 'Following'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildTabContent(context, followers.value),
                _buildTabContent(context, following.value),
              ],
            ),
          ),
        ],
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

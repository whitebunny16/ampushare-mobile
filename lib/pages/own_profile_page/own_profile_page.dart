import 'dart:convert';

import 'package:ampushare/data/models/profile/user_profile_model.dart';
import 'package:ampushare/services/dio_helper.dart';
import 'package:ampushare/widgets/following_followers_widget/following_followers_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class OwnProfilePage extends HookWidget {
  const OwnProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProfile = useState<UserProfileModel?>(null);

    useEffect(() {
      void fetchUserProfile() async {
        var dio = await DioHelper.getDio();
        final response = await dio.get('/api/user/profile');
        userProfile.value = userProfileModelFromJson(jsonEncode(response.data));
      }

      fetchUserProfile();
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: userProfile.value == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
            children: [
              ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: <Widget>[
                            CircleAvatar(
                              radius: 75,
                              backgroundImage: NetworkImage(
                                  '${dotenv.get('API_HOST')}${userProfile.value?.profilePic}' ??
                                      ''),
                            ),
                            const SizedBox(height: 16),
                            Text(
                                'Name: ${userProfile.value?.firstName} ${userProfile.value?.lastName}',
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500)),
                            const SizedBox(height: 10),
                            Text('Username: ${userProfile.value?.username}',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500)),
                            const SizedBox(height: 10),
                            Text('Email: ${userProfile.value?.email}'),
                            const SizedBox(height: 10),
                            Text(
                                'Gender: ${userProfile.value?.gender == "F" ? "Female" : userProfile.value?.gender == "M" ? "Male" : "Others"}'),
                            const SizedBox(height: 10),
                            Text(
                                'Date of Birth: ${userProfile.value?.dateOfBirth.toIso8601String()}'),
                            const SizedBox(height: 10),
                            Text(
                                'Join Date: ${userProfile.value?.createdAt.toIso8601String()}'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              Flexible(
                  fit: FlexFit.tight,
                  child: FollowingFollowersWidget(
                      userId: userProfile.value!.userId))
            ],
          ),
    );
  }
}

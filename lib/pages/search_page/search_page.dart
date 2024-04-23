import 'dart:convert';

import 'package:ampushare/data/models/profile/profile_search_model.dart';
import 'package:ampushare/pages/user_profile_page/user_profile_page.dart';
import 'package:ampushare/services/dio_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SearchPage extends HookWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = useTextEditingController();
    final searchResults = useState<List<ProfileSearchModel>>([]);

    void search(String query) async {
      var dio = await DioHelper.getDio();
      final response = await dio
          .get('/api/user/profiles', queryParameters: {'search': query});
      searchResults.value =
          profileSearchModelFromJson(jsonEncode(response.data));
    }

    void onTapProfile(String username) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => UserProfilePage(username: username),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          onChanged: search,
          decoration: const InputDecoration(
            hintText: 'Search users...',
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: searchResults.value.length,
        itemBuilder: (context, index) {
          print(searchResults.value[index].username);

          var user = searchResults.value[index];

          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage('${dotenv.get('API_HOST')}${user.profilePic}'),
            ),
            title: Text(user.username),
            subtitle: Text('${user.firstName} ${user.lastName}'),
            onTap: () {
              onTapProfile(user.username);
            },
          );
        },
      ),
    );
  }
}

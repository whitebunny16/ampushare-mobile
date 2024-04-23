import 'dart:convert';
import 'dart:developer';

import 'package:ampushare/data/models/auth_model/auth_model.dart';
import 'package:ampushare/data/models/post/post_view_model.dart';
import 'package:ampushare/pages/appointment_booking_page/appointment_booking_page.dart';
import 'package:ampushare/pages/chat_page/chat_page.dart';
import 'package:ampushare/pages/comment_page/comment_page.dart';
import 'package:ampushare/pages/create_post_page/create_post_page.dart';
import 'package:ampushare/pages/search_page/search_page.dart';
import 'package:ampushare/services/dio_helper.dart';
import 'package:ampushare/widgets/profile_drawer/profile_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends HookWidget {
  const HomePage({super.key});

  Future<List<PostViewModel>> fetchPosts() async {
    var dio = await DioHelper.getDio();
    final response = await dio.get('/api/social/posts');
    if (response.statusCode == 200) {
      List<dynamic> responseData = response.data;
      log(responseData.toString());
      List<PostViewModel> posts =
          postViewModelFromJson(jsonEncode(responseData));
      return posts;
    } else {
      throw Exception('Failed to load posts');
    }
  }

  @override
  Widget build(BuildContext context) {
    final refreshKey = useState(0);
    final postsFuture = useMemoized(fetchPosts, [refreshKey.value]);
    final snapshot = useFuture(postsFuture);

    void onCommentButtonPress(int postId) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CommentPage(postId: postId),
        ),
      );
    }

    Future<void> refreshPosts() async {
      refreshKey.value++;
    }

    final profileImage = useState<String>("");

    void getProfileImage() async {
      final prefs = await SharedPreferences.getInstance();
      final authModelString = prefs.getString('authModel');
      log(authModelFromJson(authModelString!).user.profileImage);
      profileImage.value =
          authModelFromJson(authModelString!).user.profileImage;
    }

    useEffect(() {
      getProfileImage();
    }, []);

    void handleLikeButtonPress(int postId, bool isLiked) async {
      var dio = await DioHelper.getDio();

      if (isLiked) {
        // If the post is already liked, send a DELETE request to unlike the post
        try {
          final response = await dio.delete('/api/social/posts/$postId/like');
          if (response.statusCode == 204) {
            Fluttertoast.showToast(
                msg: "Post unliked successfully",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0);
            refreshPosts();
          } else {
            Fluttertoast.showToast(
                msg: "Error unliking post",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        } catch (e) {
          Fluttertoast.showToast(
              msg: "Error unliking post",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      } else {
        // If the post is not liked, send a POST request to like the post
        try {
          final response = await dio.post('/api/social/posts/$postId/like');
          if (response.statusCode == 201) {
            Fluttertoast.showToast(
                msg: "Post liked successfully",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0);
            refreshPosts();
          } else {
            Fluttertoast.showToast(
                msg: "Error liking post",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        } catch (e) {
          Fluttertoast.showToast(
              msg: "Error liking post",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      }
    }

    void onProfileSearchPressed() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SearchPage(),
        ),
      );
    }

    void onAppointmentBookingPressed() {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const AppointmentBookingPage()));
    }

    void onChatPressed() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ChatPage(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 6.0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: CircleAvatar(
              radius: 20.0,
              backgroundImage: NetworkImage(profileImage.value == null ||
                      profileImage.value == ''
                  ? 'https://cdn.iconscout.com/icon/free/png-256/free-user-1895567-1604557.png'
                  : '${profileImage.value}'),
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.chat),
            onPressed: onChatPressed,
          ),
        ],
      ),
      drawer: const ProfileDrawer(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: refreshPosts,
          child: snapshot.connectionState == ConnectionState.waiting
              ? const CircularProgressIndicator()
              : snapshot.hasError
                  ? Center(child: Text('${snapshot.error}'))
                  : ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        var post = snapshot.data?[index];

                        return Card(
                          child: Column(
                            children: <Widget>[
                              // Head
                              ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      '${dotenv.get('API_HOST')}${post?.user.profilePic}' ??
                                          ''),
                                ),
                                title: Text(post?.user.username ?? ''),
                                subtitle: Text(post?.caption ?? ''),
                              ),
                              // Body
                              if (post?.image != null)
                                Image.network(
                                    '${post?.image}' ??
                                        ''),
                              // Footer
                              ButtonBar(
                                alignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(
                                            post?.isLiked ?? false
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: post?.isLiked ?? false
                                                ? Colors.red
                                                : null),
                                        onPressed: () {
                                          handleLikeButtonPress(
                                              post!.id, post.isLiked);
                                        },
                                      ),
                                      Text(post?.likeCount.toString() ?? '0'),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      IconButton(
                                        icon: const Icon(
                                            Icons.mode_comment_rounded),
                                        onPressed: () {
                                          onCommentButtonPress(post!.id);
                                        },
                                      ),
                                      Text(
                                          post?.commentCount.toString() ?? '0'),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreatePostPage(
                onPostCreated: refreshPosts,
              ),
            ),
          );
        },
        tooltip: 'Add Post',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            tooltip: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
            tooltip: 'Find Users',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Appointment',
            tooltip: 'Book Appointment',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              break;
            case 1:
              onProfileSearchPressed();
              break;
            case 2:
              onAppointmentBookingPressed();
              break;
            default:
              break;
          }
        },
      ),
    );
  }
}

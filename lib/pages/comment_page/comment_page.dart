import 'dart:convert';
import 'dart:developer';

import 'package:ampushare/data/models/comment/comment_view_model.dart';
import 'package:ampushare/services/dio_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CommentPage extends HookWidget {
  final int postId;

  const CommentPage({super.key, required this.postId});

  Future<List<CommentViewModel>> fetchComments() async {
    var dio = await DioHelper.getDio();
    final response = await dio.get('/api/social/posts/$postId/comments');
    if (response.statusCode == 200) {
      List<dynamic> responseData = response.data;
      log(responseData.toString());
      List<CommentViewModel> comments =
          commentViewModelFromJson(jsonEncode(responseData));
      return comments;
    } else {
      throw Exception('Failed to load comments');
    }
  }

  @override
  Widget build(BuildContext context) {
    final refreshKey = useState(0);
    final commentsFuture = useMemoized(fetchComments, [refreshKey.value]);
    final snapshot = useFuture(commentsFuture);

    final controller = useTextEditingController();

    Future<void> sendComment(String text) async {
      var dio = await DioHelper.getDio();
      final response = await dio.post(
        '/api/social/posts/$postId/comments',
        data: {
          "text": text,
        },
      );

      if (response.statusCode == 201) {
        controller.clear();
        refreshKey.value++;
      } else {
        throw Exception('Failed to send comment');
      }
    }

    void onSendCommentPressed() {
      if (controller.text.isNotEmpty) {
        sendComment(controller.text);
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Comments'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: snapshot.connectionState == ConnectionState.waiting
                  ? const Center(child: CircularProgressIndicator())
                  : snapshot.hasError
                      ? Center(child: Text('${snapshot.error}'))
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data?.length,
                          itemBuilder: (context, index) {
                            var comment = snapshot.data?[index];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    '${dotenv.get('API_HOST')}${comment!.user.profilePic}'),
                              ),
                              title: Text(comment.user.username),
                              subtitle: Text(comment.text),
                            );
                          },
                        ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: 'Write a comment',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: onSendCommentPressed,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

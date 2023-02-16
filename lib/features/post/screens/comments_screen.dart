import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_v2/core/common/error.dart';
import 'package:reddit_v2/core/common/loader.dart';
import 'package:reddit_v2/core/common/post_card.dart';
import 'package:reddit_v2/features/auth/controller/auth_controller.dart';
import 'package:reddit_v2/features/post/controller/post_controller.dart';
import 'package:reddit_v2/features/post/widgets/comment_card.dart';
import 'package:reddit_v2/models/post_model.dart';
import 'package:reddit_v2/responsiveness/responsiveness.dart';

class CommentsScreen extends ConsumerStatefulWidget {
  final String postId;

  const CommentsScreen({
    Key? key,
    required this.postId,
  }) : super(key: key);

  @override
  ConsumerState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends ConsumerState<CommentsScreen> {
  final commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  void addComment(PostModel post) {
    ref.read(postControllerProvider.notifier).addComment(
        context: context, text: commentController.text.trim(), post: post);

    setState(() {
      commentController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
      ),
      body: ref.watch(getPostByIdProvider(widget.postId)).when(
          data: (data) {
            return Column(children: [
              PostCard(post: data),
              if (!isGuest)
                Responsiveness(
                  child: TextField(
                    onSubmitted: (val) => addComment(data),
                    controller: commentController,
                    decoration: const InputDecoration(
                        hintText: 'What are your thoughts?',
                        filled: true,
                        border: InputBorder.none),
                  ),
                ),
              const SizedBox(
                height: 10,
              ),
              ref.watch(getPostCommentsProvider(widget.postId)).when(
                  data: (data) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          final comment = data[index];
                          return CommentCard(comment: comment);
                        },
                      ),
                    );
                  },
                  error: (error, stackTrace) {
                    print(error);
                    return ErrorText(error: error.toString());
                  },
                  loading: () => const Loader())
            ]);
          },
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader()),
    );
  }
}

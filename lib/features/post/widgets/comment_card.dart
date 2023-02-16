import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_v2/models/comment_model.dart';
import 'package:reddit_v2/responsiveness/responsiveness.dart';

class CommentCard extends ConsumerWidget {
  final CommentModel comment;

  const CommentCard({
    Key? key,
    required this.comment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Responsiveness(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(comment.profilePic),
                  radius: 18,
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'u/${comment.username}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        comment.text,
                      ),
                    ],
                  ),
                )),
              ],
            ),
            Row(
              children: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.reply)),
                const Text('Reply')
              ],
            ),
          ],
        ),
      ),
    );
  }
}

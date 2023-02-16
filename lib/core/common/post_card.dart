import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_v2/core/common/error.dart';
import 'package:reddit_v2/core/common/loader.dart';
import 'package:reddit_v2/core/constants/constants.dart';
import 'package:reddit_v2/features/auth/controller/auth_controller.dart';
import 'package:reddit_v2/features/community/controller/community_controller.dart';
import 'package:reddit_v2/features/post/controller/post_controller.dart';
import 'package:reddit_v2/models/post_model.dart';
import 'package:reddit_v2/responsiveness/responsiveness.dart';
import 'package:reddit_v2/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class PostCard extends ConsumerWidget {
  final PostModel post;

  const PostCard({
    Key? key,
    required this.post,
  }) : super(key: key);

  void deletePost(WidgetRef ref, BuildContext context) async {
    ref.read(postControllerProvider.notifier).deletePost(post, context);
  }

  void upvotePost(
    WidgetRef ref,
  ) async {
    ref.read(postControllerProvider.notifier).upvote(post);
  }

  void downvotePost(
    WidgetRef ref,
  ) async {
    ref.read(postControllerProvider.notifier).downvote(post);
  }

  void awardPost(
    WidgetRef ref,
    String award,
    BuildContext context,
  ) async {
    ref
        .read(postControllerProvider.notifier)
        .awardPost(post: post, award: award, context: context);
  }

  void navigateToUserProfile(BuildContext context) {
    Routemaster.of(context).push('/u/${post.uid}');
  }

  void navigateToCommunity(BuildContext context) {
    Routemaster.of(context).push('/r/${post.communityName}');
  }

  void navigateToComments(BuildContext context) {
    Routemaster.of(context).push('/post/${post.id}/comments');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTypeImage = post.type == 'image';
    final isTypeText = post.type == 'text';
    final isTypeLink = post.type == 'link';
    final currentTheme = ref.watch(themeNotifierProvider);
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;

    return Responsiveness(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: currentTheme.drawerTheme.backgroundColor,
            ),
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (kIsWeb)
                  Column(
                    children: [
                      IconButton(
                          onPressed: isGuest ? () {} : () => upvotePost(ref),
                          icon: Icon(
                            Constants.up,
                            size: 30,
                            color: post.upvotes.contains(user.uid)
                                ? Pallete.blueColor
                                : null,
                          )),
                      Text(
                        '${post.upvotes.length - post.downvotes.length == 0 ? 'Vote' : post.upvotes.length - post.downvotes.length}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      IconButton(
                          onPressed: isGuest ? () {} : () => downvotePost(ref),
                          icon: Icon(
                            Constants.down,
                            size: 30,
                            color: post.downvotes.contains(user.uid)
                                ? Pallete.redColor
                                : null,
                          )),
                    ],
                  ),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 16)
                            .copyWith(right: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () => navigateToCommunity(context),
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            post.communityProfilePic),
                                        radius: 16,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'r/${post.communityName}',
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          GestureDetector(
                                            onTap: () =>
                                                navigateToUserProfile(context),
                                            child: Text(
                                              'u/${post.username}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                if (post.uid == user.uid)
                                  IconButton(
                                      onPressed: () => deletePost(ref, context),
                                      icon: Icon(
                                        Icons.delete,
                                        color: Pallete.redColor,
                                      ))
                              ],
                            ),
                            if (post.awards.isNotEmpty) ...[
                              const SizedBox(
                                height: 15,
                              ),
                              SizedBox(
                                height: 25,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: post.awards.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final award = post.awards[index];
                                    return Image.asset(
                                      Constants.awards[award]!,
                                      height: 25,
                                    );
                                  },
                                ),
                              ),
                            ],
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                post.title,
                                style: const TextStyle(
                                    fontSize: 19, fontWeight: FontWeight.bold),
                              ),
                            ),
                            if (isTypeImage)
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.35,
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Image.network(
                                    post.link!,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            if (isTypeLink)
                              Container(
                                padding: const EdgeInsets.only(
                                    top: 15, left: 15, right: 15),
                                child: AnyLinkPreview(
                                  displayDirection:
                                      UIDirection.uiDirectionHorizontal,
                                  link: post.link!,
                                ),
                              ),
                            if (isTypeText)
                              Container(
                                alignment: Alignment.bottomLeft,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0),
                                  child: Text(
                                    post.description!,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (!kIsWeb)
                                  Row(
                                    children: [
                                      IconButton(
                                          onPressed: isGuest
                                              ? () {}
                                              : () => upvotePost(ref),
                                          icon: Icon(
                                            Constants.up,
                                            size: 30,
                                            color:
                                                post.upvotes.contains(user.uid)
                                                    ? Pallete.blueColor
                                                    : null,
                                          )),
                                      Text(
                                        '${post.upvotes.length - post.downvotes.length == 0 ? 'Vote' : post.upvotes.length - post.downvotes.length}',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      IconButton(
                                          onPressed: isGuest
                                              ? () {}
                                              : () => downvotePost(ref),
                                          icon: Icon(
                                            Constants.down,
                                            size: 30,
                                            color: post.downvotes
                                                    .contains(user.uid)
                                                ? Pallete.redColor
                                                : null,
                                          )),
                                    ],
                                  ),
                                Row(
                                  children: [
                                    IconButton(
                                        onPressed: () =>
                                            navigateToComments(context),
                                        icon: const Icon(Icons.comment)),
                                    GestureDetector(
                                      onTap: () => navigateToComments(context),
                                      child: Text(
                                        '${post.commentCount == 0 ? 'Comment' : post.commentCount}',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                                ref
                                    .watch(getCommunityByNameProvider(
                                        post.communityName))
                                    .when(
                                        data: (data) {
                                          if (data.mods.contains(user.uid)) {
                                            return IconButton(
                                                onPressed: () =>
                                                    deletePost(ref, context),
                                                icon: const Icon(Icons
                                                    .admin_panel_settings));
                                          }
                                          return const SizedBox();
                                        },
                                        error: (error, stackTrace) =>
                                            ErrorText(error: error.toString()),
                                        loading: () => const Loader()),
                                IconButton(
                                  onPressed: isGuest
                                      ? () {}
                                      : () {
                                          showDialog(
                                              context: context,
                                              builder: (context) => Dialog(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20),
                                                      child: GridView.builder(
                                                          shrinkWrap: true,
                                                          gridDelegate:
                                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                                  crossAxisCount:
                                                                      4),
                                                          itemCount: user
                                                              .awards.length,
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int index) {
                                                            final award = user
                                                                .awards[index];
                                                            return GestureDetector(
                                                              onTap: () =>
                                                                  awardPost(
                                                                      ref,
                                                                      award,
                                                                      context),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child: Image.asset(
                                                                    Constants
                                                                            .awards[
                                                                        award]!),
                                                              ),
                                                            );
                                                          }),
                                                    ),
                                                  ));
                                        },
                                  icon:
                                      const Icon(Icons.card_giftcard_outlined),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

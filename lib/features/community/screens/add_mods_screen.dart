import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_v2/core/common/error.dart';
import 'package:reddit_v2/core/common/loader.dart';
import 'package:reddit_v2/features/auth/controller/auth_controller.dart';
import 'package:reddit_v2/features/community/controller/community_controller.dart';

class AddModsScreen extends ConsumerStatefulWidget {
  final String name;

  const AddModsScreen({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  ConsumerState createState() => _AddModsScreenState();
}

class _AddModsScreenState extends ConsumerState<AddModsScreen> {
  Set<String> uidList = {};
  int counter = 0;

  void addUid(String uid) {
    setState(() {
      uidList.add(uid);
    });
  }

  void removeUid(String uid) {
    setState(() {
      uidList.remove(uid);
    });
  }

  void saveMods() {
    ref
        .read(communityControllerProvider.notifier)
        .addMods(widget.name, uidList.toList(), context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () => saveMods(), icon: const Icon(Icons.done))
        ],
      ),
      body: ref.watch(getCommunityByNameProvider(widget.name)).when(
          data: (community) => ListView.builder(
                itemCount: community.members.length,
                itemBuilder: (BuildContext context, int index) {
                  final member = community.members[index];

                  return ref.watch(getUserDataProvider(member)).when(
                        data: (user) {
                          if (community.mods.contains(member) && counter == 0) {
                            uidList.add(member);
                          }

                          counter++;
                          return CheckboxListTile(
                              value: uidList.contains(user.uid),
                              onChanged: (val) {
                                if (val!) {
                                  addUid(user.uid);
                                } else {
                                  removeUid(user.uid);
                                }
                              },
                              title: Text(user.name));
                        },
                        error: (error, stackTrace) =>
                            ErrorText(error: error.toString()),
                        loading: () => const Loader(),
                      );
                },
              ),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader()),
    );
  }
}

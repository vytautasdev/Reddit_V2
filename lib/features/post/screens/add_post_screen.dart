import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_v2/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class AddPostScreen extends ConsumerWidget {
  const AddPostScreen({
    Key? key,
  }) : super(key: key);

  void navigateToType(BuildContext context, String type) {
    Routemaster.of(context).push('/add-post/$type');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var cardSizeHeight = kIsWeb ? 360.0 : 110.0;
    var cardSizeWidth = kIsWeb ? 360.0 : 110.0;
    var iconSize = kIsWeb ? 200.0 : 60.0;
    final currentTheme = ref.watch(themeNotifierProvider);

    return Scaffold(
      body: Padding(
        padding:
            kIsWeb ? const EdgeInsets.all(30.0) : const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => navigateToType(context, 'image'),
              child: SizedBox(
                height: cardSizeHeight,
                width: cardSizeWidth,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: currentTheme.backgroundColor,
                  elevation: 16,
                  child: Center(
                    child: Icon(
                      Icons.image_outlined,
                      size: iconSize,
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => navigateToType(context, 'text'),
              child: SizedBox(
                height: cardSizeHeight,
                width: cardSizeWidth,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: currentTheme.backgroundColor,
                  elevation: 16,
                  child: Center(
                    child: Icon(
                      Icons.font_download_outlined,
                      size: iconSize,
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => navigateToType(context, 'link'),
              child: SizedBox(
                height: cardSizeHeight,
                width: cardSizeWidth,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: currentTheme.backgroundColor,
                  elevation: 16,
                  child: Center(
                    child: Icon(
                      Icons.link_outlined,
                      size: iconSize,
                    ),
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

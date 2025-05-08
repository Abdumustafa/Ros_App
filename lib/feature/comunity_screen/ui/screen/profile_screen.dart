import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:graduation_project/core/helper/spaces.dart';
import 'package:graduation_project/core/services/get_all_posts.dart';
import 'package:graduation_project/feature/comunity_screen/data/models/post_model.dart';
import 'package:graduation_project/feature/comunity_screen/ui/widget/post_community_app.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = "/ProfileScreen";
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<List<PostModel>> futurePosts;

  @override
  void initState() {
    super.initState();
    futurePosts = AllPostsServices().getAllPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        leading: GestureDetector(
            onTap: () => Get.back(),
            child: Icon(Icons.arrow_back_ios_sharp, size: 18)),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: FutureBuilder<List<PostModel>>(
        future: futurePosts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('there was an error '));
          }
          final posts = snapshot.data;
          if (posts == null || posts.isEmpty) {
            return Center(child: Text('No posts available.'));
          }

          final firstUserId = posts.first.user.id;

          final userPosts =
              posts.where((post) => post.user.id == firstUserId).toList();

          if (userPosts.isEmpty) {
            return Center(child: Text('No posts available for this user.'));
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.bottomCenter,
                  clipBehavior: Clip.none,
                  children: [
                    SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: Image.asset(
                        'assets/images/Mask group.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      bottom: -140,
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundImage: NetworkImage(
                                  posts.first.user.profileImage.url,
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: CircleAvatar(
                                  radius: 15,
                                  backgroundColor: Colors.white,
                                  child: IconButton(
                                    icon: Icon(Icons.camera_alt, size: 15),
                                    onPressed: () {},
                                  ),
                                ),
                              ),
                            ],
                          ),
                          verticalSpace(10),
                          Text(
                            posts.first.user.userName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          verticalSpace(10),
                          ElevatedButton(
                            onPressed: () {
                              print('Follow button pressed');
                              Get.toNamed(
                                "/CreatePostScreen",
                              );
                            },
                            child: GestureDetector(
                              onTap: () {
                                print('Add Post button pressed');
                                Get.toNamed(
                                  "/CreatePostScreen",
                                );
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.edit, color: Colors.blueGrey),
                                  SizedBox(width: 5),
                                  Text(
                                    'Add Post',
                                    style: TextStyle(color: Colors.blueGrey),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: IconButton(
                        icon: Icon(Icons.edit, color: Colors.black),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 150),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: userPosts.length,
                  itemBuilder: (context, index) {
                    final post = userPosts[index];
                    return PostCommunityApp(
                      post: post,
                      profileImage: post.user.profileImage.url,
                      profileName: post.user.userName,
                      postDate: '${post.createdAt.day}/${post.createdAt.month}',
                      tag: post.tag,
                      tagColor: Color(0xFFd5dbf5),
                      postText: post.content,
                      postImage:
                          post.media.isNotEmpty ? post.media[0].url : null,
                      likesCount: post.likesCount,
                      commentCount: post.commentCount,
                    );
                  },
                ),
                verticalSpace(30),
              ],
            ),
          );
        },
      ),
    );
  }
}

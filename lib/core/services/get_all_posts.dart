
import 'package:graduation_project/core/helper/api.dart';
import 'package:graduation_project/feature/comunity_screen/data/models/post_model.dart';
import 'package:graduation_project/shared/network/local/cached_data.dart';

class AllPostsServices {

  Future<List<PostModel>> getAllPosts() async {
    print("1");
    Map<String, dynamic> data = await ApiMethod().get(
      url: "https://renalyze-amiras-projects-2023fd67.vercel.app/post/all", token: CachedData.getFromCache("token"),
    );

    List<dynamic> results = data['results']; 
    List<PostModel> postList = [];
     for (int i = 0; i < results.length; i++) {
      final jsonItem = results[i];
      if (jsonItem != null) {
         postList.add(PostModel.fromJson(jsonItem));
      }
    }
    print(postList.length);
    return postList;
  }
}

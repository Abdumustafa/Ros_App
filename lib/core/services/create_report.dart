
import 'package:graduation_project/core/helper/api.dart';
import 'package:graduation_project/feature/comunity_screen/data/models/post_model.dart';

class CreateReportServices {
  Future<PostModel> createPost({
    required String tag,
    required String content,
    String? media,
 }) async {
    Map<String, dynamic> body = {
      'tag': tag,
      'content': content,
      "media": media,
    };

    if (media != null && media.isNotEmpty) {
      body['media'] = media;
    }

    final response = await ApiMethod().post(
      url: "https://renalyze-amiras-projects-2023fd67.vercel.app/post/add",
      body: body,
      token:
          "TOKEN__eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImFtaXJhQGdtYWlsLmNvbSIsImlhdCI6MTc0MTk1MzE4Nn0.IWiPhNrbOsKw8wWjcdojOJj9M7ot_pOwSvAuoyN7anY",
    );

    return PostModel.fromJson(response);
  }
}
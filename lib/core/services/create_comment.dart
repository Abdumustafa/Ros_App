
import 'package:graduation_project/core/helper/api.dart';
import 'package:graduation_project/feature/comunity_screen/data/models/comment_model.dart';

class CreateCommentServices {
  Future<CommentModel> createComment({
    required String content,
    String? media,
    String? imagePath,
  }) async {
    Map<String, dynamic> body = {
      'content': content,
      'media': imagePath ?? (media != null && media.isNotEmpty ? media : []),
    };

    final response = await ApiMethod().post(
      url: "https://renalyze-amiras-projects-2023fd67.vercel.app/post/67a203fe5c138bd0329f5802/comment",
      body: body,
      token: "TOKEN__eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImFtaXJhQGdtYWlsLmNvbSIsImlhdCI6MTc0MTk1MzE4Nn0.IWiPhNrbOsKw8wWjcdojOJj9M7ot_pOwSvAuoyN7anY",
    );
    print("Response: $response");

    if (response != null && response['comment'] != null) {
      return CommentModel.fromJson(response['comment']);
    } else {
      throw Exception("Unexpected response format: $response");
    }
  }
}

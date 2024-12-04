// 2. 뷰모델 만들기
import 'package:flutter_firebase_blog_app_re/data/model/post.dart';
import 'package:flutter_firebase_blog_app_re/data/rerpsitory/post_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. 상태 클래스 만들기
//post 객체를 사용하므로 만들지 않음

// 2. 뷰모델 만들기
class DetailViewModel extends AutoDisposeFamilyNotifier<Post, Post> {
  @override
  Post build(Post arg) {
    return arg;
  }

  Future<bool> deletePost() async {
    final postRepository = PostRepository();
    return await postRepository.delete(arg.id);
  }
}

// 3. 뷰모델 관리자 만들기
final detailViewModelProvider =
    NotifierProvider.autoDispose.family<DetailViewModel, Post, Post>(
  () {
    return DetailViewModel();
  },
);

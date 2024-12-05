import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_firebase_blog_app_re/data/model/post.dart';
import 'package:flutter_firebase_blog_app_re/data/rerpsitory/post_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

// 1. 상태클래스 만들기
class WriteState {
  bool isWriting;
  String? imageUrl;
  WriteState(this.isWriting, this.imageUrl);
}

// 2. 뷰모델 만들기
class WriteViewModel extends AutoDisposeFamilyNotifier<WriteState, Post?> {
  @override
  WriteState build(Post? arg) {
    return WriteState(false, arg?.imageUrl);
  }

  Future<bool> insert({
    required String writer,
    required String title,
    required String content,
  }) async {
    if (state.imageUrl == null) {
      return false;
    }
    final postRepository = PostRepository();

    state = WriteState(true, state.imageUrl);
    if (arg == null) {
      //포스트 객체가 넣이면 새로작성
      final result = await postRepository.insert(
        title: title,
        content: content,
        writer: writer,
        imageUrl: state.imageUrl!,
      );
      await Future.delayed(Duration(milliseconds: 500));
      state = WriteState(false, state.imageUrl);
      return result;
    } else {
      //널이 아니면 수정
      final result = await postRepository.update(
        id: arg!.id,
        title: title,
        content: content,
        writer: writer,
        imageUrl: state.imageUrl!,
      );
      await Future.delayed(Duration(milliseconds: 500));
      state = WriteState(false, state.imageUrl);
      return result;
    }
  }

  void uploadImage(XFile xFile) async {
    try {
      //Firebase Storage 사용법
      // 1. FirebaseStorage 객체 가지고오기
      final storage = FirebaseStorage.instance;
      // 2. 스토리지 참조 만들기
      Reference ref = storage.ref();
      // 3. 파일 참조 만들기
      Reference fileRef =
          ref.child("${DateTime.now().microsecondsSinceEpoch}_${xFile.name}");
      // 4. 쓰기
      await fileRef.putFile(File(xFile.path));
      // 5. 파일에 접근할 수 있는 Url 받기
      String imageUrl = await fileRef.getDownloadURL();
      state = WriteState(state.isWriting, imageUrl);
    } catch (e) {
      print(e);
    }
  }
}

// 3. 뷰모델 관리자 만들기
final WriteViewModelProvider =
    NotifierProvider.autoDispose.family<WriteViewModel, WriteState, Post?>(() {
  return WriteViewModel();
});

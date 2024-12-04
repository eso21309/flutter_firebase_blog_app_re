import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_blog_app_re/data/model/post.dart';

class PostRepository {
  Future<List<Post>?> getAll() //게시물 목록 전체를 가져오므로 List<Post>
  async {
    try {
//1. 파이어스토어 인스턴스 가져오기
      final firestore = FirebaseFirestore.instance;
      //2. 컬렉션 참조 만들기
      final collectionRef = firestore.collection("posts");
      //3. 값 불러오기
      final result = await collectionRef.get();

      final docs = result.docs;
      return docs.map((doc) {
        final map = doc.data();
        final newMap = {
          "id": doc.id,
          ...map,
        };
        return Post.fromJson(newMap);
      }).toList();
    } catch (e) {
      print(e);
      return null;
    }
  }

  /// 1. Create 데이터 쓰기 : 성공 실패만 알면 되므로 bool
  Future<bool> insert({
    required String title,
    required String content,
    required String writer,
    required String imageUrl,
  }) async {
    /// 가져오다가 에러 생길 수 있기 때문에 예외문 꼭 써줘야함
    try {
      // 파이어스토어 인스턴스 가지고 오기
      final firestore = FirebaseFirestore.instance;

      /// 컬렉션 참조 만들기
      final collectionRef = firestore.collection("posts");

      /// 문서 참조 만들기
      final docRef = collectionRef.doc();

      /// 값 쓰기
      await docRef.set({
        "title": title,
        "content": content,
        "writer": writer,
        "imageUrl": imageUrl,
        "createdAt": DateTime.now().toIso8601String(), //파라미터 만들 필요 없음
      });
      return true;
      //var에서 bool로 키워드를 변경해줘서 리턴값에 bool 값을 정해줘야함
      //데이터 잘 가져왔으면 true, 아닌경우에 에러를 뱉어야 하고 그때 false를 쓸거라 변경해준 것임
    } catch (e) {
      print(e);
      return false;
    }
  }

  // 2. Read 특정 ID로 하나의 도큐먼트 가져오기 : 상세보기할 때는 하나의 게시글만 필요해서 Post
  Future<Post?> getOne(String id) async {
    try {
      //파이어스토어 인스턴스
      final firestore = FirebaseFirestore.instance;
      //컬렉션 참조 만들기
      final collectionRef = firestore.collection("posts");
      //문서 참조 만들기
      final docRef = collectionRef.doc(id);
      //데이터 가져오기
      final doc = await docRef.get();
      return Post.fromJson({
        "id": doc.id,
        ...doc.data()!,
      });
    } catch (e) {
      print(e);
      return null;
    }
  }

  // 3. Update 도큐먼트 수정 : 성공 실패만 알면 되므로 bool
  Future<bool> update({
    required String id,
    required String title,
    required String content,
    required String writer,
    required String imageUrl,
  }) async {
    try {
      //파이어스토어 인스턴스
      final firestore = FirebaseFirestore.instance;
      // 컬렉션 참조
      final collectionRef = firestore.collection("posts");
      // 문서 참조
      final docRef = collectionRef.doc(id);
      // 값을 업데이트 해주기 (set > update)
      // 업데이트 할 값 Map 형태로 넣어주기 : id에 해댕하는 문서가 없을때 새로 생성
      // docRef.set(data);
      // 업데이트 할 값 Map 형태로 넣어주기 : id에 해당하는 문서가 없을 때 에러 발생
      await docRef.update({
        "writer": writer,
        "title": title,
        "content": content,
        "imageUrl": imageUrl,
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  // 4. Delete 도큐먼트 삭제 : 성공 실패만 알면 되므로 bool
  Future<bool> delete(String id) async {
    try {
      //파이어 스토어 인스턴스
      final firestore = FirebaseFirestore.instance;
      //컬렉션 참조
      final collectionRef = firestore.collection("posts");
      //문서 참조
      final docRef = collectionRef.doc(id);
      //삭제
      await docRef.delete();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}

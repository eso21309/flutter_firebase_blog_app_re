import 'package:flutter/material.dart';
import 'package:flutter_firebase_blog_app_re/data/model/post.dart';
import 'package:flutter_firebase_blog_app_re/ui/detail/detail_page.dart';
import 'package:flutter_firebase_blog_app_re/ui/home/home_view_model.dart';
import 'package:flutter_firebase_blog_app_re/ui/write/write_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: Text("블로그"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return WritePage(null);
                },
              ),
            );
            if (result == true) {
              ref.read(HomeViewModelProvider.notifier).getAllPosts();
            }
          },
          child: Icon(Icons.edit),
        ),
        body: Padding(
          padding:
              const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "최근글",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 24),
              Consumer(
                //리스트뷰를 Consumer로 감싸고 빌드함수 안에 홈뷰모델 상태 가져오기
                builder: (context, ref, child) {
                  final posts = ref.watch(HomeViewModelProvider);
                  return Expanded(
                    child: ListView.separated(
                      //listview의 separated는 리스트 사이 간격을 한번에 정할 수 있음
                      //listview를 사용한 이유는 스크롤되게 하기 위해서
                      //separated 생성자를 사용하기 위해서 꼭 들어가야 하는 필수 속성 3가지

                      itemCount: posts.length, //10 > 포스트 갯수만큼 가져오게 변경
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 12),
                      //separate 사이에 어떤걸 넣을지 정의 : 마진값 혹은 구분선을 넣음
                      itemBuilder: (context, index) {
                        final post = posts[index];
                        return item(post);
                      },
                    ),
                  );
                },
              )
            ],
          ),
        ));
  }

  Widget item(Post post) {
    //return값의 Container를 GestureDetector로 감싸고
    //ontap Navigator.pusth 입력 > 그다음 GestureDetector를 Builder로 다시 감싸기. //context를 사용하기 위해 필요
    //그다음 타입명을 Widget으로 변경
    //route > MaterialPageRounte로 변경

    //context : 앱의 위치나 상태 정보를 담고 있음. 현재는 홈페이지에 있다는것을 알려줘야함

    return Builder(builder: (context) {
      return GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return DetailPage(post);
            },
          ));
        },
        child: Container(
            width: double.infinity,
            height: 120,
            child: Stack(
              //스텍의 크기가 없으면 자녀 위젯의 크기를 따라간다. 반면에 사이즈가 있으면 자녀위젯이 따라감
              children: [
                //
                Positioned(
                    right: 0,
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      //이미지의 모서리를 둥글게 만들고 싶을 때 ClipRRect으로 감싸기 : Image, Container
                      //이미지 아래에는 적용이 안된다면 부모의 가로세로 사이즈가 없어서 그러함
                      child: Image.network(
                        post.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    )),
                Container(
                  width: double.infinity, //부모길이 따라감
                  height: double.infinity, //부모길이 따라감
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  margin: EdgeInsets.only(right: 100),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Spacer(),
                        Text(
                          post.content,
                          //텍스트 자수 넘어가면 말줄임 처리함
                          overflow: TextOverflow.ellipsis,

                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                            color: Colors.grey[800],
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          post.createdAt.toIso8601String(),
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )),
      );
    });
  }
}

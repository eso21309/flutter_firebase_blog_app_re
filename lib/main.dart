import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_blog_app_re/firebase_options.dart';
import 'package:flutter_firebase_blog_app_re/ui/home/home_page.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //외부 서비스를 사용할 때 반드시 필요한 초기화 단계 : 앱실행전 설정 필요
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //Firebase 서비스를 시작하는 코드
  //Firebase 연결이 오래 걸리므로 async await를 씀

  //1. 터미널에 flutter pub add flutter_riverpod  넣어서 리버팟 설치하기
  //2. const MyApp()를 >>> ProviderScope로 변경하기 : 뷰모델을 리버팟 패키지가 관리할 수 있게 MyApp을 감싸주기
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          //시드컬러 설정 :
          seedColor: Colors.purple, //앱에서 사용될 다른 색상들(버튼 색상, 강조 색상 등)을 자동 생성
          brightness: Brightness.light,
        ),
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: HomePage(),
    );
  }
}

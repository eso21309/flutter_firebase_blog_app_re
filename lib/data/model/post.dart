class Post {
  String id;
  String title;
  String content;
  String writer;
  String imageUrl;
  DateTime createdAt;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.writer,
    required this.imageUrl,
    required this.createdAt,
  });

  ///fromJason
  Post.fromJson(Map<String, dynamic> map)
      : this(
          id: map["id"],
          title: map["title"],
          content: map["content"],
          writer: map["writer"],
          imageUrl: map["imageUrl"],
          createdAt: DateTime.parse(map["createAt"]),
        );

  ///toJason
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "content": content,
      "writer": writer,
      "imageUrl": imageUrl,
      "createdAt": createdAt.toIso8601String(), //날짜와 시간을 국제표준형식으로 바꿔주는 도구
    };
  }
}

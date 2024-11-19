class ImageResp {
  String? createdAt;
  String? alt;
  int? width;
  int? height;
  String? src;

  ImageResp({this.createdAt, this.alt, this.width, this.height, this.src});

  ImageResp.fromJson(Map<String, dynamic> json) {
    createdAt = json['created_at'];
    alt = json['alt'];
    width = json['width'];
    height = json['height'];
    src = json['src'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_at'] = this.createdAt;
    data['alt'] = this.alt;
    data['width'] = this.width;
    data['height'] = this.height;
    data['src'] = this.src;
    return data;
  }
}

class Article {
  int id;
  String title;
  String createdAt;
  String bodyHtml;
  int blogId;
  String author;
  int userId;
  String publishedAt;
  String updatedAt;
  String summaryHtml;
  String templateSuffix;
  String handle;
  String tags;
  String adminGraphqlApiId;
  ImageResp image;

  Article(
      {required this.id,
      required this.title,
      required this.createdAt,
      required this.bodyHtml,
      required this.blogId,
      required this.author,
      required this.userId,
      required this.publishedAt,
      required this.updatedAt,
      required this.summaryHtml,
      required this.templateSuffix,
      required this.handle,
      required this.tags,
      required this.adminGraphqlApiId,
      required this.image});

  factory Article.fromJson(Map<String, dynamic> json) => Article(
        id: json['id'] as int,
        title: json['title'] as String,
        createdAt: json['created_at'] as String,
        bodyHtml: json['body_html'] as String,
        blogId: json['blog_id'] as int,
        author: json['author'] as String,
        userId: json['user_id'] as int,
        publishedAt: json['published_at'] as String,
        updatedAt: json['updated_at'] as String,
        summaryHtml: json['summary_html'] as String,
        templateSuffix: json['template_suffix'] as String,
        handle: json['handle'] as String,
        tags: json['tags'] as String,
        adminGraphqlApiId: json['admin_graphql_api_id'] as String,
        image: ImageResp.fromJson(json['image'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['created_at'] = this.createdAt;
    data['body_html'] = this.bodyHtml;
    data['blog_id'] = this.blogId;
    data['author'] = this.author;
    data['user_id'] = this.userId;
    data['published_at'] = this.publishedAt;
    data['updated_at'] = this.updatedAt;
    data['summary_html'] = this.summaryHtml;
    data['template_suffix'] = this.templateSuffix;
    data['handle'] = this.handle;
    data['tags'] = this.tags;
    data['admin_graphql_api_id'] = this.adminGraphqlApiId;
    if (this.image != null) {
      data['image'] = this.image.toJson();
    }
    return data;
  }
}

import 'dart:convert';
import 'dart:developer';

import 'dart:io';

Post postFromJson(String str) {
  final jsonData = json.decode(str);
  return Post.fromJson(jsonData);
}

String postToJson(Post data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

Future<List<Post>> apiGet() async {
  String url = 'http://34.76.169.182:4000/registeredObject';

  HttpClient client = new HttpClient();
  HttpClientResponse response = await client.getUrl(Uri.parse(url)).then((HttpClientRequest request) {
    request.headers.set('content-type', 'application/json');
    return request.close();
  });
  String reply = await response.transform(utf8.decoder).join();


  var d  = json.decode(reply.trim());
  //List<Post> list = Post.from(d.map((x) => Post.fromJson(x))).;
  log("response from API : " + reply.toString());
  client.close();
  var res = (d as List).map((p) => Post.fromJson(p)).toList();
  log(res[0].name);
  return res;
}

void apiDelete() async {
  String url = 'http://34.76.169.182:4000/registeredObject';

  HttpClient client = new HttpClient();
  HttpClientResponse response = await client.deleteUrl(Uri.parse(url)).then((HttpClientRequest request) {
    request.headers.set('content-type', 'application/json');
    return request.close();
  });
  String reply = await response.transform(utf8.decoder).join();

  log("DATABASE has been deleted API : " + reply.toString());
  client.close();
}

class Post {
  int userId;
  int id;
  String name;
  String code;

  Post({
    this.userId,
    this.id,
    this.name,
    this.code,
  });

  factory Post.fromJson(Map<String, dynamic> json) => new Post(
        userId: json["user_id"],
        id: json["id"],
        name: json["name"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "id": id,
        "name": name,
        "code": code,
      };
}

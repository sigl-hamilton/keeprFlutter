import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'dart:developer';

Future<String> apiPost(String name, String uid) async {
  String url = 'http://34.76.169.182:4000/registeredObject';
  HttpClient httpClient = new HttpClient();
  HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
  request.headers.set('content-type', 'application/json');

  Map jsonMap = {
  'name': name,
  'code': uid,
  'userId' : 2
  };

  request.add(utf8.encode(json.encode(jsonMap)));
  HttpClientResponse response = await request.close();
  // todo - you should check the response.statusCode
  String reply = await response.transform(utf8.decoder).join();
  log("response from API : " + reply);
  httpClient.close();
  return reply;
}





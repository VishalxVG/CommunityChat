import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:fullstack_app/models/comment.dart';
import 'package:fullstack_app/models/community.dart';
import 'package:fullstack_app/services/dummy_data.dart';
import 'package:http/http.dart' as http;
import '../models/post.dart';

class ApiService {
  final String _baseUrl = 'http://10.0.2.2:8000';
  String? _token;

  void setAuthToken(String token) {
    _token = token;
  }

  Future<dynamic> _handleRequest(Future<http.Response> request) async {
    try {
      final response = await request.timeout(const Duration(seconds: 10));
      return _handleResponse(response);
    } on SocketException {
      throw Exception('No Internet connection');
    } on HttpException {
      throw Exception('Could not find the server');
    } on FormatException {
      throw Exception('Bad response format');
    } catch (e) {
      throw Exception('An unknown error occurred: $e');
    }
  }

  dynamic _handleResponse(http.Response response) {
    final dynamic body = json.decode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    } else {
      switch (response.statusCode) {
        case 400:
          throw Exception('Bad request: ${body['detail']}');
        case 401:
          throw Exception('Unauthorized: ${body['detail']}');
        case 403:
          throw Exception('Forbidden: ${body['detail']}');
        case 500:
          throw Exception('Internal server error: ${body['detail']}');
        default:
          throw Exception('Error occurred with code: ${response.statusCode}');
      }
    }
  }

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (_token != null) 'Authorization': 'Bearer $_token',
      };

  // -----------------------------------
  // Login Method
  // -----------------------------------

  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'username': username, 'password': password},
    );
    // Login returns a token, which we handle differently
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      // Re-use your error handler for non-200 responses
      _handleResponse(response);
      // This line will not be reached if _handleResponse throws an exception
      return {};
    }
  }

  // -----------------------------------
  // SignUp Method
  // -----------------------------------

  Future<Map<String, dynamic>> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    return await _handleRequest(http.post(
      Uri.parse('$_baseUrl/signup'),
      headers: _headers,
      body: json.encode({
        'username': username,
        'email': email,
        'password': password,
      }),
    ));
  }

  // -----------------------------------
  // User Details Method
  // -----------------------------------

  Future<Map<String, dynamic>> getMe() async => await _handleRequest(
      http.get(Uri.parse('$_baseUrl/api/users/me'), headers: _headers));

  // -----------------------------------
  //  Home Feed Method
  // -----------------------------------

  Future<List<dynamic>> getFeed() async => await _handleRequest(
      http.get(Uri.parse('$_baseUrl/api/feed'), headers: _headers));

  // -----------------------------------
  //  Communitites Method
  // -----------------------------------

  Future<List<dynamic>> getCommunitites() async =>
      await _handleRequest(http.get(Uri.parse('$_baseUrl/api/communities')));

  Future<dynamic> getCommunityDetails(String commId) async =>
      await _handleRequest(
          http.get(Uri.parse('$_baseUrl/api/communities/$commId')));

  Future<dynamic> joinCommunity(String id) async => await _handleRequest(
        http.post(Uri.parse('$_baseUrl/api/communities/$id/join'),
            headers: _headers),
      );

  Future<dynamic> createCommunity(String name, String description) async =>
      await _handleRequest(http.post(Uri.parse('$_baseUrl/api/communities/'),
          headers: _headers,
          body: json.encode(
            {'name': name, 'description': description},
          )));

  // -----------------------------------
  //  Post Method
  // -----------------------------------

  Future<dynamic> getPostDetails(String postId) async =>
      await _handleRequest(http.get(Uri.parse('$_baseUrl/api/posts/$postId')));

  Future<List<dynamic>> getPostsForCommunity(String commId) async =>
      await _handleRequest(
          http.get(Uri.parse('$_baseUrl/api/communities/$commId/posts')));

  Future<dynamic> createPost(
          String commId, String title, String content) async =>
      await _handleRequest(
          http.post(Uri.parse('$_baseUrl/api/communities/$commId/posts'),
              headers: _headers,
              body: json.encode(
                {'title': title, 'content': content},
              )));

  // -----------------------------------
  //  Post Action Method
  // -----------------------------------

  Future<dynamic> addComment(String postId, String text) async =>
      await _handleRequest(http.post(
        Uri.parse('$_baseUrl/api/posts/$postId/comments'),
        headers: _headers,
        body: json.encode({'content': text}),
      ));

  Future<List<dynamic>> getComments(String postId) async =>
      await _handleRequest(
          http.get(Uri.parse('$_baseUrl/api/posts/$postId/comments')));

  Future<dynamic> voteOnPost(String postId, bool isUpvote) async =>
      await _handleRequest(http.post(
        Uri.parse('$_baseUrl/api/posts/$postId/vote'),
        headers: _headers,
        body: json.encode({
          'vote_type': isUpvote ? 1 : -1,
        }),
      ));

  Future<List<dynamic>> getMyPosts() async => await _handleRequest(
      http.get(Uri.parse('$_baseUrl/api/users/me/posts'), headers: _headers));

//   Future<List<Post>> getHomeFeedPosts() async {
//     await Future.delayed(const Duration(milliseconds: 600));
//     final joinedIds = DummyData.joinedCommunityIds;
//     final feedPosts =
//         DummyData.posts.where((post) => joinedIds.contains(post.id)).toList();
//     feedPosts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
//     return feedPosts;
//   }

//   Future<List<Community>> getCommunities() async {
//     await Future.delayed(const Duration(milliseconds: 500));
//     return DummyData.communities;
//   }

//   Future<Community> getCommunityDetails(String communityId) async {
//     await Future.delayed(const Duration(milliseconds: 300));
//     return DummyData.communities.firstWhere((c) => c.id == communityId);
//   }

//   Future<void> createCommunity(String name, String description) async {
//     await Future.delayed(const Duration(milliseconds: 800));
//     if (kDebugMode) {
//       print('Community "$name" created.');
//     }
//   }

//   Future<List<Post>> getPostsForCommunity(String communityId) async {
//     await Future.delayed(const Duration(milliseconds: 500));
//     return DummyData.posts.where((p) => p.id == communityId).toList();
//   }

//   Future<Post> getPostDetails(String postId) async {
//     await Future.delayed(const Duration(milliseconds: 300));
//     return DummyData.posts.firstWhere((p) => p.id == postId);
//   }

//   Future<List<Comment>> getCommentsForPost(String postId) async {
//     await Future.delayed(const Duration(milliseconds: 400));
//     return DummyData.comments;
//   }

//   Future<void> createPost(
//       String communityId, String title, String? text) async {
//     await Future.delayed(const Duration(milliseconds: 800));
//     if (kDebugMode) {
//       print('Post "$title" created in community $communityId.');
//     }
//   }

//   Future<void> vote(String postId, bool isUpvote) async {
//     await Future.delayed(const Duration(milliseconds: 200));
//     if (kDebugMode) {
//       print('Voted on post $postId');
//     }
//   }
}

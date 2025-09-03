// import 'dart:math';
// import 'package:fullstack_app/models/comment.dart';
// import 'package:fullstack_app/services/dummy_data.dart';

// abstract class ICommentRepository {
//   Future<List<Comment>> getCommentsForPost(String postId);
//   Future<void> addComment({required String postId, required String text});
// }

// class InMemoryCommentRepository implements ICommentRepository {
//   final List<Comment> _comments = List.from(DummyData.comments);

//   @override
//   Future<List<Comment>> getCommentsForPost(String postId) async {
//     // In a real app, you would filter comments by postId
//     await Future.delayed(const Duration(milliseconds: 300));
//     return _comments;
//   }

//   @override
//   Future<void> addComment(
//       {required String postId, required String text}) async {
//     await Future.delayed(const Duration(milliseconds: 400));
//     final newComment = Comment(
//       id: Random().nextInt(10000).toString(),
//       author: 'currentUser', // Hardcoded for now
//       text: text,
//       createdAt: DateTime.now(),
//       upvotes: 1,
//     );
//     _comments.insert(0, newComment);
//   }
// }

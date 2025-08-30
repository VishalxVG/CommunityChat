import 'package:fullstack_app/models/comment.dart';
import 'package:fullstack_app/models/community.dart';
import 'package:fullstack_app/models/post.dart';

class DummyData {
  static final List<String> joinedCommunityIds = [
    '1',
    '3'
  ]; // FlutterDev and Firebase

  static final List<Community> communities = [
    Community(
        id: '1',
        name: 'FlutterDev',
        description: 'All about Flutter!',
        memberCount: 120000,
        imageUrl: 'https://placehold.co/100x100/42A5F5/FFFFFF?text=F'),
    Community(
        id: '2',
        name: 'DartLang',
        description: 'The official Dart language community.',
        memberCount: 75000,
        imageUrl: 'https://placehold.co/100x100/00ACC1/FFFFFF?text=D'),
    Community(
        id: '3',
        name: 'Firebase',
        description: 'Discuss Firebase services and integrations.',
        memberCount: 95000,
        imageUrl: 'https://placehold.co/100x100/FFCA28/000000?text=B'),
    Community(
        id: '4',
        name: 'UIUXDesign',
        description: 'Principles of good design.',
        memberCount: 250000,
        imageUrl: 'https://placehold.co/100x100/EC407A/FFFFFF?text=U'),
  ];

  static final List<Post> posts = [
    Post(
        id: '101',
        communityId: '1',
        communityName: 'FlutterDev',
        author: 'user123',
        title: 'Riverpod 2.0 is amazing!',
        text:
            'Just upgraded my project, and the new syntax is so much cleaner.',
        upvotes: 152,
        commentCount: 12,
        createdAt: DateTime.now().subtract(const Duration(hours: 2))),
    Post(
        id: '301',
        communityId: '3',
        communityName: 'Firebase',
        author: 'userABC',
        title: 'Firestore Security Rules Best Practices',
        text: 'Always start with locked-down rules!',
        upvotes: 412,
        commentCount: 45,
        createdAt: DateTime.now().subtract(const Duration(hours: 3))),
    Post(
        id: '102',
        communityId: '1',
        communityName: 'FlutterDev',
        author: 'user456',
        title: 'How to handle complex animations?',
        imageUrl:
            'https://placehold.co/600x400/E0E0E0/000000?text=Animation+Preview',
        upvotes: 88,
        commentCount: 7,
        createdAt: DateTime.now().subtract(const Duration(hours: 5))),
    Post(
        id: '201',
        communityId: '2',
        communityName: 'DartLang',
        author: 'user789',
        title: 'Dart 3.0 Alpha is out!',
        link: 'https://dart.dev/blog',
        upvotes: 230,
        commentCount: 25,
        createdAt: DateTime.now().subtract(const Duration(days: 1))),
    Post(
        id: '302',
        communityId: '3',
        communityName: 'Firebase',
        author: 'userXYZ',
        title: 'Cloud Functions vs. Local Emulators',
        text: 'The local emulator suite has saved me so much time and money.',
        upvotes: 99,
        commentCount: 18,
        createdAt: DateTime.now().subtract(const Duration(days: 2))),
  ];

  static final List<Comment> comments = [
    Comment(
        id: 'c1',
        author: 'userA',
        text: 'Totally agree, the code generation is a game changer.',
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        upvotes: 15),
    Comment(
        id: 'c2',
        author: 'userB',
        text: 'I had some issues with the migration tool, anyone else?',
        createdAt: DateTime.now().subtract(const Duration(minutes: 25)),
        upvotes: 2),
    Comment(
        id: 'c3',
        author: 'userC',
        text: 'Check out the official docs, they have a guide for it.',
        createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
        upvotes: 8),
  ];
}

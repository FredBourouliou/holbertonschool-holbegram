import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../screens/pages/methods/post_storage.dart';

class Posts extends StatefulWidget {
  const Posts({super.key});

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  Future<void> _toggleSave(String postId) async {
    final userProvider = context.read<UserProvider>();
    final user = userProvider.getUser;
    if (user == null) return;

    final docRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);
    final saved = List<dynamic>.from(user.saved);
    if (saved.contains(postId)) {
      saved.remove(postId);
    } else {
      saved.add(postId);
    }
    await docRef.update({'saved': saved});
    await userProvider.refreshUser();
  }

  Future<void> _toggleLike(String postId, List<dynamic> likes, String uid) async {
    final docRef =
        FirebaseFirestore.instance.collection('posts').doc(postId);
    final newLikes = List<dynamic>.from(likes);
    if (newLikes.contains(uid)) {
      newLikes.remove(uid);
    } else {
      newLikes.add(uid);
    }
    await docRef.update({'likes': newLikes});
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().getUser;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .orderBy('datePublished', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final docs = snapshot.data!.docs;
        if (docs.isEmpty) {
          return const Center(child: Text('No posts yet'));
        }
        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            final postId = data['postId'] as String? ?? '';
            final likes = (data['likes'] as List<dynamic>? ?? []);
            final isLiked = user != null && likes.contains(user.uid);
            final isSaved =
                user != null && user.saved.contains(postId);

            return SingleChildScrollView(
              child: Container(
                margin: EdgeInsetsGeometry.lerp(
                  const EdgeInsets.all(8),
                  const EdgeInsets.all(8),
                  10,
                ),
                height: 540,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(
                                      data['profImage'] as String? ?? ''),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Text(data['username'] as String? ?? ''),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.more_horiz),
                            onPressed: () async {
                              if (user != null && data['uid'] == user.uid) {
                                await PostStorage().deletePost(postId, '');
                              }
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Post Deleted')),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      child: Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 12),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child:
                              Text(data['caption'] as String? ?? ''),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 350,
                      height: 350,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: CachedNetworkImage(
                          imageUrl: data['postUrl'] as String? ?? '',
                          fit: BoxFit.cover,
                          placeholder: (c, u) => Container(
                            color: Colors.grey.shade200,
                          ),
                          errorWidget: (c, u, e) =>
                              const Icon(Icons.broken_image),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              isLiked
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isLiked ? Colors.red : Colors.black,
                            ),
                            onPressed: user == null
                                ? null
                                : () =>
                                    _toggleLike(postId, likes, user.uid),
                          ),
                          IconButton(
                            icon: const Icon(Icons.mode_comment_outlined),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.send_outlined),
                            onPressed: () {},
                          ),
                          const Spacer(),
                          IconButton(
                            icon: Icon(
                              isSaved
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
                            ),
                            onPressed: user == null
                                ? null
                                : () => _toggleSave(postId),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${likes.length} Liked',
                          style: const TextStyle(
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

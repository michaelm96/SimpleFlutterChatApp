import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import './message_bubble.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy(
            'createdAt',
            descending: true,
          )
          .snapshots(),
      builder: (ctx, chatSS) {
        if (chatSS.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final chatDocs = chatSS.data.documents;
        final user = FirebaseAuth.instance.currentUser;
        return ListView.builder(
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (ctx, idx) => MessageBubble(
            chatDocs[idx].data()['text'],
            chatDocs[idx].data()['username'],
            chatDocs[idx].data()['imageUrl'],
            chatDocs[idx].data()['userId'] == user.uid.toString(),
            key: ValueKey(chatDocs[idx].documentID),
          ),
        );
      },
    );
  }
}

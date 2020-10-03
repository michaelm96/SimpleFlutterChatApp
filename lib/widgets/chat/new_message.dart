import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _textController = new TextEditingController();
  var _enteredMsg = '';

  void _sendMsg() async {
    FocusScope.of(context).unfocus();
    final currentUserData = await FirebaseAuth.instance.currentUser;
    final usersData = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserData.uid)
        .get();
    //To read data of current user
    FirebaseFirestore.instance.collection('chat').add({
      'text': _enteredMsg,
      'createdAt': Timestamp.now(),
      'userId': currentUserData.uid,
      'username': usersData.data()['username'],
      'userImage': usersData.data()['imageUrl']
    });
    _textController.clear();
    _enteredMsg = '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      // color: Colors.black,
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: InputDecoration(
                labelText: 'Send a message...',
              ),
              onChanged: (value) {
                setState(() {
                  _enteredMsg = value;
                });
              },
            ),
          ),
          Container(
            width: 50,
            child: MaterialButton(
              child: Icon(
                Icons.send,
                size: 24,
              ),
              splashColor: Colors.amber,
              onPressed: _enteredMsg.trim().isEmpty ? () {} : () => _sendMsg(),
              padding: EdgeInsets.all(16),
              color: Theme.of(context).primaryColor,
              shape: CircleBorder(),
            ),
          ),
        ],
      ),
    );
  }
}

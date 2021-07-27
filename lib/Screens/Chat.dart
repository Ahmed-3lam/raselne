import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Raselne"),
        actions: [
          DropdownButton(
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            items: [
              DropdownMenuItem(child: Container(
                child: Row(
                  children: [
                    Icon(Icons.exit_to_app),
                    SizedBox(width: 8,),
                    Text("Logout")
                  ],
                )
              ),
                value: "logout",

              )
            ],
            onChanged: (itemIdentifier){
              if(itemIdentifier=="logout"){
                FirebaseAuth.instance.signOut();
              }
            },
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("chats/G2BZivB2TVbBEgaf8pxn/messeges")
            .snapshots(),
        builder: (context, streamSnapShot) {
          if (streamSnapShot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.separated(
                itemBuilder: (context, index) => Center(
                    child: Text("${streamSnapShot.data!.docs[index]['text']}")),
                separatorBuilder: (context, index) => Divider(),
                itemCount: streamSnapShot.data!.docs.length);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          FirebaseFirestore.instance
              .collection("chats/G2BZivB2TVbBEgaf8pxn/messeges")
              .add({'text': 'this is added by floating button'});
          // .listen((event) {
          // event.docs.forEach((element) {
          // print(element['text']);
          // });
          // });
        },
      ),
    );
  }
}

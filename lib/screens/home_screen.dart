import 'package:chat_app/Widget/chat_bubble.dart';
import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/helper/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key, required this.email});
  String email;
  String? message;
  DateTime? time;
  String? id;
  @override
  Widget build(BuildContext context) {
    CollectionReference messages =
        FirebaseFirestore.instance.collection(KMessageCollection);
    TextEditingController controller = TextEditingController();
    final ScrollController controller0 = ScrollController();
    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy('createdAt', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Message> messageList = [];
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            messageList.add(Message.fromJson(snapshot.data!.docs[i]));
          }
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Color(secondaryColor),
              title: Text(
                'Chats',
                style: GoogleFonts.aBeeZee(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        reverse: true,
                        controller: controller0,
                        itemCount: messageList.length,
                        itemBuilder: (context, index) {
                          return messageList[index].id == email
                              ? ChatBubble(message: messageList[index])
                              : ChatBubbleForFriend(
                                  message: messageList[index]);
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: TextField(
                      controller: controller,
                      onChanged: (data) {
                        message = data;
                        time = DateTime.now();
                        id = email;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: Color(secondaryColor),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: Color(secondaryColor),
                          ),
                        ),
                        hintText: 'Send Message',
                        suffixIcon: IconButton(
                            onPressed: () {
                              messages.add({
                                'message': message,
                                'createdAt': time,
                                'id': id,
                              });
                              controller.clear();
                              controller0.animateTo(
                                controller0.position.maxScrollExtent,
                                duration: const Duration(seconds: 1),
                                curve: Curves.easeIn,
                              );
                            },
                            icon: const Icon(Icons.send)),
                        suffixIconColor: Color(secondaryColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

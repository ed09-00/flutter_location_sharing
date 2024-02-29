import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../utils/index.dart';
import 'index.dart';

class ChatWidget extends StatefulWidget {
  const ChatWidget({ Key? key, required this.firebaseService, required this.senderName, required this.textEditingController, required this.height, required this.scrollController }) : super(key: key);
  final FirebaseService firebaseService;
  final String senderName;
  final TextEditingController textEditingController;
  final double height;
  final ScrollController scrollController;
  @override
  // ignore: library_private_types_in_public_api
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  
  
  Widget _mainView(BuildContext context){
    final size = MediaQuery.of(context).size;
    final width = size.width;
    
    return Container(
      height: widget.height,
      width: width,
      padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
      decoration: BoxDecoration(
      
      ),
      child: Column(      
        children: [
          Expanded(flex: 7,child: ChatListViewWidget(firebaseService: widget.firebaseService, scrollController: widget.scrollController,)),
          Expanded(flex: 2,child: ChatMsgTextfieldWidget(scrollController:widget.scrollController,firebaseService: widget.firebaseService,senderName:widget.senderName,msgTextFieldController: widget.textEditingController),),
        ],
        
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _mainView(context);
  }
}
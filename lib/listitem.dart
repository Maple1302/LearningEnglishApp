import 'package:flutter/material.dart';

abstract class ListItem {
  Widget buildTitle(BuildContext context);

  
  Widget buildSubTitle(BuildContext context);
}
class HeadingItem implements ListItem{
   final String heading;

  HeadingItem({required this.heading});
  @override
  Widget buildSubTitle(BuildContext context) {
    return Text(
      heading,
      style:Theme.of(context).textTheme.headlineSmall
    );
  }

  @override
  Widget buildTitle(BuildContext context) => const SizedBox.shrink();
  
}
class MessageItem implements ListItem{
  final String sender;
  final String body;

  MessageItem({required this.sender, required this.body});
  
  @override
  Widget buildSubTitle(BuildContext context)=>Text(sender);
  
  @override
  Widget buildTitle(BuildContext context) =>Text(body);
    
}
import 'package:flutter/material.dart';

class NotificationBadge extends StatefulWidget {
  int totalNotifications;
   NotificationBadge({super.key,required this.totalNotifications});

  @override
  State<NotificationBadge> createState() => _NotificationBadgeState();
}

class _NotificationBadgeState extends State<NotificationBadge> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width:40,
      height:40,
      decoration:const BoxDecoration(
        color:Colors.red,
        shape:BoxShape.circle,
      ),
      child:Center(
        child :Padding(
          padding: EdgeInsets.all(8.0),
          child : Text('$widget.totalNotifications')
        )
      )

    );
  }
}
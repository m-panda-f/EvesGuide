import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ArticleCard extends StatefulWidget {
  ArticleCard(
      {super.key, required this.icon, required this.title, required this.desc});

  void navigateToRoute(BuildContext context, Widget route) {
    Navigator.push(context, CupertinoPageRoute(builder: (context) => route));
  }

  IconData icon;
  String title;
  String desc;

  @override
  State<ArticleCard> createState() => _ArticleCardState();
}

class _ArticleCardState extends State<ArticleCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left:20, top:20, bottom: 20, right: 20),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Color(0x006DE6CF),
          border: Border.all(color: Theme.of(context).colorScheme.tertiary, width: 1.5),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(
            widget.icon,
            color: Theme.of(context).colorScheme.secondary,
          ),
          SizedBox(
            width: 220,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.secondary),
                ),
                Text(
                  widget.desc,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(color: Colors.black),
                )
              ],
            ),
          ),
          Icon(
            Icons.arrow_right_alt_rounded,
            color: Theme.of(context).colorScheme.secondary,
          )
        ],
      ),
    );
  }
}

void navigateToRoute(BuildContext context, Widget route) {
  Navigator.push(context, CupertinoPageRoute(builder: (context) => route));
}
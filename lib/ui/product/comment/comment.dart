import 'package:flutter/material.dart';
import 'package:nick/data/comment.dart';

class CommentListItem extends StatelessWidget {
  final CommentEntity comment;
  const CommentListItem({
    super.key, required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: themeData.colorScheme.outline,width: 1)
      ),
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(comment.title,maxLines: 2,),
                    SizedBox(height: 4,),
                    Text(comment.email,style: themeData.textTheme.bodySmall,),
                  ],
                ),
              ),
              Text(comment.date,style: themeData.textTheme.bodySmall,),
            ],
          ),
          SizedBox(height: 16,),
          Text(comment.contect)
        ],
      ),
    );
  }
}
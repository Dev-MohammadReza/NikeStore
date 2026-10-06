import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nick/data/repo/comment_repository.dart';
import 'package:nick/ui/product/comment/insert/bloc/insert_comment_bloc.dart';

class InsertCommentDialog extends StatefulWidget {
  final int productId;
  final ScaffoldMessengerState? scaffoldMessenger;

  const InsertCommentDialog({
    super.key,
    required this.productId,
    required this.scaffoldMessenger,
  });

  @override
  State<InsertCommentDialog> createState() => _InsertCommentDialogState();
}

class _InsertCommentDialogState extends State<InsertCommentDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  StreamSubscription? subscription;

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return BlocProvider<InsertCommentBloc>(
      create: (context) {
        final bloc = InsertCommentBloc(
          commentRepository: commentRepository,
          productId: widget.productId,
        );
        subscription = bloc.stream.listen((state) {
          if (state is InsertCommentSuccess) {
            widget.scaffoldMessenger?.showSnackBar(
              SnackBar(content: Text(state.successMassage)),
            );
            Navigator.of(context, rootNavigator: true).pop();
          } else if (state is InsertCommentError) {
            widget.scaffoldMessenger?.showSnackBar(
              SnackBar(content: Text(state.exception.message)),
            );
            Navigator.of(context, rootNavigator: true).pop();
          }
        });
        return bloc;
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Container(
            height: 265,
            padding: EdgeInsets.all(16),
            child: BlocBuilder<InsertCommentBloc, InsertCommentState>(
              builder: (context, state) {
                return Column(
                  children: [
                    Text('ثبت نظر', style: themeData.textTheme.headlineSmall),
                    SizedBox(height: 20),
                    TextField(
                      style: TextStyle(
                          color: Colors.black
                      ),
                      controller: _titleController,
                      decoration: InputDecoration(label: Text('عنوان')),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      style: TextStyle(
                        color: Colors.black
                      ),
                      controller: _contentController,
                      decoration: InputDecoration(
                        label: Text('متن نظر خود را اینجا وارد کنید'),
                      ),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size.fromHeight(48),
                      ),
                      onPressed: () {
                        context.read<InsertCommentBloc>().add(
                          InsertCommentFormSubmit(
                            title: _titleController.text,
                            content: _contentController.text,
                          ),
                        );
                      },
                      child: state is InsertCommentLoading
                          ? CupertinoActivityIndicator()
                          : Text('ذخیره'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

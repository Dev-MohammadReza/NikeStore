import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nick/data/repo/comment_repository.dart';
import 'package:nick/ui/product/comment/bloc/comment_list_bloc.dart';
import 'package:nick/ui/widgets/error.dart';

import 'comment.dart';

class CommentList extends StatelessWidget {
  final int productId;

  const CommentList({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CommentListBloc>(
      create: (context) {
        final commentBloc = CommentListBloc(
          repository: commentRepository,
          productId: productId,
        );
        commentBloc.add(CommentListStarted());
        return commentBloc;
      },
      child: BlocBuilder<CommentListBloc, CommentListState>(
        builder: (context, state) {
          if (state is CommentListSuccess) {
            return SliverList(
              delegate: SliverChildBuilderDelegate(

                childCount: state.comments.length,

                (context, index) {
                  return CommentListItem(comment: state.comments[index]);
                },
              ),
            );
          } else if (state is CommentListLoading) {
            return SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (state is CommentListError) {
            return SliverToBoxAdapter(
              child: AppErrorWidget(
                exception: state.exception,
                onPressed: () {
                  BlocProvider.of<CommentListBloc>(
                    context,
                  ).add(CommentListRefresh());
                },
              ),
            );
          } else {
            throw Exception('State is not valid or supported');
          }
        },
      ),
    );
  }
}

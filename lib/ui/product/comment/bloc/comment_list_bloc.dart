import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:nick/common/exception.dart';
import 'package:nick/data/comment.dart';
import 'package:nick/data/repo/comment_repository.dart';

part 'comment_list_event.dart';

part 'comment_list_state.dart';

class CommentListBloc extends Bloc<CommentListEvent, CommentListState> {
  final ICommentRepository repository;
  final int productId;

  CommentListBloc({required this.repository, required this.productId})
    : super(CommentListLoading()) {
    on<CommentListEvent>((event, emit) async {
      if (event is CommentListStarted || event is CommentListRefresh) {
        emit(CommentListLoading());
        try {
          final comments = await repository.getAll(productId: productId);
          emit(CommentListSuccess(comments: comments));
        } catch (e) {
          emit(CommentListError(exception: AppException()));
        }
      }
    });
  }
}

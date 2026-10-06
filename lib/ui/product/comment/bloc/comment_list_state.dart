part of 'comment_list_bloc.dart';

@immutable
sealed class CommentListState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class CommentListLoading extends CommentListState {}


class CommentListError extends CommentListState{
  final AppException exception;

  CommentListError({required this.exception});
  @override
  List<Object?> get props => [exception];
}

class CommentListSuccess extends CommentListState{
  final List<CommentEntity> comments;

  CommentListSuccess({required this.comments});
  @override
  List<Object?> get props => [comments];
}





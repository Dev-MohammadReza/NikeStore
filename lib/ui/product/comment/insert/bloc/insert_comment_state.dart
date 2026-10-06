part of 'insert_comment_bloc.dart';

@immutable
sealed class InsertCommentState extends Equatable{
  @override
  List<Object?> get props => [];
}

final class InsertCommentInitial extends InsertCommentState {}



class InsertCommentError extends InsertCommentState{
  final AppException exception;

  InsertCommentError({required this.exception});
  @override
  List<Object?> get props => [exception];
}

class InsertCommentLoading extends InsertCommentState{

}

class InsertCommentSuccess extends InsertCommentState{
  final CommentEntity comment;
  final String successMassage;
  InsertCommentSuccess({required this.comment, required this.successMassage});
  @override
  List<Object?> get props => [comment,successMassage];
}


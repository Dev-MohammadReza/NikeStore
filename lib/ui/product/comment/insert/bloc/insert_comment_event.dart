part of 'insert_comment_bloc.dart';

@immutable
sealed class InsertCommentEvent extends Equatable{
  @override
  List<Object?> get props => [];
}



class InsertCommentFormSubmit extends InsertCommentEvent{
  final String title;
  final String content;

  InsertCommentFormSubmit({required this.title, required this.content});
  @override
  List<Object?> get props => [title,content];
}

part of 'comment_list_bloc.dart';

@immutable
sealed class CommentListEvent {}



class CommentListStarted extends CommentListEvent{

}

class CommentListRefresh extends CommentListEvent{

}






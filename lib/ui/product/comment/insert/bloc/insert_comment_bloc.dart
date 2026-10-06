import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:nick/common/exception.dart';
import 'package:nick/data/comment.dart';
import 'package:equatable/equatable.dart';
import 'package:nick/data/repo/auth_repository.dart';
import 'package:nick/data/repo/comment_repository.dart';

part 'insert_comment_event.dart';

part 'insert_comment_state.dart';

class InsertCommentBloc extends Bloc<InsertCommentEvent, InsertCommentState> {
  final ICommentRepository commentRepository;
  final int productId;

  InsertCommentBloc({required this.commentRepository, required this.productId})
    : super(InsertCommentInitial()) {
    on<InsertCommentEvent>((event, emit) async {
      if (event is InsertCommentFormSubmit) {
        if (!AuthRepository.isUserLogin()) {
          emit(
            InsertCommentError(
              exception: AppException(
                message: 'لطفا وارد حساب کاربری خود شوید',
              ),
            ),
          );
        } else {
          if (event.content.isNotEmpty && event.title.isNotEmpty) {
            try {
              emit(InsertCommentLoading());
              final comment = await commentRepository.insert(
                event.title,
                event.content,
                productId,
              );
              emit(
                InsertCommentSuccess(
                  comment: comment,
                  successMassage:
                      'نظر شما با موفقیت ثبت شد و پس از تایید منتشر خواهد شد.',
                ),
              );
            } catch (e) {
              emit(InsertCommentError(exception: AppException()));
            }
          } else {
            emit(
              InsertCommentError(
                exception: AppException(message: 'لطفا فیلد ها را پر کنید'),
              ),
            );
          }
        }
      }
    });
  }
}

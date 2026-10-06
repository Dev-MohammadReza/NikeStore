import 'package:nick/common/http_client.dart';
import 'package:nick/data/comment.dart';
import 'package:nick/data/source/comment_data_source.dart';

final commentRepository = CommentRepository(
  dataSource: CommentRemoteDataSource(httpClient: httpClient),
);

abstract class ICommentRepository {
  Future<List<CommentEntity>> getAll({required int productId});

  Future<CommentEntity> insert(String title, String content, int productId);
}

class CommentRepository implements ICommentRepository {
  final ICommentDataSource dataSource;

  CommentRepository({required this.dataSource});

  @override
  Future<List<CommentEntity>> getAll({required int productId}) =>
      dataSource.getAll(productId: productId);

  @override
  Future<CommentEntity> insert(String title, String content, int productId) =>
      dataSource.insert(title, content, productId);
}

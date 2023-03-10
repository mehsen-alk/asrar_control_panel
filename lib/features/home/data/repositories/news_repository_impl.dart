import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../../core/app/constants.dart';
import '../../../../core/data/exception_handler.dart';
import '../../../../core/data/failure.dart';
import '../../domain/entities/news_entities.dart';
import '../../domain/repositories/news_repository.dart';

class NewsRepositoryImpl extends NewsRepository {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  Future<int> getLastNewsId() async {
    int id = 0;
    final data = await db.collection(FireBaseCollection.news).get();
    if (data.size > 0) {
      for (var doc in data.docs) {
        if (doc["newsId"] > id) {
          id = doc["newsId"];
        }
      }
    }
    return id;
  }

  @override
  Future<Either<Failure, Unit>> addNews(
    NewsEntities news,
    String newsImageUrl,
  ) async {
    try {
      final int lastNewsId = await getLastNewsId() + 1;
      final Map<String, dynamic> newsEntities = NewsEntities(
        newsId: lastNewsId,
        timestamp: news.timestamp,
        newsTitle: news.newsTitle,
        newsContent: news.newsContent,
        newsImageName: news.newsImageName,
        newsImageUrl: newsImageUrl,
      ).toMap();
      await db
          .collection(FireBaseCollection.news)
          .doc(lastNewsId.toString())
          .set(newsEntities);
      return const Right(unit);
    } catch (e) {
      return Left(ExceptionHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteNews(NewsEntities news) async {
    try {
      await FirebaseStorage.instance
          .ref("${FireBaseCollection.news}/${news.newsImageName}")
          .delete();
      await db
          .collection(FireBaseCollection.news)
          .doc(news.newsId.toString())
          .delete();
      return const Right(unit);
    } catch (e) {
      return Left(ExceptionHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, List<NewsEntities>>> getNewsList() async {
    try {
      List<NewsEntities> newsList = [];
      final news = await db.collection(FireBaseCollection.news).get();
      for (var doc in news.docs) {
        newsList.add(NewsEntities.fromMap(doc.data()));
      }
      newsList.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      return Right(newsList);
    } catch (e) {
      return Left(ExceptionHandler.handle(e).failure);
    }
  }
}

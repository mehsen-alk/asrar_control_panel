part of 'news_bloc.dart';

abstract class NewsState extends Equatable {
  const NewsState();
}

class NewsInitial extends NewsState {
  @override
  List<Object?> get props => [];
}

class NewsLoadingState extends NewsState {
  @override
  List<Object?> get props => [];
}

class DeleteNewsLoadingState extends NewsState {
  @override
  List<Object?> get props => [];
}

class NewsErrorState extends NewsState {
  final String errorMessage;
  const NewsErrorState({required this.errorMessage});
  @override
  List<Object?> get props => [errorMessage];
}

class GetNewsErrorState extends NewsState {
  final String errorMessage;
  const GetNewsErrorState({required this.errorMessage});
  @override
  List<Object?> get props => [errorMessage];
}

class NewsAddedSuccessfullyState extends NewsState {
  @override
  List<Object?> get props => [];
}

class NewsDeletedSuccessfullyState extends NewsState {
  @override
  List<Object?> get props => [];
}

class NewsLoadedState extends NewsState {
  final List<NewsEntities> newsList;
  const NewsLoadedState({required this.newsList});
  @override
  List<Object?> get props => [newsList];
}

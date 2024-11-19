import 'package:Vajro/Model/apiResp.dart';
import 'package:equatable/equatable.dart';

abstract class ApiState extends Equatable {
  const ApiState();

  @override
  List<Object> get props => [];
}

class ApiInitial extends ApiState {}

class ApiLoading extends ApiState {}

class ApiLoaded extends ApiState {
  final List<Article> articles;

  const ApiLoaded({required this.articles});

  @override
  List<Object> get props => [articles];
}

class ApiError extends ApiState {
  final String message;

  const ApiError({required this.message});

  @override
  List<Object> get props => [message];
}

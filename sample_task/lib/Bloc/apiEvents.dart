import 'package:equatable/equatable.dart';

abstract class ApiEvent extends Equatable {
  const ApiEvent();

  @override
  List<Object> get props => [];
}

class FetchData extends ApiEvent {
  final int page;
  final int pageSize;

  const FetchData({required this.page, required this.pageSize});

  @override
  List<Object> get props => [page, pageSize];
}

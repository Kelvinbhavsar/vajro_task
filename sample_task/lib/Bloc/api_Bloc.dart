import 'package:Vajro/Bloc/apiEvents.dart';
import 'package:Vajro/Bloc/apiState.dart';
import 'package:bloc/bloc.dart';

import '../HttpReq/api_call.dart';

class ApiBloc extends Bloc<ApiEvent, ApiState> {
  ApiBloc() : super(ApiInitial()) {
    on<FetchData>(_onFetchData);
  }

  void _onFetchData(FetchData event, Emitter<ApiState> emit) async {
    if (event.page == 1) {
      emit(ApiLoading());
    }

    try {
      final articles =
          await ApiRepository().fetchData(event.page, event.pageSize);
      emit(ApiLoaded(articles: articles));
    } catch (e) {
      emit(ApiError(message: e.toString()));
    }
  }
}

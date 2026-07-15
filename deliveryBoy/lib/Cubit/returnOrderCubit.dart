import 'package:deliveryboy_multivendor/Model/ReturnOrderModel.dart';
import 'package:deliveryboy_multivendor/Repository/returnOrderRepositry.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FetchReturnOrderState {}

class FetchReturnOrderInitial extends FetchReturnOrderState {}

class FetchReturnOrderInProgress extends FetchReturnOrderState {}

class FetchReturnOrderSuccess extends FetchReturnOrderState {
  final ReturnOrderResult result;
  final bool loadingMore;
  final bool loadingMoreError;

  // final String? activeStatus;

  FetchReturnOrderSuccess(
      {required this.result,
      required this.loadingMore,
      required this.loadingMoreError});

  FetchReturnOrderSuccess copyWith(
      {ReturnOrderResult? result, bool? loadingMore, bool? loadingMoreError}) {
    return FetchReturnOrderSuccess(
      result: result ?? this.result,
      loadingMore: loadingMore ?? this.loadingMore,
      loadingMoreError: loadingMoreError ?? this.loadingMoreError,
    );
  }
}

class FetchReturnOrderFail<T> extends FetchReturnOrderState {
  T error;
  FetchReturnOrderFail(this.error);
}

class FetchReturnOrderCubit extends Cubit<FetchReturnOrderState> {
  final ReturnOrdersRepository _returnOrdersRepository;
  FetchReturnOrderCubit(this._returnOrdersRepository)
      : super(FetchReturnOrderInitial());

  Future<void> fetchReturnOrders({
    bool isScrollTriggered = false,
  }) async {
    try {
      if (state is FetchReturnOrderInProgress) {
        return;
      }
      if (state is FetchReturnOrderSuccess && isScrollTriggered) {
        _fetchMore(successState: state as FetchReturnOrderSuccess);
      } else {
        emit(FetchReturnOrderInProgress());
        ReturnOrderResult result =
            await _returnOrdersRepository.fetchOrders(offset: '0');

        emit(FetchReturnOrderSuccess(
            result: result, loadingMore: false, loadingMoreError: false));
      }
    } catch (e) {
      emit(FetchReturnOrderFail(e));
    }
  }

  Future<void> _fetchMore({
    required FetchReturnOrderSuccess successState,
  }) async {
    try {
      if (int.parse(successState.result.total) <=
          successState.result.orders.length) {
        return;
      }
      if (successState.loadingMore) {
        return;
      }
      emit(successState.copyWith(loadingMore: true));
      ReturnOrderResult result = await _returnOrdersRepository.fetchOrders(
          offset: successState.result.orders.length.toString());
      emit(FetchReturnOrderSuccess(
          result: result..orders.insertAll(0, successState.result.orders),
          loadingMore: false,
          loadingMoreError: false));
    } catch (e) {
      emit(successState.copyWith(
          result: successState.result,
          loadingMore: false,
          loadingMoreError: true));
    }
  }

  void updateOrder(ReturnOrderModel order) {
    if (state is FetchReturnOrderSuccess) {
      final stateAs = state as FetchReturnOrderSuccess;
      List<ReturnOrderModel> orders = stateAs.result.orders;
      for (int i = 0; i < orders.length; i++) {
        print("bsjdcfuhb${orders[i].id}  ${order.id}");
        if (orders[i].orderItemId == order.orderItemId) {
          orders[i].changeValures(order);
          break;
        }
      }
      emit(stateAs.copyWith(result: stateAs.result));
    }
  }
}

import 'package:deliveryboy_multivendor/Model/ReturnOrderModel.dart';
import 'package:deliveryboy_multivendor/Repository/returnOrderRepositry.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateStatusReturnOrderState {}

class UpdateStatusReturnOrderInitial extends UpdateStatusReturnOrderState {}

class UpdateStatusReturnOrderInProgress extends UpdateStatusReturnOrderState {}

class UpdateStatusReturnOrderSuccess extends UpdateStatusReturnOrderState {
  final ReturnOrderModel result;
  UpdateStatusReturnOrderSuccess({required this.result});
}

class UpdateStatusReturnOrderFail extends UpdateStatusReturnOrderState {
  final String errorMessage;
  UpdateStatusReturnOrderFail({required this.errorMessage});
}

class UpdateStatusReturnOrderCubit extends Cubit<UpdateStatusReturnOrderState> {
  UpdateStatusReturnOrderCubit() : super(UpdateStatusReturnOrderInitial());

  void updateReturnOrderStatus(
      {required String orderItemId, required String status}) async {
    try {
      emit(UpdateStatusReturnOrderInProgress());
      ReturnOrderModel result = await ReturnOrdersRepository()
          .updateDigitalOrderItemStatus(
              orderItemId: orderItemId, status: status);
      emit(UpdateStatusReturnOrderSuccess(result: result));
    } catch (e) {
      emit(UpdateStatusReturnOrderFail(errorMessage: e.toString()));
    }
  }
}

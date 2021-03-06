import 'package:capstone/business_logic/bloc/bloc.dart';
import 'package:capstone/data/repositories/repositories.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StackUpdateInsideBloc
    extends Bloc<StackUpdateInsideEvent, StackUpdateInsideState> {
  StackUpdateInsideBloc() : super(StackUpdateInsideInitial());
  final StackRepository stackRepository = new StackRepository();

  @override
  Stream<StackUpdateInsideState> mapEventToState(
      StackUpdateInsideEvent event) async* {
    if (event is StackUpdateInsideInitialEvent) {
      yield StackUpdateInsideInitial();
    }
    if (event is StackMapProductEvent) {
      yield* _mapProduct(event.stackId, event.productId, event.action);
    }
    if (event is StackMapCameraEvent) {
      yield* _mapCamera(event.stackId, event.cameraId, event.action);
    }
    if (event is StackChangeStatus) {
      yield* _stackChangeStatus(
          event.stackId, event.statusId, event.reasonInactive);
    }
  }

  Stream<StackUpdateInsideState> _mapProduct(
      String stackId, String productId, int action) async* {
    try {
      yield StackUpdateInsideLoading();
      String response =
          await stackRepository.changeProduct(stackId, productId, action);
      if (response == 'true') {
        yield StackUpdateInsideLoaded();
      } else {
        yield StackUpdateInsideError(response);
      }
    } catch (e) {
      yield StackUpdateInsideError("System can not finish this action");
    }
  }

  Stream<StackUpdateInsideState> _mapCamera(
      String stackId, String cameraId, int action) async* {
    try {
      yield StackUpdateInsideLoading();
      String response =
          await stackRepository.changeCamera(stackId, cameraId, action);
      if (response == 'true') {
        yield StackUpdateInsideLoaded();
      } else {
        yield StackUpdateInsideError(response);
      }
    } catch (e) {
      yield StackUpdateInsideError("System can not finish this action");
    }
  }

  Stream<StackUpdateInsideState> _stackChangeStatus(
      String stackId, int statusId, String reasonInactive) async* {
    try {
      yield StackUpdateInsideLoading();
      String response =
          await stackRepository.changeStatus(stackId, statusId, reasonInactive);
      if (response == 'true') {
        yield StackUpdateInsideLoaded();
      } else {
        yield StackUpdateInsideError(response);
      }
    } catch (e) {
      yield StackUpdateInsideError("System can not finish this action");
    }
  }
}

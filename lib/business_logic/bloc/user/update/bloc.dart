import 'package:capstone/business_logic/bloc/bloc.dart';
import 'package:capstone/data/models/models.dart';
import 'package:capstone/data/repositories/repositories.dart';
import 'package:capstone/data/repositories/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserUpdateBloc extends Bloc<UserUpdateEvent, UserUpdateState> {
  UserUpdateBloc() : super(UserUpdateInitial());

  final UserRepository _usersRepository = new UserRepository();

  @override
  Stream<UserUpdateState> mapEventToState(UserUpdateEvent event) async* {
    if (event is UserUpdateInitialEvent) {
      yield UserUpdateInitial();
    }
    if (event is UserUpdateSubmit) {
      yield* _updateUser(event.user);
    }
  }

  Stream<UserUpdateState> _updateUser(User user) async* {
    try {
      yield UserUpdateLoading();
      print(user.toJson());
      String result = await _usersRepository.updateUser(user);
      if (result == 'true') {
        yield UserUpdateLoaded();
      } else if (result.contains('MSG-055')) {
        yield UserUpdateDuplicatedEmail('Email is existed');
      } else if (result.contains('MSG-056')) {
        yield UserUpdateDuplicateIdentifyCard('IdentifyCard is existed');
      } else if (result.contains('errorCodeAndMsg')) {
        yield UserUpdateError(result);
      }
    } catch (e) {
      yield UserUpdateError(e);
    }
  }
}

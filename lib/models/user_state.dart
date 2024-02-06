import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'user_state.freezed.dart';
part 'user_state.g.dart';

@freezed
class UserState with _$UserState {
  const factory UserState({
    required String realname,
    required String gender,
  }) = _UserState;

  factory UserState.fromJson(Map<String, Object?> json) =>
      _$UserStateFromJson(json);
}

//flutter pub run build_runner build --delete-conflicting-outputs
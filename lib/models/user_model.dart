import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String userPhoneNumber,
    required String userUid,
    required String profileImageUrl,
    required String realName,
    required String nickName,
    required String gender,
    required DateTime birthday,
    required String height,
    required String job,
    required String residence,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, Object?> json) =>
      _$UserModelFromJson(json);
}

//flutter pub run build_runner build --delete-conflicting-outputs
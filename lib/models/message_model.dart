import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'message_model.freezed.dart';
part 'message_model.g.dart';

@freezed
class MessageModel with _$MessageModel {
  const factory MessageModel({
    required String senderUID,
    required String receiverUID,
    required String text,
    required String userUIDs,
    DateTime? timestamp,
  }) = _MessageModel;

  factory MessageModel.fromJson(Map<String, Object?> json) =>
      _$MessageModelFromJson(json);
}

//flutter pub run build_runner build --delete-conflicting-outputs
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'conversation_model.freezed.dart';
part 'conversation_model.g.dart';

@freezed
class ConversationModel with _$ConversationModel {
  const factory ConversationModel({
    required List<String> userUIDs,
    required String lastMessage,
    DateTime? lastMessageTimestamp,
  }) = _ConversationModel;

  factory ConversationModel.fromJson(Map<String, Object?> json) =>
      _$ConversationModelFromJson(json);
}

//flutter pub run build_runner build --delete-conflicting-outputs
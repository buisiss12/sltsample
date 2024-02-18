import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'recent_message_model.freezed.dart';
part 'recent_message_model.g.dart';

@freezed
class RecentMessageModel with _$RecentMessageModel {
  const factory RecentMessageModel({
    required List<String> userUid,
    required String lastMessage,
    DateTime? lastMessageTimestamp,
  }) = _RecentMessageModel;

  factory RecentMessageModel.fromJson(Map<String, Object?> json) =>
      _$RecentMessageModelFromJson(json);
}

//flutter pub run build_runner build --delete-conflicting-outputs
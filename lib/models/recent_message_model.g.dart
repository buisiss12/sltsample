// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recent_message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecentMessageModelImpl _$$RecentMessageModelImplFromJson(
        Map<String, dynamic> json) =>
    _$RecentMessageModelImpl(
      userUid:
          (json['userUid'] as List<dynamic>).map((e) => e as String).toList(),
      lastMessage: json['lastMessage'] as String,
      lastMessageTimestamp: json['lastMessageTimestamp'] == null
          ? null
          : DateTime.parse(json['lastMessageTimestamp'] as String),
    );

Map<String, dynamic> _$$RecentMessageModelImplToJson(
        _$RecentMessageModelImpl instance) =>
    <String, dynamic>{
      'userUid': instance.userUid,
      'lastMessage': instance.lastMessage,
      'lastMessageTimestamp': instance.lastMessageTimestamp?.toIso8601String(),
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recent_message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecentMessageModelImpl _$$RecentMessageModelImplFromJson(
        Map<String, dynamic> json) =>
    _$RecentMessageModelImpl(
      userUIDs:
          (json['userUIDs'] as List<dynamic>).map((e) => e as String).toList(),
      lastMessage: json['lastMessage'] as String,
      lastMessageTimestamp: json['lastMessageTimestamp'] == null
          ? null
          : DateTime.parse(json['lastMessageTimestamp'] as String),
    );

Map<String, dynamic> _$$RecentMessageModelImplToJson(
        _$RecentMessageModelImpl instance) =>
    <String, dynamic>{
      'userUIDs': instance.userUIDs,
      'lastMessage': instance.lastMessage,
      'lastMessageTimestamp': instance.lastMessageTimestamp?.toIso8601String(),
    };

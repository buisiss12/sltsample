// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PostModel _$PostModelFromJson(Map<String, dynamic> json) {
  return _PostModel.fromJson(json);
}

/// @nodoc
mixin _$PostModel {
  String get postId => throw _privateConstructorUsedError;
  String get postedUserUid => throw _privateConstructorUsedError;
  String get postTitle => throw _privateConstructorUsedError;
  List<String> get prefecture => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PostModelCopyWith<PostModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostModelCopyWith<$Res> {
  factory $PostModelCopyWith(PostModel value, $Res Function(PostModel) then) =
      _$PostModelCopyWithImpl<$Res, PostModel>;
  @useResult
  $Res call(
      {String postId,
      String postedUserUid,
      String postTitle,
      List<String> prefecture,
      DateTime timestamp});
}

/// @nodoc
class _$PostModelCopyWithImpl<$Res, $Val extends PostModel>
    implements $PostModelCopyWith<$Res> {
  _$PostModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? postId = null,
    Object? postedUserUid = null,
    Object? postTitle = null,
    Object? prefecture = null,
    Object? timestamp = null,
  }) {
    return _then(_value.copyWith(
      postId: null == postId
          ? _value.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String,
      postedUserUid: null == postedUserUid
          ? _value.postedUserUid
          : postedUserUid // ignore: cast_nullable_to_non_nullable
              as String,
      postTitle: null == postTitle
          ? _value.postTitle
          : postTitle // ignore: cast_nullable_to_non_nullable
              as String,
      prefecture: null == prefecture
          ? _value.prefecture
          : prefecture // ignore: cast_nullable_to_non_nullable
              as List<String>,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PostModelImplCopyWith<$Res>
    implements $PostModelCopyWith<$Res> {
  factory _$$PostModelImplCopyWith(
          _$PostModelImpl value, $Res Function(_$PostModelImpl) then) =
      __$$PostModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String postId,
      String postedUserUid,
      String postTitle,
      List<String> prefecture,
      DateTime timestamp});
}

/// @nodoc
class __$$PostModelImplCopyWithImpl<$Res>
    extends _$PostModelCopyWithImpl<$Res, _$PostModelImpl>
    implements _$$PostModelImplCopyWith<$Res> {
  __$$PostModelImplCopyWithImpl(
      _$PostModelImpl _value, $Res Function(_$PostModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? postId = null,
    Object? postedUserUid = null,
    Object? postTitle = null,
    Object? prefecture = null,
    Object? timestamp = null,
  }) {
    return _then(_$PostModelImpl(
      postId: null == postId
          ? _value.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String,
      postedUserUid: null == postedUserUid
          ? _value.postedUserUid
          : postedUserUid // ignore: cast_nullable_to_non_nullable
              as String,
      postTitle: null == postTitle
          ? _value.postTitle
          : postTitle // ignore: cast_nullable_to_non_nullable
              as String,
      prefecture: null == prefecture
          ? _value._prefecture
          : prefecture // ignore: cast_nullable_to_non_nullable
              as List<String>,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PostModelImpl with DiagnosticableTreeMixin implements _PostModel {
  const _$PostModelImpl(
      {required this.postId,
      required this.postedUserUid,
      required this.postTitle,
      required final List<String> prefecture,
      required this.timestamp})
      : _prefecture = prefecture;

  factory _$PostModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PostModelImplFromJson(json);

  @override
  final String postId;
  @override
  final String postedUserUid;
  @override
  final String postTitle;
  final List<String> _prefecture;
  @override
  List<String> get prefecture {
    if (_prefecture is EqualUnmodifiableListView) return _prefecture;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_prefecture);
  }

  @override
  final DateTime timestamp;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PostModel(postId: $postId, postedUserUid: $postedUserUid, postTitle: $postTitle, prefecture: $prefecture, timestamp: $timestamp)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'PostModel'))
      ..add(DiagnosticsProperty('postId', postId))
      ..add(DiagnosticsProperty('postedUserUid', postedUserUid))
      ..add(DiagnosticsProperty('postTitle', postTitle))
      ..add(DiagnosticsProperty('prefecture', prefecture))
      ..add(DiagnosticsProperty('timestamp', timestamp));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostModelImpl &&
            (identical(other.postId, postId) || other.postId == postId) &&
            (identical(other.postedUserUid, postedUserUid) ||
                other.postedUserUid == postedUserUid) &&
            (identical(other.postTitle, postTitle) ||
                other.postTitle == postTitle) &&
            const DeepCollectionEquality()
                .equals(other._prefecture, _prefecture) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, postId, postedUserUid, postTitle,
      const DeepCollectionEquality().hash(_prefecture), timestamp);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PostModelImplCopyWith<_$PostModelImpl> get copyWith =>
      __$$PostModelImplCopyWithImpl<_$PostModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PostModelImplToJson(
      this,
    );
  }
}

abstract class _PostModel implements PostModel {
  const factory _PostModel(
      {required final String postId,
      required final String postedUserUid,
      required final String postTitle,
      required final List<String> prefecture,
      required final DateTime timestamp}) = _$PostModelImpl;

  factory _PostModel.fromJson(Map<String, dynamic> json) =
      _$PostModelImpl.fromJson;

  @override
  String get postId;
  @override
  String get postedUserUid;
  @override
  String get postTitle;
  @override
  List<String> get prefecture;
  @override
  DateTime get timestamp;
  @override
  @JsonKey(ignore: true)
  _$$PostModelImplCopyWith<_$PostModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

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
  String get useruid => throw _privateConstructorUsedError;
  String get posttitle => throw _privateConstructorUsedError;
  List<String> get todohuken => throw _privateConstructorUsedError;
  DateTime? get timestamp => throw _privateConstructorUsedError;

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
      {String useruid,
      String posttitle,
      List<String> todohuken,
      DateTime? timestamp});
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
    Object? useruid = null,
    Object? posttitle = null,
    Object? todohuken = null,
    Object? timestamp = freezed,
  }) {
    return _then(_value.copyWith(
      useruid: null == useruid
          ? _value.useruid
          : useruid // ignore: cast_nullable_to_non_nullable
              as String,
      posttitle: null == posttitle
          ? _value.posttitle
          : posttitle // ignore: cast_nullable_to_non_nullable
              as String,
      todohuken: null == todohuken
          ? _value.todohuken
          : todohuken // ignore: cast_nullable_to_non_nullable
              as List<String>,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
      {String useruid,
      String posttitle,
      List<String> todohuken,
      DateTime? timestamp});
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
    Object? useruid = null,
    Object? posttitle = null,
    Object? todohuken = null,
    Object? timestamp = freezed,
  }) {
    return _then(_$PostModelImpl(
      useruid: null == useruid
          ? _value.useruid
          : useruid // ignore: cast_nullable_to_non_nullable
              as String,
      posttitle: null == posttitle
          ? _value.posttitle
          : posttitle // ignore: cast_nullable_to_non_nullable
              as String,
      todohuken: null == todohuken
          ? _value._todohuken
          : todohuken // ignore: cast_nullable_to_non_nullable
              as List<String>,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PostModelImpl with DiagnosticableTreeMixin implements _PostModel {
  const _$PostModelImpl(
      {required this.useruid,
      required this.posttitle,
      required final List<String> todohuken,
      this.timestamp})
      : _todohuken = todohuken;

  factory _$PostModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PostModelImplFromJson(json);

  @override
  final String useruid;
  @override
  final String posttitle;
  final List<String> _todohuken;
  @override
  List<String> get todohuken {
    if (_todohuken is EqualUnmodifiableListView) return _todohuken;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_todohuken);
  }

  @override
  final DateTime? timestamp;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PostModel(useruid: $useruid, posttitle: $posttitle, todohuken: $todohuken, timestamp: $timestamp)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'PostModel'))
      ..add(DiagnosticsProperty('useruid', useruid))
      ..add(DiagnosticsProperty('posttitle', posttitle))
      ..add(DiagnosticsProperty('todohuken', todohuken))
      ..add(DiagnosticsProperty('timestamp', timestamp));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostModelImpl &&
            (identical(other.useruid, useruid) || other.useruid == useruid) &&
            (identical(other.posttitle, posttitle) ||
                other.posttitle == posttitle) &&
            const DeepCollectionEquality()
                .equals(other._todohuken, _todohuken) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, useruid, posttitle,
      const DeepCollectionEquality().hash(_todohuken), timestamp);

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
      {required final String useruid,
      required final String posttitle,
      required final List<String> todohuken,
      final DateTime? timestamp}) = _$PostModelImpl;

  factory _PostModel.fromJson(Map<String, dynamic> json) =
      _$PostModelImpl.fromJson;

  @override
  String get useruid;
  @override
  String get posttitle;
  @override
  List<String> get todohuken;
  @override
  DateTime? get timestamp;
  @override
  @JsonKey(ignore: true)
  _$$PostModelImplCopyWith<_$PostModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

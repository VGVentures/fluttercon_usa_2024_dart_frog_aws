/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, override_on_non_overriding_member, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'ModelProvider.dart';
import 'package:amplify_core/amplify_core.dart' as amplify_core;
import 'package:collection/collection.dart';


/** This is an auto generated class representing the Talk type in your schema. */
class Talk extends amplify_core.Model {
  static const classType = const _TalkModelType();
  final String id;
  final String? _title;
  final String? _description;
  final String? _room;
  final amplify_core.TemporalDateTime? _startTime;
  final amplify_core.TemporalDateTime? _endTime;
  final bool? _isFavorite;
  final List<SpeakerTalk>? _speakers;
  final List<FavoritesTalk>? _favorites;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  TalkModelIdentifier get modelIdentifier {
      return TalkModelIdentifier(
        id: id
      );
  }
  
  String? get title {
    return _title;
  }
  
  String? get description {
    return _description;
  }
  
  String? get room {
    return _room;
  }
  
  amplify_core.TemporalDateTime? get startTime {
    return _startTime;
  }
  
  amplify_core.TemporalDateTime? get endTime {
    return _endTime;
  }
  
  bool? get isFavorite {
    return _isFavorite;
  }
  
  List<SpeakerTalk>? get speakers {
    return _speakers;
  }
  
  List<FavoritesTalk>? get favorites {
    return _favorites;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Talk._internal({required this.id, title, description, room, startTime, endTime, isFavorite, speakers, favorites, createdAt, updatedAt}): _title = title, _description = description, _room = room, _startTime = startTime, _endTime = endTime, _isFavorite = isFavorite, _speakers = speakers, _favorites = favorites, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Talk({String? id, String? title, String? description, String? room, amplify_core.TemporalDateTime? startTime, amplify_core.TemporalDateTime? endTime, bool? isFavorite, List<SpeakerTalk>? speakers, List<FavoritesTalk>? favorites}) {
    return Talk._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      title: title,
      description: description,
      room: room,
      startTime: startTime,
      endTime: endTime,
      isFavorite: isFavorite,
      speakers: speakers != null ? List<SpeakerTalk>.unmodifiable(speakers) : speakers,
      favorites: favorites != null ? List<FavoritesTalk>.unmodifiable(favorites) : favorites);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Talk &&
      id == other.id &&
      _title == other._title &&
      _description == other._description &&
      _room == other._room &&
      _startTime == other._startTime &&
      _endTime == other._endTime &&
      _isFavorite == other._isFavorite &&
      DeepCollectionEquality().equals(_speakers, other._speakers) &&
      DeepCollectionEquality().equals(_favorites, other._favorites);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Talk {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("title=" + "$_title" + ", ");
    buffer.write("description=" + "$_description" + ", ");
    buffer.write("room=" + "$_room" + ", ");
    buffer.write("startTime=" + (_startTime != null ? _startTime!.format() : "null") + ", ");
    buffer.write("endTime=" + (_endTime != null ? _endTime!.format() : "null") + ", ");
    buffer.write("isFavorite=" + (_isFavorite != null ? _isFavorite!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Talk copyWith({String? title, String? description, String? room, amplify_core.TemporalDateTime? startTime, amplify_core.TemporalDateTime? endTime, bool? isFavorite, List<SpeakerTalk>? speakers, List<FavoritesTalk>? favorites}) {
    return Talk._internal(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      room: room ?? this.room,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isFavorite: isFavorite ?? this.isFavorite,
      speakers: speakers ?? this.speakers,
      favorites: favorites ?? this.favorites);
  }
  
  Talk copyWithModelFieldValues({
    ModelFieldValue<String?>? title,
    ModelFieldValue<String?>? description,
    ModelFieldValue<String?>? room,
    ModelFieldValue<amplify_core.TemporalDateTime?>? startTime,
    ModelFieldValue<amplify_core.TemporalDateTime?>? endTime,
    ModelFieldValue<bool?>? isFavorite,
    ModelFieldValue<List<SpeakerTalk>?>? speakers,
    ModelFieldValue<List<FavoritesTalk>?>? favorites
  }) {
    return Talk._internal(
      id: id,
      title: title == null ? this.title : title.value,
      description: description == null ? this.description : description.value,
      room: room == null ? this.room : room.value,
      startTime: startTime == null ? this.startTime : startTime.value,
      endTime: endTime == null ? this.endTime : endTime.value,
      isFavorite: isFavorite == null ? this.isFavorite : isFavorite.value,
      speakers: speakers == null ? this.speakers : speakers.value,
      favorites: favorites == null ? this.favorites : favorites.value
    );
  }
  
  Talk.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _title = json['title'],
      _description = json['description'],
      _room = json['room'],
      _startTime = json['startTime'] != null ? amplify_core.TemporalDateTime.fromString(json['startTime']) : null,
      _endTime = json['endTime'] != null ? amplify_core.TemporalDateTime.fromString(json['endTime']) : null,
      _isFavorite = json['isFavorite'],
      _speakers = json['speakers']  is Map
        ? (json['speakers']['items'] is List
          ? (json['speakers']['items'] as List)
              .where((e) => e != null)
              .map((e) => SpeakerTalk.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['speakers'] is List
          ? (json['speakers'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => SpeakerTalk.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _favorites = json['favorites']  is Map
        ? (json['favorites']['items'] is List
          ? (json['favorites']['items'] as List)
              .where((e) => e != null)
              .map((e) => FavoritesTalk.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['favorites'] is List
          ? (json['favorites'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => FavoritesTalk.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'title': _title, 'description': _description, 'room': _room, 'startTime': _startTime?.format(), 'endTime': _endTime?.format(), 'isFavorite': _isFavorite, 'speakers': _speakers?.map((SpeakerTalk? e) => e?.toJson()).toList(), 'favorites': _favorites?.map((FavoritesTalk? e) => e?.toJson()).toList(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'title': _title,
    'description': _description,
    'room': _room,
    'startTime': _startTime,
    'endTime': _endTime,
    'isFavorite': _isFavorite,
    'speakers': _speakers,
    'favorites': _favorites,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<TalkModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<TalkModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final TITLE = amplify_core.QueryField(fieldName: "title");
  static final DESCRIPTION = amplify_core.QueryField(fieldName: "description");
  static final ROOM = amplify_core.QueryField(fieldName: "room");
  static final STARTTIME = amplify_core.QueryField(fieldName: "startTime");
  static final ENDTIME = amplify_core.QueryField(fieldName: "endTime");
  static final ISFAVORITE = amplify_core.QueryField(fieldName: "isFavorite");
  static final SPEAKERS = amplify_core.QueryField(
    fieldName: "speakers",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'SpeakerTalk'));
  static final FAVORITES = amplify_core.QueryField(
    fieldName: "favorites",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'FavoritesTalk'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Talk";
    modelSchemaDefinition.pluralName = "Talks";
    
    modelSchemaDefinition.authRules = [
      amplify_core.AuthRule(
        authStrategy: amplify_core.AuthStrategy.PUBLIC,
        provider: amplify_core.AuthRuleProvider.IAM,
        operations: const [
          amplify_core.ModelOperation.CREATE,
          amplify_core.ModelOperation.UPDATE,
          amplify_core.ModelOperation.DELETE,
          amplify_core.ModelOperation.READ
        ])
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Talk.TITLE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Talk.DESCRIPTION,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Talk.ROOM,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Talk.STARTTIME,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Talk.ENDTIME,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Talk.ISFAVORITE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: Talk.SPEAKERS,
      isRequired: false,
      ofModelName: 'SpeakerTalk',
      associatedKey: SpeakerTalk.TALK
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: Talk.FAVORITES,
      isRequired: false,
      ofModelName: 'FavoritesTalk',
      associatedKey: FavoritesTalk.TALK
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'createdAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'updatedAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _TalkModelType extends amplify_core.ModelType<Talk> {
  const _TalkModelType();
  
  @override
  Talk fromJson(Map<String, dynamic> jsonData) {
    return Talk.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Talk';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Talk] in your schema.
 */
class TalkModelIdentifier implements amplify_core.ModelIdentifier<Talk> {
  final String id;

  /** Create an instance of TalkModelIdentifier using [id] the primary key. */
  const TalkModelIdentifier({
    required this.id});
  
  @override
  Map<String, dynamic> serializeAsMap() => (<String, dynamic>{
    'id': id
  });
  
  @override
  List<Map<String, dynamic>> serializeAsList() => serializeAsMap()
    .entries
    .map((entry) => (<String, dynamic>{ entry.key: entry.value }))
    .toList();
  
  @override
  String serializeAsString() => serializeAsMap().values.join('#');
  
  @override
  String toString() => 'TalkModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is TalkModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}
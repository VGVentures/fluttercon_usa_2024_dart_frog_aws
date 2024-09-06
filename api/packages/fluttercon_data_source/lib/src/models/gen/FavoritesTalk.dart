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


/** This is an auto generated class representing the FavoritesTalk type in your schema. */
class FavoritesTalk extends amplify_core.Model {
  static const classType = const _FavoritesTalkModelType();
  final String id;
  final Favorites? _favorites;
  final Talk? _talk;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  FavoritesTalkModelIdentifier get modelIdentifier {
      return FavoritesTalkModelIdentifier(
        id: id
      );
  }
  
  Favorites? get favorites {
    return _favorites;
  }
  
  Talk? get talk {
    return _talk;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const FavoritesTalk._internal({required this.id, favorites, talk, createdAt, updatedAt}): _favorites = favorites, _talk = talk, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory FavoritesTalk({String? id, Favorites? favorites, Talk? talk}) {
    return FavoritesTalk._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      favorites: favorites,
      talk: talk);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FavoritesTalk &&
      id == other.id &&
      _favorites == other._favorites &&
      _talk == other._talk;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("FavoritesTalk {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("favorites=" + (_favorites != null ? _favorites!.toString() : "null") + ", ");
    buffer.write("talk=" + (_talk != null ? _talk!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  FavoritesTalk copyWith({Favorites? favorites, Talk? talk}) {
    return FavoritesTalk._internal(
      id: id,
      favorites: favorites ?? this.favorites,
      talk: talk ?? this.talk);
  }
  
  FavoritesTalk copyWithModelFieldValues({
    ModelFieldValue<Favorites?>? favorites,
    ModelFieldValue<Talk?>? talk
  }) {
    return FavoritesTalk._internal(
      id: id,
      favorites: favorites == null ? this.favorites : favorites.value,
      talk: talk == null ? this.talk : talk.value
    );
  }
  
  FavoritesTalk.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _favorites = json['favorites'] != null
        ? json['favorites']['serializedData'] != null
          ? Favorites.fromJson(new Map<String, dynamic>.from(json['favorites']['serializedData']))
          : Favorites.fromJson(new Map<String, dynamic>.from(json['favorites']))
        : null,
      _talk = json['talk'] != null
        ? json['talk']['serializedData'] != null
          ? Talk.fromJson(new Map<String, dynamic>.from(json['talk']['serializedData']))
          : Talk.fromJson(new Map<String, dynamic>.from(json['talk']))
        : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'favorites': _favorites?.toJson(), 'talk': _talk?.toJson(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'favorites': _favorites,
    'talk': _talk,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<FavoritesTalkModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<FavoritesTalkModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final FAVORITES = amplify_core.QueryField(
    fieldName: "favorites",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Favorites'));
  static final TALK = amplify_core.QueryField(
    fieldName: "talk",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Talk'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "FavoritesTalk";
    modelSchemaDefinition.pluralName = "FavoritesTalks";
    
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
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: FavoritesTalk.FAVORITES,
      isRequired: false,
      targetNames: ['favoritesId'],
      ofModelName: 'Favorites'
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: FavoritesTalk.TALK,
      isRequired: false,
      targetNames: ['talkId'],
      ofModelName: 'Talk'
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

class _FavoritesTalkModelType extends amplify_core.ModelType<FavoritesTalk> {
  const _FavoritesTalkModelType();
  
  @override
  FavoritesTalk fromJson(Map<String, dynamic> jsonData) {
    return FavoritesTalk.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'FavoritesTalk';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [FavoritesTalk] in your schema.
 */
class FavoritesTalkModelIdentifier implements amplify_core.ModelIdentifier<FavoritesTalk> {
  final String id;

  /** Create an instance of FavoritesTalkModelIdentifier using [id] the primary key. */
  const FavoritesTalkModelIdentifier({
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
  String toString() => 'FavoritesTalkModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is FavoritesTalkModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}
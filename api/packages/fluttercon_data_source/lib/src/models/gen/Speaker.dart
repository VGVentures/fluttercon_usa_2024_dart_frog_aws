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


/** This is an auto generated class representing the Speaker type in your schema. */
class Speaker extends amplify_core.Model {
  static const classType = const _SpeakerModelType();
  final String id;
  final String? _name;
  final String? _title;
  final String? _bio;
  final String? _imageUrl;
  final List<Link>? _links;
  final List<SpeakerTalk>? _talks;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  SpeakerModelIdentifier get modelIdentifier {
      return SpeakerModelIdentifier(
        id: id
      );
  }
  
  String? get name {
    return _name;
  }
  
  String? get title {
    return _title;
  }
  
  String? get bio {
    return _bio;
  }
  
  String? get imageUrl {
    return _imageUrl;
  }
  
  List<Link>? get links {
    return _links;
  }
  
  List<SpeakerTalk>? get talks {
    return _talks;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Speaker._internal({required this.id, name, title, bio, imageUrl, links, talks, createdAt, updatedAt}): _name = name, _title = title, _bio = bio, _imageUrl = imageUrl, _links = links, _talks = talks, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Speaker({String? id, String? name, String? title, String? bio, String? imageUrl, List<Link>? links, List<SpeakerTalk>? talks}) {
    return Speaker._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      name: name,
      title: title,
      bio: bio,
      imageUrl: imageUrl,
      links: links != null ? List<Link>.unmodifiable(links) : links,
      talks: talks != null ? List<SpeakerTalk>.unmodifiable(talks) : talks);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Speaker &&
      id == other.id &&
      _name == other._name &&
      _title == other._title &&
      _bio == other._bio &&
      _imageUrl == other._imageUrl &&
      DeepCollectionEquality().equals(_links, other._links) &&
      DeepCollectionEquality().equals(_talks, other._talks);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Speaker {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("name=" + "$_name" + ", ");
    buffer.write("title=" + "$_title" + ", ");
    buffer.write("bio=" + "$_bio" + ", ");
    buffer.write("imageUrl=" + "$_imageUrl" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Speaker copyWith({String? name, String? title, String? bio, String? imageUrl, List<Link>? links, List<SpeakerTalk>? talks}) {
    return Speaker._internal(
      id: id,
      name: name ?? this.name,
      title: title ?? this.title,
      bio: bio ?? this.bio,
      imageUrl: imageUrl ?? this.imageUrl,
      links: links ?? this.links,
      talks: talks ?? this.talks);
  }
  
  Speaker copyWithModelFieldValues({
    ModelFieldValue<String?>? name,
    ModelFieldValue<String?>? title,
    ModelFieldValue<String?>? bio,
    ModelFieldValue<String?>? imageUrl,
    ModelFieldValue<List<Link>?>? links,
    ModelFieldValue<List<SpeakerTalk>?>? talks
  }) {
    return Speaker._internal(
      id: id,
      name: name == null ? this.name : name.value,
      title: title == null ? this.title : title.value,
      bio: bio == null ? this.bio : bio.value,
      imageUrl: imageUrl == null ? this.imageUrl : imageUrl.value,
      links: links == null ? this.links : links.value,
      talks: talks == null ? this.talks : talks.value
    );
  }
  
  Speaker.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _name = json['name'],
      _title = json['title'],
      _bio = json['bio'],
      _imageUrl = json['imageUrl'],
      _links = json['links']  is Map
        ? (json['links']['items'] is List
          ? (json['links']['items'] as List)
              .where((e) => e != null)
              .map((e) => Link.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['links'] is List
          ? (json['links'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => Link.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _talks = json['talks']  is Map
        ? (json['talks']['items'] is List
          ? (json['talks']['items'] as List)
              .where((e) => e != null)
              .map((e) => SpeakerTalk.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['talks'] is List
          ? (json['talks'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => SpeakerTalk.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'name': _name, 'title': _title, 'bio': _bio, 'imageUrl': _imageUrl, 'links': _links?.map((Link? e) => e?.toJson()).toList(), 'talks': _talks?.map((SpeakerTalk? e) => e?.toJson()).toList(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'name': _name,
    'title': _title,
    'bio': _bio,
    'imageUrl': _imageUrl,
    'links': _links,
    'talks': _talks,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<SpeakerModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<SpeakerModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final NAME = amplify_core.QueryField(fieldName: "name");
  static final TITLE = amplify_core.QueryField(fieldName: "title");
  static final BIO = amplify_core.QueryField(fieldName: "bio");
  static final IMAGEURL = amplify_core.QueryField(fieldName: "imageUrl");
  static final LINKS = amplify_core.QueryField(
    fieldName: "links",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Link'));
  static final TALKS = amplify_core.QueryField(
    fieldName: "talks",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'SpeakerTalk'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Speaker";
    modelSchemaDefinition.pluralName = "Speakers";
    
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
      key: Speaker.NAME,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Speaker.TITLE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Speaker.BIO,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Speaker.IMAGEURL,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: Speaker.LINKS,
      isRequired: false,
      ofModelName: 'Link',
      associatedKey: Link.SPEAKER
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: Speaker.TALKS,
      isRequired: false,
      ofModelName: 'SpeakerTalk',
      associatedKey: SpeakerTalk.SPEAKER
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

class _SpeakerModelType extends amplify_core.ModelType<Speaker> {
  const _SpeakerModelType();
  
  @override
  Speaker fromJson(Map<String, dynamic> jsonData) {
    return Speaker.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Speaker';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Speaker] in your schema.
 */
class SpeakerModelIdentifier implements amplify_core.ModelIdentifier<Speaker> {
  final String id;

  /** Create an instance of SpeakerModelIdentifier using [id] the primary key. */
  const SpeakerModelIdentifier({
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
  String toString() => 'SpeakerModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is SpeakerModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}
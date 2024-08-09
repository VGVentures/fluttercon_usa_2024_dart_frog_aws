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


/** This is an auto generated class representing the Link type in your schema. */
class Link extends amplify_core.Model {
  static const classType = const _LinkModelType();
  final String id;
  final LinkType? _type;
  final String? _url;
  final String? _description;
  final Speaker? _speaker;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  LinkModelIdentifier get modelIdentifier {
      return LinkModelIdentifier(
        id: id
      );
  }
  
  LinkType? get type {
    return _type;
  }
  
  String? get url {
    return _url;
  }
  
  String? get description {
    return _description;
  }
  
  Speaker? get speaker {
    return _speaker;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Link._internal({required this.id, type, url, description, speaker, createdAt, updatedAt}): _type = type, _url = url, _description = description, _speaker = speaker, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Link({String? id, LinkType? type, String? url, String? description, Speaker? speaker}) {
    return Link._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      type: type,
      url: url,
      description: description,
      speaker: speaker);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Link &&
      id == other.id &&
      _type == other._type &&
      _url == other._url &&
      _description == other._description &&
      _speaker == other._speaker;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Link {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("type=" + (_type != null ? amplify_core.enumToString(_type)! : "null") + ", ");
    buffer.write("url=" + "$_url" + ", ");
    buffer.write("description=" + "$_description" + ", ");
    buffer.write("speaker=" + (_speaker != null ? _speaker!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Link copyWith({LinkType? type, String? url, String? description, Speaker? speaker}) {
    return Link._internal(
      id: id,
      type: type ?? this.type,
      url: url ?? this.url,
      description: description ?? this.description,
      speaker: speaker ?? this.speaker);
  }
  
  Link copyWithModelFieldValues({
    ModelFieldValue<LinkType?>? type,
    ModelFieldValue<String?>? url,
    ModelFieldValue<String?>? description,
    ModelFieldValue<Speaker?>? speaker
  }) {
    return Link._internal(
      id: id,
      type: type == null ? this.type : type.value,
      url: url == null ? this.url : url.value,
      description: description == null ? this.description : description.value,
      speaker: speaker == null ? this.speaker : speaker.value
    );
  }
  
  Link.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _type = amplify_core.enumFromString<LinkType>(json['type'], LinkType.values),
      _url = json['url'],
      _description = json['description'],
      _speaker = json['speaker'] != null
        ? json['speaker']['serializedData'] != null
          ? Speaker.fromJson(new Map<String, dynamic>.from(json['speaker']['serializedData']))
          : Speaker.fromJson(new Map<String, dynamic>.from(json['speaker']))
        : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'type': amplify_core.enumToString(_type), 'url': _url, 'description': _description, 'speaker': _speaker?.toJson(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'type': _type,
    'url': _url,
    'description': _description,
    'speaker': _speaker,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<LinkModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<LinkModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final TYPE = amplify_core.QueryField(fieldName: "type");
  static final URL = amplify_core.QueryField(fieldName: "url");
  static final DESCRIPTION = amplify_core.QueryField(fieldName: "description");
  static final SPEAKER = amplify_core.QueryField(
    fieldName: "speaker",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Speaker'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Link";
    modelSchemaDefinition.pluralName = "Links";
    
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
      key: Link.TYPE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.enumeration)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Link.URL,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Link.DESCRIPTION,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: Link.SPEAKER,
      isRequired: false,
      targetNames: ['speakerId'],
      ofModelName: 'Speaker'
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

class _LinkModelType extends amplify_core.ModelType<Link> {
  const _LinkModelType();
  
  @override
  Link fromJson(Map<String, dynamic> jsonData) {
    return Link.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Link';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Link] in your schema.
 */
class LinkModelIdentifier implements amplify_core.ModelIdentifier<Link> {
  final String id;

  /** Create an instance of LinkModelIdentifier using [id] the primary key. */
  const LinkModelIdentifier({
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
  String toString() => 'LinkModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is LinkModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}
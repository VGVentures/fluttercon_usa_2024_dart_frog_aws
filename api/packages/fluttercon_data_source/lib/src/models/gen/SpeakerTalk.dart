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


/** This is an auto generated class representing the SpeakerTalk type in your schema. */
class SpeakerTalk extends amplify_core.Model {
  static const classType = const _SpeakerTalkModelType();
  final String id;
  final Speaker? _speaker;
  final Talk? _talk;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  SpeakerTalkModelIdentifier get modelIdentifier {
      return SpeakerTalkModelIdentifier(
        id: id
      );
  }
  
  Speaker? get speaker {
    return _speaker;
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
  
  const SpeakerTalk._internal({required this.id, speaker, talk, createdAt, updatedAt}): _speaker = speaker, _talk = talk, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory SpeakerTalk({String? id, Speaker? speaker, Talk? talk}) {
    return SpeakerTalk._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      speaker: speaker,
      talk: talk);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SpeakerTalk &&
      id == other.id &&
      _speaker == other._speaker &&
      _talk == other._talk;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("SpeakerTalk {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("speaker=" + (_speaker != null ? _speaker!.toString() : "null") + ", ");
    buffer.write("talk=" + (_talk != null ? _talk!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  SpeakerTalk copyWith({Speaker? speaker, Talk? talk}) {
    return SpeakerTalk._internal(
      id: id,
      speaker: speaker ?? this.speaker,
      talk: talk ?? this.talk);
  }
  
  SpeakerTalk copyWithModelFieldValues({
    ModelFieldValue<Speaker?>? speaker,
    ModelFieldValue<Talk?>? talk
  }) {
    return SpeakerTalk._internal(
      id: id,
      speaker: speaker == null ? this.speaker : speaker.value,
      talk: talk == null ? this.talk : talk.value
    );
  }
  
  SpeakerTalk.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _speaker = json['speaker'] != null
        ? json['speaker']['serializedData'] != null
          ? Speaker.fromJson(new Map<String, dynamic>.from(json['speaker']['serializedData']))
          : Speaker.fromJson(new Map<String, dynamic>.from(json['speaker']))
        : null,
      _talk = json['talk'] != null
        ? json['talk']['serializedData'] != null
          ? Talk.fromJson(new Map<String, dynamic>.from(json['talk']['serializedData']))
          : Talk.fromJson(new Map<String, dynamic>.from(json['talk']))
        : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'speaker': _speaker?.toJson(), 'talk': _talk?.toJson(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'speaker': _speaker,
    'talk': _talk,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<SpeakerTalkModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<SpeakerTalkModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final SPEAKER = amplify_core.QueryField(
    fieldName: "speaker",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Speaker'));
  static final TALK = amplify_core.QueryField(
    fieldName: "talk",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Talk'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "SpeakerTalk";
    modelSchemaDefinition.pluralName = "SpeakerTalks";
    
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
      key: SpeakerTalk.SPEAKER,
      isRequired: false,
      targetNames: ['speakerId'],
      ofModelName: 'Speaker'
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: SpeakerTalk.TALK,
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

class _SpeakerTalkModelType extends amplify_core.ModelType<SpeakerTalk> {
  const _SpeakerTalkModelType();
  
  @override
  SpeakerTalk fromJson(Map<String, dynamic> jsonData) {
    return SpeakerTalk.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'SpeakerTalk';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [SpeakerTalk] in your schema.
 */
class SpeakerTalkModelIdentifier implements amplify_core.ModelIdentifier<SpeakerTalk> {
  final String id;

  /** Create an instance of SpeakerTalkModelIdentifier using [id] the primary key. */
  const SpeakerTalkModelIdentifier({
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
  String toString() => 'SpeakerTalkModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is SpeakerTalkModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}
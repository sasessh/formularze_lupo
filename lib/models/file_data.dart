import 'check_item.dart';

class FileData {
  final String form;
  final String title;
  final int version;
  final String description;
  final String createdBy;
  final String creationValidatedBy;
  final String createdDate;
  final String modifiedBy;
  final String modifiedDate;
  final String modificationValidatedBy;
  final List<CheckItem> checks;
  final String? localId;

  FileData({
    required this.form,
    required this.title,
    this.version = 1,
    this.description = '',
    this.createdBy = '',
    this.creationValidatedBy = '',
    this.createdDate = '',
    this.modifiedBy = '',
    this.modifiedDate = '',
    this.modificationValidatedBy = '',
    required this.checks,
    this.localId,
  });

  FileData copyWith({
    String? form,
    String? title,
    int? version,
    String? description,
    String? createdBy,
    String? creationValidatedBy,
    String? createdDate,
    String? modifiedBy,
    String? modifiedDate,
    String? modificationValidatedBy,
    List<CheckItem>? checks,
    String? localId,
  }) {
    return FileData(
      form: form ?? this.form,
      title: title ?? this.title,
      version: version ?? this.version,
      description: description ?? this.description,
      createdBy: createdBy ?? this.createdBy,
      creationValidatedBy: creationValidatedBy ?? this.creationValidatedBy,
      createdDate: createdDate ?? this.createdDate,
      modifiedBy: modifiedBy ?? this.modifiedBy,
      modifiedDate: modifiedDate ?? this.modifiedDate,
      modificationValidatedBy:
          modificationValidatedBy ?? this.modificationValidatedBy,
      checks: checks ?? this.checks,
      localId: localId ?? this.localId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'form': form,
      'title': title,
      'version': version,
      'description': description,
      'created_by': createdBy,
      'creation_validated_by': creationValidatedBy,
      'created_date': createdDate,
      'modified_by': modifiedBy,
      'modified_date': modifiedDate,
      'modification_validated_by': modificationValidatedBy,
      'checks': checks.map((e) => e.toJson()).toList(),
      if (localId != null) 'local_id': localId,
    };
  }

  factory FileData.fromJson(Map<String, dynamic> json) {
    return FileData(
      form: json['form']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      version: json['version'] ?? 1,
      description: json['description']?.toString() ?? '',
      createdBy: json['created_by']?.toString() ?? '',
      creationValidatedBy: json['creation_validated_by']?.toString() ?? '',
      createdDate: json['created_date']?.toString() ?? '',
      modifiedBy: json['modified_by']?.toString() ?? '',
      modifiedDate: json['modified_date']?.toString() ?? '',
      modificationValidatedBy:
          json['modification_validated_by']?.toString() ?? '',
      checks:
          (json['checks'] as List<dynamic>? ?? [])
              .map((e) => CheckItem.fromJson(e as Map<String, dynamic>))
              .toList(),
      localId: json['local_id']?.toString(),
    );
  }
}

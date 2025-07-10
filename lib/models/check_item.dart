class CheckItem {
  final String type;
  final String text;
  final String? value;
  final List<String>? options;
  final String? selected;
  final bool inFilename;
  final bool optional;
  final bool used;
  final List<CheckItem>? children;

  CheckItem({
    required this.type,
    required this.text,
    this.value,
    this.options,
    this.selected,
    this.inFilename = false,
    this.optional = false,
    this.used = false,
    this.children,
  });

  CheckItem copy({
    String? type,
    String? text,
    String? value,
    List<String>? options,
    String? selected,
    bool? inFilename,
    bool? optional,
    bool? used,
    List<CheckItem>? children,
  }) {
    return CheckItem(
      type: type ?? this.type,
      text: text ?? this.text,
      value: value ?? this.value,
      options: options ?? this.options,
      selected: selected ?? this.selected,
      inFilename: inFilename ?? this.inFilename,
      optional: optional ?? this.optional,
      used: used ?? this.used,
      children: children ?? this.children,
    );
  }

  CheckItem copyWith({
    String? type,
    String? text,
    dynamic value,
    List<String>? options,
    String? selected,
    bool? inFilename,
    bool? optional,
    bool? used,
    List<CheckItem>? children,
  }) {
    return CheckItem(
      type: type ?? this.type,
      text: text ?? this.text,
      value: value ?? this.value,
      options: options ?? this.options,
      selected: selected ?? this.selected,
      inFilename: inFilename ?? this.inFilename,
      optional: optional ?? this.optional,
      used: used ?? this.used,
      children: children ?? this.children,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{'type': type, 'text': text};

    switch (type) {
      case 'text':
      case 'number':
      case 'decimal':
      case 'datetime':
      case '3-tap':
      case '2-tap':
        if (value != null) map['value'] = value;
        break;
      case 'list':
        if (options != null) map['options'] = options;
        if (selected != null) map['selected'] = selected;
        break;
      case 'group':
        if (optional) map['optional'] = optional;
        if (used) map['used'] = used;
        if (children != null) {
          map['children'] = children!.map((e) => e.toJson()).toList();
        }
        break;
    }

    if (inFilename) map['in_filename'] = true;

    return map;
  }

  factory CheckItem.fromJson(Map<String, dynamic> json) {
    return CheckItem(
      type: json['type'] ?? '',
      text: json['text'] ?? '',
      value: json['value'],
      options: (json['options'] as List?)?.map((e) => e.toString()).toList(),
      selected: json['selected'],
      inFilename: json['in_filename'] == true,
      optional: json['optional'] == true,
      used: json['used'] == true,
      children:
          (json['children'] as List<dynamic>?)
              ?.map((e) => CheckItem.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }
}

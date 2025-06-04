class Exercise {
  Exercise({
    String? name,
    String? description,
    num? duration,
    String? difficulty,
    String? id,
    bool? isCompleted,
  }) {
    _name = name;
    _description = description;
    _duration = duration;
    _difficulty = difficulty;
    _id = id;
    _isCompleted = isCompleted;
  }

  Exercise.fromJson(dynamic json) {
    _name = json['name'];
    _description = json['description'];
    _duration = json['duration'];
    _difficulty = json['difficulty'];
    _id = json['id'];
    _isCompleted = false;
  }

  String? _name;
  String? _description;
  num? _duration;
  String? _difficulty;
  String? _id;
  bool? _isCompleted;
  Exercise copyWith({
    String? name,
    String? description,
    num? duration,
    String? difficulty,
    String? id,
    bool? isCompleted,
  }) => Exercise(
    name: name ?? _name,
    description: description ?? _description,
    duration: duration ?? _duration,
    difficulty: difficulty ?? _difficulty,
    id: id ?? _id,
    isCompleted: isCompleted ?? _isCompleted,
  );
  String? get name => _name;
  String? get description => _description;
  num? get duration => _duration;
  String? get difficulty => _difficulty;
  String? get id => _id;
  bool? get isCompleted => _isCompleted;

  set completed(bool value) => _isCompleted = value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['description'] = _description;
    map['duration'] = _duration;
    map['difficulty'] = _difficulty;
    map['id'] = _id;
    map['isCompleted'] = _isCompleted;
    return map;
  }
}

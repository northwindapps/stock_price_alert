class Task {
  final String name;
  final String lowerLimit;
  final String higherLimit;
  bool isDone;

  Task(
      {required this.name,
      required this.lowerLimit,
      required this.higherLimit,
      this.isDone = false});

  Task.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        lowerLimit = json['lowerLimit'],
        higherLimit = json['higherLimit'],
        isDone = json['isDone'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'lowerLimit': lowerLimit,
        'higherLimit': higherLimit,
        'isDone': isDone,
      };

  void toggleDone() {
    isDone = !isDone;
  }
}

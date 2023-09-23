class Task {
  final String name;
  final String lowerLimit;
  final String higherLimit;
  final int stockType;
  bool isDone;

  Task(
      {required this.name,
      required this.lowerLimit,
      required this.higherLimit,
      required this.stockType,
      this.isDone = false});

  Task.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        lowerLimit = json['lowerLimit'],
        higherLimit = json['higherLimit'],
        stockType = json['stockType'],
        isDone = json['isDone'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'lowerLimit': lowerLimit,
        'higherLimit': higherLimit,
        'stockType': stockType,
        'isDone': isDone,
      };

  void toggleDone() {
    isDone = !isDone;
  }
}

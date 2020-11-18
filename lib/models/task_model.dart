class Task {
  String id;
  String name;
  Duration lastTotal;
  DateTime lastStart;
  bool active;

  Task({this.id, this.name, this.lastTotal, this.lastStart, this.active});

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    lastTotal = Duration(seconds: json['lastTotal']);
    lastStart = DateTime.parse(json['lastStart']);
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['lastTotal'] = this.lastTotal.inSeconds;
    data['lastStart'] = this.lastStart.toString();
    data['active'] = this.active;
    return data;
  }
}
